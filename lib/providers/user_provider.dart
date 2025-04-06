import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/app_user.dart';

class UserProvider with ChangeNotifier {
  AppUser? _user;
  bool _isLoading = false;

  AppUser? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> initUser() async {
    if (_user != null) return;

    _isLoading = true;
    notifyListeners();

    await FirebaseAuth.instance.authStateChanges().first;
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      // Fetch additional user data from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('athletes')
          .doc(firebaseUser.uid)
          .get();

      if (userDoc.exists) {
        _user = AppUser.fromMap(userDoc.data()!);
      } else {
        _user = AppUser.fromFirebaseUser(firebaseUser);
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> setUser(User firebaseUser, {String? userType}) async {
    _isLoading = true;
    notifyListeners();

    // Fetch additional user data from Firestore
    final userDoc = await FirebaseFirestore.instance
        .collection('athletes')
        .doc(firebaseUser.uid)
        .get();

    if (userDoc.exists) {
      _user = AppUser.fromMap(userDoc.data()!);
    } else {
      _user = AppUser.fromFirebaseUser(firebaseUser, userType);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> clearUser() async {
    _isLoading = true;
    notifyListeners();

    _user = null;

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshUser() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await setUser(firebaseUser);
    }
  }
}