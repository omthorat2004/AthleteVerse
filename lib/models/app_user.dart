import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  final String uid;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? fullName;
  final String? userType;
  final String? photoUrl;
  final String? city;
  final String? gender;
  final bool? hasDisability;
  final DateTime? dateOfBirth;
  final bool? profileComplete;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AppUser({
    required this.uid,
    this.email,
    this.firstName,
    this.lastName,
    this.fullName,
    this.userType,
    this.photoUrl,
    this.city,
    this.gender,
    this.hasDisability,
    this.dateOfBirth,
    this.profileComplete,
    this.createdAt,
    this.updatedAt, required String name,
  });

  factory AppUser.fromFirebaseUser(User user, [String? userType]) {
    return AppUser(
      uid: user.uid,
      email: user.email,
      firstName: user.displayName?.split(' ').first,
      lastName: user.displayName?.split(' ').last,
      fullName: user.displayName,
      userType: userType,
      photoUrl: user.photoURL,
    );
  }

  factory AppUser.fromMap(Map<String, dynamic> data) {
    return AppUser(
      uid: data['uid'] ?? '',
      email: data['email'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      fullName: data['fullName'],
      userType: data['userType'],
      photoUrl: data['photoUrl'],
      city: data['city'],
      gender: data['gender'],
      hasDisability: data['hasDisability'],
      dateOfBirth: data['dateOfBirth']?.toDate(),
      profileComplete: data['profileComplete'],
      createdAt: data['createdAt']?.toDate(),
      updatedAt: data['updatedAt']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'fullName': fullName ?? '$firstName $lastName',
      'userType': userType,
      'photoUrl': photoUrl,
      'city': city,
      'gender': gender,
      'hasDisability': hasDisability ?? false,
      'dateOfBirth': dateOfBirth,
      'profileComplete': profileComplete ?? false,
      'createdAt': createdAt,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}