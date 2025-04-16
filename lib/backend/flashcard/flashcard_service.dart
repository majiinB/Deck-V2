
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deck/backend/flashcard/flashcard_utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/deck.dart';

class FlashcardService{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
        decks.add(Deck(title, userId, deckId, isDeleted, isPrivate, createdAt, coverPhoto));
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
        decks.add(Deck(title, userId, deckId, isDeleted, isPrivate, createdAt, coverPhoto));
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
        decks.add(Deck(title, userId, deckId, isDeleted, isPrivate, createdAt, coverPhoto));
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
          return Deck(title, userId, deckId, isDeleted, isPrivate, createdAt, coverPhoto);
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
  Future<Deck?> addDeck(String userId, String title, String coverPhoto) async {
    try {
      // Get the reference to the collection
      CollectionReference questionsRef = _firestore.collection('decks');
      String cleanTitle = _flashcardUtils.cleanSpaces(title.toLowerCase().trim());
      String upperCaseTitle = _flashcardUtils.capitalizeFirstLetterOfWords(cleanTitle);
      // Add the question to the collection
      DocumentReference docRef = await questionsRef.add({
        'created_at': DateTime.now(),
        'is_deleted': false,
        'is_private': false,
        'title': cleanTitle,
        'owner_id': userId,
        'cover_photo':coverPhoto
      });

      String newDeckId = docRef.id;

      print('Deck added successfully!');
      return Deck(upperCaseTitle, userId, newDeckId, false, false, DateTime.now(), coverPhoto);
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