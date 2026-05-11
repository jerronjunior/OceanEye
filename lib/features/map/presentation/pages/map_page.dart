import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/map_styles.dart';
import '../../domain/models/map_marker_model.dart';
import '../../domain/models/mock_map_data.dart';
import '../widgets/map_search_bar.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/map_layer_toggle.dart';
import '../widgets/nearby_stats_card.dart';
import '../widgets/marker_detail_sheet.dart';
import '../widgets/route_info_card.dart';
import '../widgets/floating_map_actions.dart';
import '../widgets/smart_alert_banner.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {
  // ── Map controller ──────────────────────────────
  final Completer<GoogleMapController> _mapCompleter = Completer();
  GoogleMapController? _mapController;

  // ── State ────────────────────────────────────────
  MapLayerType _layerType = MapLayerType.standard;
  MapFilterState _filterState = const MapFilterState();
  bool _heatmapVisible = false;
  bool _showAlert = false;
  bool _showRoute = false;
  LatLng? _userLocation;
  OceanMapMarker? _routeTarget;
  Set<Polyline> _polylines = {};
  
  // ── Markers ──────────────────────────────────────
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();

    _buildMarkers();
    _requestLocation();

    // Simulate entering polluted zone after 4s
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) setState(() => _showAlert = true);
    });
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  // ── Location ─────────────────────────────────────
  Future<void> _requestLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.deniedForever) return;

      final pos = await Geolocator.getCurrentPosition();
      setState(() {
        _userLocation = LatLng(pos.latitude, pos.longitude);
      });
      _addUserMarker();
    } catch (_) {
      // Use demo location if permission denied
      setState(() => _userLocation = const LatLng(1.3521, 103.8198));
      _addUserMarker();
    }
  }

  void _addUserMarker() {
    if (_userLocation == null) return;
    final userMarker = Marker(
      markerId: const MarkerId('user_location'),
      position: _userLocation!,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      infoWindow: const InfoWindow(title: 'You are here'),
      zIndex: 10,
    );
    setState(() {
      _markers = {..._markers, userMarker};
    });
  }

  // ── Markers builder ───────────────────────────────
  void _buildMarkers() {
    final markers = <Marker>{};
    for (final m in MockMapData.markers) {
      if (!_filterState.selectedMarkerTypes.contains(m.type)) continue;
      markers.add(_buildMarker(m));
    }
    setState(() => _markers = markers);
    _addUserMarker();
  }

  Marker _buildMarker(OceanMapMarker m) {
    BitmapDescriptor icon;
    switch (m.type) {
      case MarkerType.cleanup:
        icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
        break;
      case MarkerType.recycling:
        icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan);
        break;
      case MarkerType.userLocation:
        icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
        break;
      case MarkerType.pollution:
        icon = m.severity?.bitmapDescriptor ??
            BitmapDescriptor.defaultMarker;
        break;
    }

    return Marker(
      markerId: MarkerId(m.id),
      position: m.position,
      icon: icon,
      infoWindow: InfoWindow(title: m.title, snippet: m.subtitle),
      onTap: () => _onMarkerTap(m),
    );
  }

  void _onMarkerTap(OceanMapMarker m) {
    MarkerDetailSheet.show(
      context, 
      m,
      onDirectionsTap: () => _showRouteToMarker(m),
    );
  }

  // ── Map controller ready ──────────────────────────
  void _onMapCreated(GoogleMapController controller) {
    if (!_mapCompleter.isCompleted) {
      _mapCompleter.complete(controller);
    }
    _mapController = controller;
    _applyMapStyle();
  }

  Future<void> _applyMapStyle() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    await _mapController?.setMapStyle(
        isDark ? kOceanMapStyle : kLightMapStyle);
  }

  // ── Layer change ──────────────────────────────────
  void _onLayerChanged(MapLayerType type) {
    setState(() {
      _layerType = type;
      _heatmapVisible = type == MapLayerType.heatmap;
    });
  }

  // ── Recenter ──────────────────────────────────────
  Future<void> _recenter() async {
    final target = _userLocation ?? MockMapData.defaultCenter;
    await _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: target, zoom: 13),
      ),
    );
  }

  // ── Route simulation ──────────────────────────────
  void _showRouteToMarker(OceanMapMarker m) {
    final start = _userLocation ?? MockMapData.defaultCenter;
    final end = m.position;

    // Draw a simple straight-line polyline (in production use Directions API)
    final poly = Polyline(
      polylineId: const PolylineId('route'),
      points: [start, end],
      color: AppTheme.primaryBlue,
      width: 4,
      patterns: [PatternItem.dash(20), PatternItem.gap(10)],
    );

    setState(() {
      _polylines = {poly};
      _routeTarget = m;
      _showRoute = true;
    });

    // Fit camera to show both points
    _fitRoute(start, end);
  }

  Future<void> _fitRoute(LatLng start, LatLng end) async {
    final bounds = LatLngBounds(
      southwest: LatLng(
        math.min(start.latitude, end.latitude),
        math.min(start.longitude, end.longitude),
      ),
      northeast: LatLng(
        math.max(start.latitude, end.latitude),
        math.max(start.longitude, end.longitude),
      ),
    );
    await _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 60),
    );
  }

  double _routeDistance() {
    if (_routeTarget == null || _userLocation == null) return 0;
    final start = _userLocation!;
    final end = _routeTarget!.position;
    final distInMeters = Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );
    return distInMeters / 1000;
  }

  // ── Heatmap circles (simulated) ───────────────────
  Set<Circle> _buildHeatmapCircles() {
    if (!_heatmapVisible) return {};
    const colors = [
      Color(0xAAE63946),
      Color(0xAAFFB703),
      Color(0xAA52B788),
    ];
    return MockMapData.heatmapPoints.asMap().entries.map((e) {
      final color = colors[e.key % colors.length];
      return Circle(
        circleId: CircleId('heat_${e.key}'),
        center: e.value,
        radius: 600,
        fillColor: color.withOpacity(0.25),
        strokeColor: color.withOpacity(0.5),
        strokeWidth: 1,
      );
    }).toSet();
  }

  MapType get _googleMapType {
    switch (_layerType) {
      case MapLayerType.satellite:
        return MapType.satellite;
      case MapLayerType.terrain:
        return MapType.terrain;
      default:
        return MapType.normal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final topPad = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // ── Google Map ─────────────────────────
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: const CameraPosition(
                target: MockMapData.defaultCenter,
                zoom: 12.0,
              ),
              mapType: _googleMapType,
              markers: _markers,
              circles: _buildHeatmapCircles(),
              polylines: _polylines,
              myLocationEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              compassEnabled: false,
              onTap: (_) {
                // Dismiss alert on map tap
                if (_showAlert) setState(() => _showAlert = false);
              },
            ),

            // ── Overlays ────────────────────────────
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.only(top: topPad),
                child: Column(
                  children: [
                    // ── Top bar ──────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: Column(
                        children: [
                          // Alert banner
                          if (_showAlert) ...[
                            SmartAlertBanner(
                              message:
                                  'High marine pollution detected nearby. Help report or join a cleanup.',
                              onDismiss: () =>
                                  setState(() => _showAlert = false),
                              onAction: () {
                                setState(() => _showAlert = false);
                                if (MockMapData.markers.isNotEmpty) {
                                  _onMarkerTap(MockMapData.markers.first);
                                }
                              },
                            ),
                            const SizedBox(height: 10),
                          ],
                          // Search bar
                          MapSearchBar(
                            onSearch: (_) {},
                            onFilterTap: () => FilterBottomSheet.show(
                              context,
                              initialFilter: _filterState,
                              onApply: (f) {
                                setState(() => _filterState = f);
                                _buildMarkers();
                              },
                            ),
                            onLocationTap: _recenter,
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // ── Bottom controls ───────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Route info card
                          if (_showRoute && _routeTarget != null) ...[
                            RouteInfoCard(
                              destination: _routeTarget!.title,
                              distanceKm: _routeDistance(),
                              estimatedMinutes:
                                  (_routeDistance() / 0.07).round(),
                              onDismiss: () => setState(() {
                                _showRoute = false;
                                _polylines = {};
                                _routeTarget = null;
                              }),
                            ),
                            const SizedBox(height: 12),
                          ],

                          // Layer toggle
                          Align(
                            alignment: Alignment.centerLeft,
                            child: MapLayerToggle(
                              selected: _layerType,
                              onChanged: _onLayerChanged,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Nearby stats + FAB row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Nearby stats
                              Expanded(child: const NearbyStatsCard()),
                              const SizedBox(width: 14),
                              // FABs
                              FloatingMapActions(
                                heatmapActive: _heatmapVisible,
                                onScanTap: () {},
                                onReportTap: () {},
                                onRecenterTap: _recenter,
                                onHeatmapTap: () {
                                  setState(() {
                                    _heatmapVisible = !_heatmapVisible;
                                    _layerType = _heatmapVisible
                                        ? MapLayerType.heatmap
                                        : MapLayerType.standard;
                                  });
                                },
                              ),
                            ],
                          ),

                          // Safe bottom padding
                          SizedBox(
                              height: MediaQuery.of(context).padding.bottom),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Legend ──────────────────────────────
            Positioned(
              top: topPad + 82,
              left: 16,
              child: _MapLegend(isDark: isDark),
            ),

            // ── Active filter badge ──────────────────
            if (_filterState.hasActiveFilters)
              Positioned(
                top: topPad + 70,
                right: 20,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryBlue.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.tune_rounded,
                          color: Colors.white, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        'Filters active',
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Map legend widget ──────────────────────────────
class _MapLegend extends StatefulWidget {
  final bool isDark;

  const _MapLegend({required this.isDark});

  @override
  State<_MapLegend> createState() => _MapLegendState();
}

class _MapLegendState extends State<_MapLegend> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _visible = !_visible),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: widget.isDark
              ? Colors.black.withOpacity(0.6)
              : Colors.white.withOpacity(0.92),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: widget.isDark
                ? Colors.white.withOpacity(0.12)
                : Colors.white,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.legend_toggle_outlined,
                    size: 14,
                    color: widget.isDark ? Colors.white60 : Colors.grey[600]),
                const SizedBox(width: 5),
                Text(
                  'Legend',
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: widget.isDark ? Colors.white70 : Colors.grey[700],
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  _visible
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 14,
                  color: widget.isDark ? Colors.white38 : Colors.grey[400],
                ),
              ],
            ),
            if (_visible) ...[
              const SizedBox(height: 8),
              _LegendItem(color: const Color(0xFFE63946), label: 'Critical'),
              _LegendItem(color: const Color(0xFFFB8500), label: 'High'),
              _LegendItem(color: const Color(0xFFFFB703), label: 'Medium'),
              _LegendItem(color: const Color(0xFF52B788), label: 'Low / Cleaned'),
              _LegendItem(color: AppTheme.primaryBlue, label: 'Cleanup Event'),
              _LegendItem(color: AppTheme.seaGreen, label: 'Recycling Bin'),
            ],
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 10,
              color: isDark ? Colors.white70 : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
