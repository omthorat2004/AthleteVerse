import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/app_user.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<AppUser?> getUser(String uid) async {
    try {

      DocumentSnapshot athleteDoc =
          await _firestore.collection('athletes').doc(uid).get();

      if (athleteDoc.exists) {
        return AppUser.fromMap(athleteDoc.data() as Map<String, dynamic>);
      }


      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      return userDoc.exists
          ? AppUser.fromMap(userDoc.data() as Map<String, dynamic>)
          : null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }


  Future<void> saveUser(AppUser user) async {
    try {
      final userData = user.toMap();


      if (user.userType == 'athlete') {
        await _firestore.collection('athletes').doc(user.uid).set(userData);
      } else {
        await _firestore.collection('users').doc(user.uid).set(userData);
      }
    } catch (e) {
      print('Error saving user: $e');
      rethrow;
    }
  }


  Future<void> updateUser(String uid, Map<String, dynamic> updates) async {
    try {

      await _firestore.collection('athletes').doc(uid).update(updates);
    } catch (e) {

      await _firestore.collection('users').doc(uid).update(updates);
    }
  }

  Future<void> createAthleteUser({
    required String uid,
    required String email,
    required String firstName,
    required String lastName,
    required String city,
    String? gender,
    DateTime? dateOfBirth,
    bool hasDisability = false,
  }) async {
    try {
      final athleteData = {
        'uid': uid,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'fullName': '$firstName $lastName',
        'city': city,
        'gender': gender,
        'dateOfBirth': dateOfBirth,
        'hasDisability': hasDisability,
        'userType': 'athlete',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'profileComplete': false,
      };

      await _firestore.collection('athletes').doc(uid).set(athleteData);
    } catch (e) {
      print('Error creating athlete user: $e');
      rethrow;
    }
  }

  Future<bool> isEmailAvailable(String email) async {
    try {
      final athleteQuery =
          await _firestore
              .collection('athletes')
              .where('email', isEqualTo: email)
              .limit(1)
              .get();

      if (athleteQuery.docs.isNotEmpty) return false;

      // Check users collection
      final userQuery =
          await _firestore
              .collection('users')
              .where('email', isEqualTo: email)
              .limit(1)
              .get();

      return userQuery.docs.isEmpty;
    } catch (e) {
      print('Error checking email availability: $e');
      rethrow;
    }
  }
}
