
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deck/backend/auth/auth_service.dart';
import 'package:deck/backend/flashcard/flashcard_utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/deck.dart';
import 'package:http/http.dart' as http;

class FlashcardService{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String deckManagerAPIUrl = "https://deck-manager-api-taglvgaoma-uc.a.run.app";
  FlashcardUtils _flashcardUtils = FlashcardUtils();

  Future<List<Deck>> getDecksByUserId(String userId) async {
    List<Deck> decks = [];

    try {
      // Reference to the Firestore collection
      CollectionReference deckCollection = _firestore.collection('decks');

      // Query the collection for documents with the provided user ID
      QuerySnapshot querySnapshot = await deckCollection
          .where('owner_id', isEqualTo: userId)
          .where('is_deleted', isEqualTo: false)
          .orderBy('title') // Sort decks alphabetically based on title
          .get();

      // Iterate through the query snapshot to extract document data
      for (var doc in querySnapshot.docs) {
        // Extract data from the document
        String title = _flashcardUtils.capitalizeFirstLetterOfWords(doc['title']);
        String userId = doc['owner_id'];
        String coverPhoto = doc['cover_photo'];
        bool isDeleted = doc['is_deleted'];
        bool isPrivate = doc['is_private'];
        String deckId = doc.id;

        // Extract created_at timestamp and convert it to DateTime
        Timestamp createdAtTimestamp = doc['created_at'];
        DateTime createdAt = createdAtTimestamp.toDate();

        // Create a new Deck object and add it to the list
        // decks.add(Deck(title, userId, deckId, isDeleted, isPrivate, createdAt, coverPhoto));
      }
    } catch (e) {
      // Handle errors
      print('Error retrieving decks: $e');
    }
    return decks;
  }
  Future<List<Deck>> getDeletedDecksByUserId(String userId) async {
    List<Deck> decks = [];

    try {
      // Reference to the Firestore collection
      CollectionReference deckCollection = _firestore.collection('decks');

      // Query the collection for documents with the provided user ID
      QuerySnapshot querySnapshot = await deckCollection
          .where('owner_id', isEqualTo: userId)
          .where('is_deleted', isEqualTo: true)
          .orderBy('title') // Sort decks alphabetically based on title
          .get();

      // Iterate through the query snapshot to extract document data
      for (var doc in querySnapshot.docs) {
        // Extract data from the document
        String title = _flashcardUtils.capitalizeFirstLetterOfWords(doc['title']);
        String userId = doc['owner_id'];
        String coverPhoto = doc['cover_photo'];
        bool isDeleted = doc['is_deleted'];
        bool isPrivate = doc['is_private'];
        String deckId = doc.id;

        // Extract created_at timestamp and convert it to DateTime
        Timestamp createdAtTimestamp = doc['created_at'];
        DateTime createdAt = createdAtTimestamp.toDate();

        // Create a new Deck object and add it to the list
        // decks.add(Deck(title, userId, deckId, isDeleted, isPrivate, createdAt, coverPhoto));
      }
    } catch (e) {
      // Handle errors
      print('Error retrieving decks: $e');
    }
    return decks;
  }
  Future<List<Deck>> getDecksByUserIdNewestFirst(String userId) async {
    List<Deck> decks = [];

    try {
      // Reference to the Firestore collection
      CollectionReference deckCollection = _firestore.collection('decks');

      // Query the collection for documents with the provided user ID
      QuerySnapshot querySnapshot = await deckCollection
          .where('owner_id', isEqualTo: userId)
          .where('is_deleted', isEqualTo: false)
          .orderBy('created_at', descending: true) // Sort by created_at timestamp, newest first
          .limit(6) // Limit the results to 6 decks
          .get();

      // Iterate through the query snapshot to extract document data
      for (var doc in querySnapshot.docs) {
        // Extract data from the document
        String title = _flashcardUtils.capitalizeFirstLetterOfWords(doc['title']);
        String userId = doc['owner_id'];
        String coverPhoto = doc['cover_photo'];
        bool isDeleted = doc['is_deleted'];
        bool isPrivate = doc['is_private'];
        String deckId = doc.id;

        // Extract created_at timestamp and convert it to DateTime
        Timestamp createdAtTimestamp = doc['created_at'];
        DateTime createdAt = createdAtTimestamp.toDate();

        // Create a new Deck object and add it to the list
        // decks.add(Deck(title, userId, deckId, isDeleted, isPrivate, createdAt, coverPhoto));
      }
    } catch (e) {
      // Handle errors
      print('Error retrieving decks: $e');
    }
    return decks;
  }


  Future<Deck?> getDecksByUserIdAndDeckId(String userId, String deckId) async {
    try {
      // Reference to the Firestore collection
      CollectionReference deckCollection = _firestore.collection('decks');

      // Fetch the document with the specified deckId
      DocumentSnapshot deckSnapshot = await deckCollection.doc(deckId).get();

      // Check if the document exists
      if (deckSnapshot.exists) {
        // Extract the data from the document
        Map<String, dynamic> deckData = deckSnapshot.data() as Map<String, dynamic>;

        // Extract the fields
        String deckUserId = deckData['owner_id'];
        bool isDeleted = deckData['is_deleted'];

        // Check if the deck belongs to the user and is not deleted
        if (deckUserId == userId && !isDeleted) {
          String title = _flashcardUtils.capitalizeFirstLetterOfWords(deckData['title']);
          String coverPhoto = deckData['cover_photo'];
          bool isPrivate = deckData['is_private'];
          Timestamp createdAtTimestamp = deckData['created_at'];
          DateTime createdAt = createdAtTimestamp.toDate();

          // Create and return a Deck object
          // return Deck(title, userId, deckId, isDeleted, isPrivate, createdAt, coverPhoto);
        } else {
          // Deck does not belong to the user or is deleted
          return null;
        }
      } else {
        // Deck with the specified ID does not exist
        return null;
      }
    } catch (e) {
      // Handle errors
      print('Error retrieving deck: $e');
      return null;
    }
  }

  Future<Deck?> getLatestDeckLog(String userId) async {
    try {
      CollectionReference deckCollection = _firestore.collection('deck_log');

      // Query the collection for documents with the provided user ID and deck ID
      QuerySnapshot querySnapshot = await deckCollection
          .where('owner_id', isEqualTo: userId)
          .orderBy('visited_at', descending: true)
          .limit(1)
          .get();

      // Check if any documents are returned
      if (querySnapshot.docs.isNotEmpty) {
        // Extract the latest deck log document
        Map<String, dynamic> latestDeckLogData =
        querySnapshot.docs.first.data() as Map<String, dynamic>;

        // Extract the deck ID from the latest deck log
        String deckId = latestDeckLogData['deck_id'];

        // Fetch the deck details using the deck ID
        Deck? decks = await getDecksByUserIdAndDeckId(userId, deckId);

        // Check if any deck is found
        if (decks != null) {
          // Return the deck found
          return decks;
        }
      }
    } catch (error) {
      // Handle any errors
      print('Error fetching latest deck log: $error');
    }
    // Return null if no deck is found or if an error occurs
    return null;
  }
  Future<void> addDeckLogRecord({
    required String deckId,
    required String title,
    required String userId,
    required DateTime visitedAt,
  }) async {
    try {
      CollectionReference deckLogs = _firestore.collection('deck_log');

      await deckLogs.add({
        'deck_id': deckId,
        'title': title,
        'owner_id': userId,
        'visited_at': visitedAt,
      });

      print('Deck log record added successfully');
    } catch (e) {
      print('Failed to add deck log record: $e');
    }
  }
  Future<Deck?> addDeck(String title, String description, String coverPhoto) async {
    try {
      String? token = await AuthService().getIdToken();
      Map<String, dynamic> requestBody = {
        'title': title,
        'description': description,
        'coverPhoto': coverPhoto
      };
      // Send a POST request to the API with the request body and headers.
      final response = await http.post(
        Uri.parse('$deckManagerAPIUrl/v1/decks/'), // API endpoint.
        body: jsonEncode(requestBody), // JSON-encoded request body.
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },

      );
      print(response.statusCode);
      print(response.body);
      if(response.statusCode == 201){
        var jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        print(jsonData); // Log parsed data for debugging.

        // If the JSON data is non-empty, process it.
        if (jsonData.isNotEmpty) {
          // Extract the list of questions from the JSON response.
          Map<String, dynamic> deckData = jsonData["data"]["deck"];

          Map<String, dynamic> createdAt = deckData["created_at"];
          int seconds = createdAt["_seconds"];
          int nanoseconds = createdAt["_nanoseconds"];

          DateTime createdAtDateTime = DateTime.fromMillisecondsSinceEpoch(seconds * 1000);

          return Deck(
              deckData["title"],
              deckData["description"],
              deckData["flashcard_count"],
              deckData["owner_id"],
              deckData["id"],
              deckData["is_deleted"],
              deckData["is_private"],
              createdAtDateTime,
              deckData["cover_photo"]
          );
        }else{
          return null;
        }
      }
    } catch (e) {
      print('Error adding deck: $e');
      return null;
    }
  }
  Future<String> uploadPdfFileToFirebase(String filePath, String userId) async {
    String fileUrl = "";
    File file = File(filePath);
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    if (await file.exists()) {
      // Get a reference to the Firebase Storage location
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceUserFolder = referenceRoot.child('uploads').child(userId);
      Reference referenceFileToUpload = referenceUserFolder.child(uniqueFileName);

      // Upload file to Firebase Storage
      try {
        await referenceFileToUpload.putFile(file);
        print('File Uploaded Successfully!');
      } catch (e) {
        print('Error uploading file: $e');
      }
    }
    return uniqueFileName;
  }

  Future<String> uploadImageToFirebase(String filePath, String userId) async {
    String fileUrl = "";
    File file = File(filePath);
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    if (await file.exists()) {
      // Get a reference to the Firebase Storage location
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceUserFolder = referenceRoot.child('deckCovers').child(userId);
      Reference referenceFileToUpload = referenceUserFolder.child(uniqueFileName);

      // Upload file to Firebase Storage
      try {
        // Upload the file
        await referenceFileToUpload.putFile(file);
        print('File Uploaded Successfully!');

        // Retrieve the download URL
        fileUrl = await referenceFileToUpload.getDownloadURL();
        print('Download URL: $fileUrl');
      } catch (e) {
        print('Error uploading file: $e');
      }
    }
    return fileUrl;
  }
  Future<bool> deleteDeck(String deckId) async {
    try {
      // Reference to the specific document in the 'deck' collection
      DocumentReference deckDoc = _firestore.collection('decks').doc(deckId);

      // Delete the document
      await deckDoc.delete();

      print('Deck with ID $deckId has been deleted successfully.');
      return true;
    } catch (e) {
      // Handle any errors that might occur during the deletion
      print('Error deleting deck: $e');
      return false;
    }
  }
  Future<bool> checkIfDeckWithTitleExists(String userId, String title) async {
    try {
      // Get a reference to the decks collection
      CollectionReference decksRef = _firestore.collection('decks');

      // Convert the provided title to lowercase and trim any trailing spaces
      String formattedTitle = title.toLowerCase().trim();

      // Query for documents where the title field matches the formatted title and user_id matches the provided userId
      QuerySnapshot querySnapshot = await decksRef
          .where('owner_id', isEqualTo: userId)
          .where('title', isEqualTo: formattedTitle)
          .where('is_deleted', isEqualTo: false)
          .get();

      // If there are any documents returned, it means a deck with the same title and user_id exists
      print(querySnapshot.docs.isNotEmpty);
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      // Handle any errors that occur during the process
      print('Error checking deck title: $e');
      return false; // Return false by default in case of errors
    }
  }
}