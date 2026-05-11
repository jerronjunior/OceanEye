import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ──────────────────────────────────────────────
// Enums
// ──────────────────────────────────────────────

enum MarkerType { pollution, cleanup, recycling, userLocation }

enum PollutionSeverity { low, medium, high, critical, cleaned }

enum ReportStatus { pending, verified, cleanupScheduled, completed }

enum MapLayerType { standard, satellite, terrain, heatmap }

enum WasteType {
  plasticBottles,
  plasticBags,
  foodWrappers,
  fishingNets,
  glass,
  cans,
  cigaretteButts,
}

// ──────────────────────────────────────────────
// Extension helpers
// ──────────────────────────────────────────────

extension PollutionSeverityExt on PollutionSeverity {
  Color get color {
    switch (this) {
      case PollutionSeverity.low:
        return const Color(0xFF52B788);
      case PollutionSeverity.medium:
        return const Color(0xFFFFB703);
      case PollutionSeverity.high:
        return const Color(0xFFFB8500);
      case PollutionSeverity.critical:
        return const Color(0xFFE63946);
      case PollutionSeverity.cleaned:
        return const Color(0xFF90E0EF);
    }
  }

  String get label {
    switch (this) {
      case PollutionSeverity.low:
        return 'Low';
      case PollutionSeverity.medium:
        return 'Medium';
      case PollutionSeverity.high:
        return 'High';
      case PollutionSeverity.critical:
        return 'Critical';
      case PollutionSeverity.cleaned:
        return 'Cleaned';
    }
  }

  BitmapDescriptor get bitmapDescriptor {
    switch (this) {
      case PollutionSeverity.low:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      case PollutionSeverity.medium:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
      case PollutionSeverity.high:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
      case PollutionSeverity.critical:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case PollutionSeverity.cleaned:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan);
    }
  }
}

extension ReportStatusExt on ReportStatus {
  String get label {
    switch (this) {
      case ReportStatus.pending:
        return 'Pending';
      case ReportStatus.verified:
        return 'Verified';
      case ReportStatus.cleanupScheduled:
        return 'Cleanup Scheduled';
      case ReportStatus.completed:
        return 'Completed';
    }
  }

  Color get color {
    switch (this) {
      case ReportStatus.pending:
        return const Color(0xFFFFB703);
      case ReportStatus.verified:
        return const Color(0xFF0077B6);
      case ReportStatus.cleanupScheduled:
        return const Color(0xFFFB8500);
      case ReportStatus.completed:
        return const Color(0xFF52B788);
    }
  }
}

extension WasteTypeExt on WasteType {
  String get label {
    switch (this) {
      case WasteType.plasticBottles:
        return 'Plastic Bottles';
      case WasteType.plasticBags:
        return 'Plastic Bags';
      case WasteType.foodWrappers:
        return 'Food Wrappers';
      case WasteType.fishingNets:
        return 'Fishing Nets';
      case WasteType.glass:
        return 'Glass';
      case WasteType.cans:
        return 'Cans';
      case WasteType.cigaretteButts:
        return 'Cigarette Butts';
    }
  }

  String get emoji {
    switch (this) {
      case WasteType.plasticBottles:
        return '🍶';
      case WasteType.plasticBags:
        return '🛍️';
      case WasteType.foodWrappers:
        return '🍬';
      case WasteType.fishingNets:
        return '🎣';
      case WasteType.glass:
        return '🍷';
      case WasteType.cans:
        return '🥫';
      case WasteType.cigaretteButts:
        return '🚬';
    }
  }
}

// ──────────────────────────────────────────────
// Models
// ──────────────────────────────────────────────

class OceanMapMarker {
  final String id;
  final String title;
  final String subtitle;
  final LatLng position;
  final MarkerType type;
  final PollutionSeverity? severity;
  final ReportStatus? status;
  final List<WasteType> wasteTypes;
  final int estimatedWasteKg;
  final int volunteers;
  final int ecoPoints;
  final String reporterName;
  final String timeAgo;
  final List<String> brandsDetected;
  final String emoji;
  final String? eventDate;

  const OceanMapMarker({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.position,
    required this.type,
    this.severity,
    this.status,
    this.wasteTypes = const [],
    this.estimatedWasteKg = 0,
    this.volunteers = 0,
    this.ecoPoints = 0,
    this.reporterName = 'Anonymous',
    this.timeAgo = '',
    this.brandsDetected = const [],
    this.emoji = '📍',
    this.eventDate,
  });
}

class MapFilterState {
  final Set<WasteType> selectedWasteTypes;
  final Set<PollutionSeverity> selectedSeverities;
  final Set<ReportStatus> selectedStatuses;
  final Set<MarkerType> selectedMarkerTypes;
  final String dateRange; // 'today', 'week', 'month'

  const MapFilterState({
    this.selectedWasteTypes = const {},
    this.selectedSeverities = const {},
    this.selectedStatuses = const {},
    this.selectedMarkerTypes = const {
      MarkerType.pollution,
      MarkerType.cleanup,
      MarkerType.recycling,
    },
    this.dateRange = 'month',
  });

  bool get hasActiveFilters =>
      selectedWasteTypes.isNotEmpty ||
      selectedSeverities.isNotEmpty ||
      selectedStatuses.isNotEmpty;

  MapFilterState copyWith({
    Set<WasteType>? selectedWasteTypes,
    Set<PollutionSeverity>? selectedSeverities,
    Set<ReportStatus>? selectedStatuses,
    Set<MarkerType>? selectedMarkerTypes,
    String? dateRange,
  }) {
    return MapFilterState(
      selectedWasteTypes: selectedWasteTypes ?? this.selectedWasteTypes,
      selectedSeverities: selectedSeverities ?? this.selectedSeverities,
      selectedStatuses: selectedStatuses ?? this.selectedStatuses,
      selectedMarkerTypes: selectedMarkerTypes ?? this.selectedMarkerTypes,
      dateRange: dateRange ?? this.dateRange,
    );
  }
}
