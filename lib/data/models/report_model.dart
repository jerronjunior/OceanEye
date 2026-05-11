import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  final String reportId;
  final String userId;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final String address;
  final List<String> wasteTypes;
  final String severity;
  final double confidence;
  final List<String> brands;
  final String description;
  final String status;
  final DateTime createdAt;

  ReportModel({
    required this.reportId,
    required this.userId,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.wasteTypes,
    required this.severity,
    required this.confidence,
    required this.brands,
    required this.description,
    this.status = 'Pending',
    required this.createdAt,
  });

  factory ReportModel.fromMap(Map<String, dynamic> map, String id) {
    return ReportModel(
      reportId: id,
      userId: map['userId'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      address: map['address'] ?? '',
      wasteTypes: List<String>.from(map['wasteTypes'] ?? []),
      severity: map['severity'] ?? 'Low',
      confidence: (map['confidence'] as num?)?.toDouble() ?? 0.0,
      brands: List<String>.from(map['brands'] ?? []),
      description: map['description'] ?? '',
      status: map['status'] ?? 'Pending',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'wasteTypes': wasteTypes,
      'severity': severity,
      'confidence': confidence,
      'brands': brands,
      'description': description,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
