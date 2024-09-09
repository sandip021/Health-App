import 'package:cloud_firestore/cloud_firestore.dart';

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
      print('Error fetching document: $e');
      return null;
    }
  }

  // Method to fetch and format user data by document ID
  static Future<Map<String, String>> fetchUserData(String docId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(docId)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;

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
      print('Error fetching user data: $e');
      return {
        'firstName': 'Error',
        'lastName': 'Error',
        'age': 'Error',
      };
    }
  }
}
