import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class GetUserData {
  // Method to get the document ID that matches the user's UID
  static Future<String?> getDocId(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (doc.exists) {
        return doc.id;
      } else {
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching document: $e');
      }
      return null;
    }
  }

  // Method to fetch and format user profile data from the sub-collection
  static Future<Map<String, String>> fetchUserData(String uid) async {
    try {
      final profileDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('profile')
          .doc('profileData') // the specific profile document
          .get();

      if (profileDoc.exists) {
        final data = profileDoc.data() as Map<String, dynamic>;

        // Formatting data
        String firstName = data['first name'] ?? 'No first name available';
        String lastName = data['last name'] ?? 'No last name available';
        String age = data['age']?.toString() ?? 'No age available';

        return {
          'firstName': firstName,
          'lastName': lastName,
          'age': age,
        };
      } else {
        return {
          'firstName': 'No first name available',
          'lastName': 'No last name available',
          'age': 'No age available',
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user data: $e');
      }
      return {
        'firstName': 'Error',
        'lastName': 'Error',
        'age': 'Error',
      };
    }
  }
}
