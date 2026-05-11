import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final String? photoUrl;
  final String? country;
  final String? city;
  final String role;
  final int ecoPoints;
  final String level;
  final List<String> badges;
  final int joinedCleanups;
  final int totalReports;
  final int totalWasteReported;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    this.photoUrl,
    this.country,
    this.city,
    required this.role,
    this.ecoPoints = 0,
    this.level = 'Ocean Rookie',
    this.badges = const [],
    this.joinedCleanups = 0,
    this.totalReports = 0,
    this.totalWasteReported = 0,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'],
      country: map['country'],
      city: map['city'],
      role: map['role'] ?? 'Regular User',
      ecoPoints: map['ecoPoints'] ?? 0,
      level: map['level'] ?? 'Ocean Rookie',
      badges: List<String>.from(map['badges'] ?? []),
      joinedCleanups: map['joinedCleanups'] ?? 0,
      totalReports: map['totalReports'] ?? 0,
      totalWasteReported: map['totalWasteReported'] ?? 0,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'photoUrl': photoUrl,
      'country': country,
      'city': city,
      'role': role,
      'ecoPoints': ecoPoints,
      'level': level,
      'badges': badges,
      'joinedCleanups': joinedCleanups,
      'totalReports': totalReports,
      'totalWasteReported': totalWasteReported,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
