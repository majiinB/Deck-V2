import 'dart:core';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deck/backend/flashcard/flashcard_service.dart';
import 'package:http/http.dart' as http;
import '../auth/auth_service.dart';
import 'card.dart';

class Deck{
  String title;
  String description;
  String deckOwnerName;
  int flashcardCount;
  final String _userId;
  final String _deckId;
  String coverPhoto;
  bool isDeleted;
  bool isPrivate;
  DateTime createdAt;
  final String deckManagerAPIUrl = "https://deck-manager-api-taglvgaoma-uc.a.run.app";
  final String deckLocalAPIUrl = "http://10.0.2.2:5001/deck-f429c/us-central1/deck_manager_api";

  // Constructor
  Deck(
      this.title,
      this.description,
      this.deckOwnerName,
      this.flashcardCount,
      this._userId, this._deckId,
      this.isDeleted,
      this.isPrivate,
      this.createdAt,
      this.coverPhoto
      );

  String get userId => _userId;
  String get deckId => _deckId;

  // Methods
  factory Deck.fromJson(Map<String, dynamic> json) {
    // Handle Firestore-like timestamp conversion
    final createdAtMap = json['created_at'] ?? {};
    final seconds = createdAtMap['_seconds'] ?? 0;
    final nanoseconds = createdAtMap['_nanoseconds'] ?? 0;

    final createdAt = DateTime.fromMillisecondsSinceEpoch(
      (seconds * 1000) + (nanoseconds ~/ 1000000),
    );

    return Deck(
      json['title'] ?? '',
      json['description'] ?? '',
      json['owner_name'] ?? '',
      json['flashcard_count'] ?? 0,
      json['owner_id'] ?? '',
      json['id'] ?? '',
      json['is_deleted'] ?? false,
      json['is_private'] ?? true,
      createdAt,
      json['cover_photo'] ?? '',
    );
  }

  // Change in field methods
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> updateDeckTitle(String newTitle) async {
    try {
      // Reference to the Firestore document
      DocumentReference deckRef = _firestore.collection('decks').doc(_deckId);

      // Update only the 'title' field of the document
      await deckRef.update({'title': newTitle});
      title = newTitle;
      print('Deck title updated successfully');
      return true;
    } catch (e) {
      // Handle any errors that might occur during the update
      print('Error updating deck title: $e');
      return false;
    }
  }
  Future<bool> updateDeleteStatus(bool newStatus) async {
    try {
      // Reference to the Firestore document
      DocumentReference deckRef = _firestore.collection('decks').doc(_deckId);

      // Update only the 'title' field of the document
      await deckRef.update({'is_deleted': newStatus});
      isDeleted = newStatus;
      print('Deck status updated successfully');
      return true;
    } catch (e) {
      // Handle any errors that might occur during the update
      print('Error updating deck status: $e');
      return false;
    }
  }

  // Access subcollections method
  Future<List<Cards>> getCard() async {
    List<Cards> flashcards = [];
    try {
      String? token = await AuthService().getIdToken();

      // Send a POST request to the API with the request body and headers.
      final response = await http.get(
        Uri.parse('$deckManagerAPIUrl/v1/decks/$_deckId/flashcards'), // API endpoint.
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      print(response.statusCode);
      print(response.body);
      if(response.statusCode == 200) {
        var jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        print(jsonData); // Log parsed data for debugging.

        // If the JSON data is empty, return null.
        if (jsonData.isEmpty) return flashcards;

        // Extract the data from the JSON response.
        Map<String, dynamic> cardData = jsonData["data"];
        if (cardData.isEmpty) return flashcards;

        // Extract the list of decks from the JSON response.
        List<dynamic> listOfFlashcards = cardData["flashcards"];
        flashcards = listOfFlashcards.map((cardsJson) => Cards.fromJson(cardsJson)).toList();

      }
    } catch (e) {
      // Handle errors
      print('Error retrieving flashcards: $e');
    }
    return flashcards;
  }
  Future<int> getCardCount() async {
    try {
      // Reference to the questions subcollection with a query to filter out deleted cards
      CollectionReference questionsCollection = _firestore
          .collection('decks')
          .doc(deckId)
          .collection('flashcards');

      // Query the collection to get documents where is_deleted is false
      QuerySnapshot querySnapshot = await questionsCollection
          .where('is_deleted', isEqualTo: false)
          .get();

      // Return the number of documents in the query snapshot
      return querySnapshot.docs.length;
    } catch (e) {
      // Handle any errors that might occur during the query
      print('Error retrieving questions: $e');
      // Return 0 in case of error
      return 0;
    }
  }

  Future<Cards?> addFlashcardToDeck(String term, String definition) async {
    try {
      String? token = await AuthService().getIdToken();
      List<Map<String, dynamic>> requestBody = [
        {
          'term':term,
          'definition': definition
        }
      ];
      // Send a POST request to the API with the request body and headers.
      final response = await http.post(
        Uri.parse('$deckManagerAPIUrl/v1/decks/$_deckId/flashcards'), // API endpoint.
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

        // If the JSON data is empty, return null.
        if (jsonData.isEmpty) return null;

        // Extract the list of questions from the JSON response.
        List<dynamic> flashcardData = jsonData["data"];

        if(flashcardData.isEmpty) return null;

        final Map<String, dynamic> firstFlashcard = flashcardData[0] as Map<String, dynamic>;

        // Extract the info's
        final String id = firstFlashcard['id'];
        final bool isStarred = firstFlashcard['is_starred'];
        final bool isDeleted = firstFlashcard['is_deleted'];

        Map<String, dynamic> createdAt = firstFlashcard["created_at"];
        int seconds = createdAt["_seconds"];
        int nanoseconds = createdAt["_nanoseconds"];

        // Convert created_at format
        DateTime createdAtDateTime = DateTime.fromMillisecondsSinceEpoch(seconds * 1000);

        return Cards(term, definition, isStarred, id, isDeleted);
      }
    } catch (e) {
      print('Error adding flashcards: $e');
      return null;
    }
  }

  @override
  String toString() {
    return 'Deck(id: $_deckId, title: $title, numOfCards: $flashcardCount)';
  }
}