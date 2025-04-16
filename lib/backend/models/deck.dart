import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'card.dart';

class Deck{
  String title;
  final String _userId;
  final String _deckId;
  String coverPhoto;
  bool isDeleted;
  bool isPrivate;
  DateTime createdAt;

  // Constructor
  Deck(this.title, this._userId, this._deckId, this.isDeleted, this.isPrivate, this.createdAt, this.coverPhoto);
  String get userId => _userId;
  String get deckId => _deckId;

  // Methods
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
      // Reference to the questions subcollection
      CollectionReference questionsCollection = _firestore
          .collection('decks')
          .doc(deckId)
          .collection('flashcards');

      // Query the collection to get the documents
      QuerySnapshot querySnapshot = await questionsCollection
          .where("is_deleted", isEqualTo: false )
          .get();

      // Iterate through the query snapshot to extract document data
      for (var doc in querySnapshot.docs) {
        String term = (doc.data() as Map<String, dynamic>)['term'];
        String definition = (doc.data() as Map<String, dynamic>)['definition'];
        bool isStarred = (doc.data() as Map<String, dynamic>)['is_starred'];
        bool isDeleted = (doc.data() as Map<String, dynamic>)['is_deleted'];
        String cardId = doc.id;

        // Create a new Question object and add it to the list
        flashcards.add(Cards(term, definition, isStarred, cardId, isDeleted));
      }
    } catch (e) {
      // Handle any errors that might occur during the query
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

  Future<Cards?> addQuestionToDeck(String question, String answer) async {
    try {
      // Get the reference to the collection
      CollectionReference questionsRef = _firestore.collection('decks')
        .doc(_deckId)
        .collection('flashcards');

      // Add the question to the collection
      DocumentReference docRef = await questionsRef.add({
        'term': question,
        'definition': answer,
        'is_deleted': false,
        'is_starred': false,
      });

      String newQuestionId = docRef.id;

      print('Question added successfully!');
      return Cards(question, answer, false, newQuestionId, false);
    } catch (e) {
      print('Error adding question: $e');
      return null;
    }
  }
}