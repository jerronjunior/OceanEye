import 'package:flutter/material.dart';

enum EventType {
  beachCleanup,
  riverCleanup,
  canalCleanup,
  educationalWorkshop,
  recyclingDrive
}

enum EventDifficulty {
  easy,
  moderate,
  challenging
}

enum EventStatus {
  open,
  almostFull,
  full,
  completed
}

extension EventTypeExt on EventType {
  String get label {
    switch (this) {
      case EventType.beachCleanup: return 'Beach Cleanup';
      case EventType.riverCleanup: return 'River Cleanup';
      case EventType.canalCleanup: return 'Canal Cleanup';
      case EventType.educationalWorkshop: return 'Educational Workshop';
      case EventType.recyclingDrive: return 'Recycling Drive';
    }
  }

  IconData get icon {
    switch (this) {
      case EventType.beachCleanup: return Icons.beach_access;
      case EventType.riverCleanup: return Icons.water;
      case EventType.canalCleanup: return Icons.waves;
      case EventType.educationalWorkshop: return Icons.school;
      case EventType.recyclingDrive: return Icons.recycling;
    }
  }
}

extension EventDifficultyExt on EventDifficulty {
  String get label {
    switch (this) {
      case EventDifficulty.easy: return 'Easy';
      case EventDifficulty.moderate: return 'Moderate';
      case EventDifficulty.challenging: return 'Challenging';
    }
  }

  Color get color {
    switch (this) {
      case EventDifficulty.easy: return const Color(0xFF52B788);
      case EventDifficulty.moderate: return const Color(0xFFFFB703);
      case EventDifficulty.challenging: return const Color(0xFFE63946);
    }
  }
}

extension EventStatusExt on EventStatus {
  String get label {
    switch (this) {
      case EventStatus.open: return 'Open';
      case EventStatus.almostFull: return 'Almost Full';
      case EventStatus.full: return 'Full';
      case EventStatus.completed: return 'Completed';
    }
  }

  Color get color {
    switch (this) {
      case EventStatus.open: return const Color(0xFF52B788);
      case EventStatus.almostFull: return const Color(0xFFFFB703);
      case EventStatus.full: return const Color(0xFFE63946);
      case EventStatus.completed: return const Color(0xFF0077B6);
    }
  }
}

class CleanupEvent {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String organizerName;
  final String organizerType;
  final double latitude;
  final double longitude;
  final String address;
  final DateTime dateTime;
  final Duration duration;
  final int maxVolunteers;
  final int participantsCount;
  final int ecoPointsReward;
  final EventDifficulty difficulty;
  final EventType type;
  final EventStatus status;
  final double distanceKm; // Added for mock UI
  final int expectedWasteKg;
  final List<String> requiredItems;
  final String safetyInstructions;
  final List<String> participantAvatars;
  final List<String> galleryImages;

  const CleanupEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.organizerName,
    required this.organizerType,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.dateTime,
    required this.duration,
    required this.maxVolunteers,
    required this.participantsCount,
    required this.ecoPointsReward,
    required this.difficulty,
    required this.type,
    required this.status,
    required this.distanceKm,
    required this.expectedWasteKg,
    this.requiredItems = const [],
    this.safetyInstructions = '',
    this.participantAvatars = const [],
    this.galleryImages = const [],
  });

  bool get isRegistered => participantsCount > 0 && id.startsWith('reg_'); // Mock logic
}
