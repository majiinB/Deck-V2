import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import '../models/ban.dart';

class BanService{

  /// Fetches a ban entry from the API by user ID.
  Future<Map<String,dynamic>?> retrieveBan(String userId) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('bans').where('user_id', isEqualTo: userId).where('is_appealed', isEqualTo: false).get();


      final DocumentSnapshot<Map<String, dynamic>> doc = querySnapshot.docs.first;
      final Map<String, dynamic> responseData = doc.data()!;

      return {'user_id': responseData['user_id'], 'id': doc.id, 'reason': responseData['reason']};
    } catch (error) {
      print('Error retrieving ban: $error');
      return null;
    }
  }

  /// Retrieves ban appeal
  Future<bool> retrieveBanAppeal(String userId) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('ban_appeals').where('user_id', isEqualTo: userId).where('status', isEqualTo: "Pending").get();

      final DocumentSnapshot<Map<String, dynamic>> doc = querySnapshot.docs.first;
      if(!doc.exists){
        return false;
      }

      return true;
    } catch (error) {
      print('Error retrieving ban: $error');
      return false;
    }
  }

  /// Sends a request to create a new ban appeal via API.
  Future<void> submitBanAppeal({
    String? id,
    required String userId,
    DateTime? appealedAt,
    required String title,
    required String details,
    required String status,
    required String banId,
  }) async {
    final Uri apiUrl = Uri.parse('https://deck-report-api-taglvgaoma-uc.a.run.app/v1/report/moderator/create-ban-appeal'); // Replace with actual endpoint

    final Map<String, dynamic> requestData = {
      'banAppealDetails': {
        'user_id': userId,
        'title': title,
        'details': details,
        'status': status,
        'ban_id': banId,
      }
    };

    try {
      final response = await http.post(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode( requestData ),
      );

      if (response.statusCode == 201) {
        print('Ban appeal submitted successfully!');
      } else {
        print('Failed to submit ban appeal: ${response.body}');
      }
    } catch (error) {
      print('Error submitting ban appeal: $error');
    }
  }
}