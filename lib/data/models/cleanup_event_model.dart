import 'package:cloud_firestore/cloud_firestore.dart';

class CleanupEventModel {
  final String eventId;
  final String title;
  final String description;
  final DateTime dateTime;
  final double latitude;
  final double longitude;
  final int maxVolunteers;
  final int participantsCount;
  final String status;

  CleanupEventModel({
    required this.eventId,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.latitude,
    required this.longitude,
    required this.maxVolunteers,
    required this.participantsCount,
    required this.status,
  });

  factory CleanupEventModel.fromMap(Map<String, dynamic> map, String id) {
    return CleanupEventModel(
      eventId: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      dateTime: (map['dateTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      maxVolunteers: map['maxVolunteers'] ?? 0,
      participantsCount: map['participantsCount'] ?? 0,
      status: map['status'] ?? 'Scheduled',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'dateTime': Timestamp.fromDate(dateTime),
      'latitude': latitude,
      'longitude': longitude,
      'maxVolunteers': maxVolunteers,
      'participantsCount': participantsCount,
      'status': status,
    };
  }
}
