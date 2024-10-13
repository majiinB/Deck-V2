import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:deck/backend/custom_exceptions/api_exception.dart';
import 'package:deck/backend/flashcard/flashcard_utils.dart';
import 'package:deck/backend/models/cardAi.dart';
import 'package:http/http.dart' as http;

class FlashcardAiService {

  /// Checks if the API is available.
  ///
  /// Returns:
  /// - A [Future] that resolves to 'true' or `false`.
  Future<bool> checkAPIAvailability() async {
    bool toReturn = true;
    try{
      final response = await http.get(
        Uri.parse('https://zdt8v319-3000.asse.devtunnels.ms/hi'), // API endpoint
      );

      if(response.statusCode == 200){
        return toReturn;
      }
    } on TimeoutException{
      toReturn = false;
    } on SocketException{
      toReturn = false;
    }
    return toReturn;
  }

  /// Sends data to the API gateway for creating or updating a message/thread.
  ///
  /// Parameters:
  /// - [id]: Unique identifier for the request.
  /// - [subject]: Subject of the flashcard data.
  /// - [topic]: Topic of the flashcard data.
  /// - [addDescription]: Additional description or details.
  /// - [pdfFileName]: Name of the associated PDF file.
  /// - [numberOfQuestions]: Number of flashcard questions to generate.
  /// - [isNewMessage]: Flag to indicate if this is a new thread/message (default is `true`).
  /// - [threadID]: Existing thread ID if updating an existing thread (default is `"no_thread_id"`).
  ///
  /// Returns:
  /// - A [Future] that resolves to a `Map<String, dynamic>` containing the response data.
  ///
  /// Throws:
  /// - [IncompleteRequestBodyException]: If the request body is incomplete.
  /// - [NumberOfCardsException]: If an unknown number of cards is encountered.
  /// - [TextExtractionException]: If there is an error during text extraction.
  /// - [FileDeletionException]: If the file was not deleted properly.
  /// - [NoInformationException]: If no relevant information is provided.
  /// - [MessageRouteException]: If there is an internal server error related to message routing.
  /// - [RequestException]: For general internal server errors.
  /// - [InternalServerErrorException]: For server-side errors (status code 500/501).
  Future<Map<String, dynamic>> sendData({
    required String id,
    required String subject,
    required String topic,
    required String addDescription,
    required String pdfFileName,
    required int numberOfQuestions,
    bool isNewMessage = true,
    String threadID = "no_thread_id",
  }) async {

    if(!await checkAPIAvailability()){
      throw ApiException(500, 'Error: API unavailable');
    }

    // Define request body to be sent to the API in JSON format
    Map<String, dynamic> requestBody = {
      'subject': subject,
      'topic': topic,
      'numberOfQuestions': numberOfQuestions,
      'pdfFileName': pdfFileName,
      'addDescription': addDescription,
      'isNewMessage': isNewMessage,
      'threadID': threadID,
    };

    // Send HTTP POST request to the API with the request body and headers
    final response = await http.post(
      Uri.parse('https://zdt8v319-3000.asse.devtunnels.ms/message/$id'), // API endpoint
      body: jsonEncode(requestBody),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    // Check if the response is successful (status code 200 means OK)
    if (response.statusCode == 200) {
      // Parse the response body as JSON and return it
      final jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      // Handle specific error cases based on status code
      if (response.statusCode == 418) {
        throw IncompleteRequestBodyException('Incomplete request body: ${response.body}');
      } else if (response.statusCode == 420) {
        throw NumberOfCardsException('Unknown number of cards: ${response.body}');
      } else if (response.statusCode == 421) {
        throw TextExtractionException('Text Extraction error: ${response.body}');
      } else if (response.statusCode == 422) {
        throw FileDeletionException('File was not deleted: ${response.body}');
      } else if (response.statusCode == 423) {
        throw NoInformationException('Incomplete request body: ${response.body}');
      } else if (response.statusCode == 424) {
        throw MessageRouteException('Internal server error: ${response.body}');
      } else if (response.statusCode == 425) {
        throw RequestException('Internal server: ${response.body}');
      } else if (response.statusCode == 500 || response.statusCode == 501) {
        throw InternalServerErrorException('Internal server error: ${response.body}');
      } else {
        throw ApiException(response.statusCode, 'Error: ${response.body}');
      }
    }
  }

  /// Fetches flashcard data from the API based on the provided thread and run IDs.
  ///
  /// Parameters:
  /// - [id]: Unique identifier for the request.
  /// - [threadID]: Thread ID for retrieving specific flashcard data.
  /// - [runID]: Run ID to fetch the appropriate flashcards.
  ///
  /// Returns:
  /// - A [Future] that resolves to a list of [Cardai] objects representing the flashcards.
  ///
  /// Throws:
  /// - [Exception]: If the data fetching fails or the server returns a non-200 status code.
  Future<List<Cardai>> fetchData({
    required String id,
    required String threadID,
    required String runID,
  }) async {

    // Send HTTP GET request to fetch flashcard data from the API
    final response = await http.get(
      Uri.parse('https://zdt8v319-3000.asse.devtunnels.ms/response/$id?thread_id=$threadID&run_id=$runID'), // API endpoint
    );

    // Check if the response is successful (status code 200 means OK)
    if (response.statusCode == 200) {
      // Initialize an empty list to store flashcards
      List<Cardai> flashCards = [];

      // Parse the response body as a list of JSON objects
      var jsonData = jsonDecode(response.body) as List;

      // Check if the parsed data is valid and non-empty
      if (jsonData != null && jsonData.isNotEmpty && jsonData is List<dynamic>) {
        try {
          // Extract the list of questions from the first object in the JSON data
          List<dynamic> questionsList = jsonData[0]['questions'];

          // Loop through each question-answer pair and create Cardai objects
          for (var questionAnswerPair in questionsList) {
            String question = questionAnswerPair['question'];
            String answer = questionAnswerPair['answer'];
            Cardai flashcard = Cardai(question: question, answer: answer);
            flashCards.add(flashcard); // Add each flashcard to the list
          }
        } catch (e) {
          return flashCards; // Return the flashcards even if there's an error
        }
      }

      // Return the list of flashcards
      return flashCards;
    } else {
      // Log the status code if the request failed
      print(response.statusCode);

      // Throw an exception if the request was unsuccessful
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  }
}

