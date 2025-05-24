import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import '../auth/auth_service.dart';

class Cards {
  final String _cardId;
  String term;
  String definition;
  bool isStarred;
  bool isDeleted;
  final String deckManagerAPIUrl = "https://deck-manager-api-taglvgaoma-uc.a.run.app";
  final String deckLocalAPIUrl = "http://10.0.2.2:5001/deck-f429c/us-central1/deck_manager_api";

  Cards(this.term, this.definition, this.isStarred, this._cardId, this.isDeleted);

  String get cardId => _cardId;

  //Methods
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  factory Cards.fromJson(Map<String, dynamic> json) {
    return Cards(
      json['term'] ?? '',
      json['definition'] ?? '',
      json['is_starred'] ?? false,
      json['id'] ?? '',
      json['is_deleted'] ?? false,
    );
  }

  Future<bool> updateDeleteStatus(bool value, String deckId) async {
    try {
      String? token = await AuthService().getIdToken();

      Map<String, dynamic> requestBody = {
        'flashcardIDs': [_cardId],
      };

      final response = await http.post(
        Uri.parse('$deckManagerAPIUrl/v1/decks/$deckId/flashcards/delete'), // API endpoint.
        body: jsonEncode(requestBody), // JSON-encoded request body.
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      print(response.statusCode);
      print(response.body);
      if(response.statusCode == 200){
        var jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        print(jsonData); // Log parsed data for debugging.
        isDeleted = value;
        // If the JSON data is non-empty, process it.
        if (jsonData.isNotEmpty) return true;
        else {
          return false;
        }
      }else{
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateStarredStatus(bool value, String deckId) async {
    try {
      if (isStarred == null) {
        print('isStarred is null');
        return false;
      }
      String? token = await AuthService().getIdToken();

      Map<String, dynamic> requestBody = {
        'isStarred': value,
      };

      final response = await http.put(
        Uri.parse('$deckManagerAPIUrl/v1/decks/$deckId/flashcards/$cardId'), // API endpoint.
        body: jsonEncode(requestBody), // JSON-encoded request body.
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      print(response.statusCode);
      print(response.body);
      if(response.statusCode == 200){
        var jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        print(jsonData); // Log parsed data for debugging.
        isStarred = value;
        // If the JSON data is non-empty, process it.
        if (jsonData.isNotEmpty) return true;
        else {
          return false;
        }
      }else{
        return false;
      }
    } catch (e) {
      return false;
    }
  }
  Future<bool> updateQuestion(String newQuestion, String deckId) async {
    try {
      // Reference to the Firestore document
      DocumentReference deckRef = _firestore.collection('decks').doc(deckId)
          .collection('questions')
          .doc(_cardId);

      // Update only the 'title' field of the document
      await deckRef.update({'question': newQuestion});
      term = newQuestion;
      print('Card question updated successfully');
      return true;
    } catch (e) {
      // Handle any errors that might occur during the update
      print('Error updating card question: $e');
      return false;
    }
  }
  Future<bool> updateAnswer(String newAnswer, String deckId) async {
    try {
      // Reference to the Firestore document
      DocumentReference deckRef = _firestore.collection('decks').doc(deckId)
          .collection('questions')
          .doc(_cardId);

      // Update only the 'title' field of the document
      await deckRef.update({'answer': newAnswer});
      definition = newAnswer;
      print('Card answer updated successfully');
      return true;
    } catch (e) {
      // Handle any errors that might occur during the update
      print('Error updating card answer: $e');
      return false;
    }
  }
}
