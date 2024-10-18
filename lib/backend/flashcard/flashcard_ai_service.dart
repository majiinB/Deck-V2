import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:deck/backend/config/firebase_remote_config.dart';
import 'package:deck/backend/config/gemini_config.dart';
import 'package:deck/backend/custom_exceptions/api_exception.dart';
import 'package:deck/backend/flashcard/flashcard_utils.dart';
import 'package:deck/backend/models/cardAi.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;

class FlashcardAiService {

  Future<List<Cardai>> promptGeminiInApp({
    required String subject,         // Subject of the flashcards.
    required String topic,           // Topic within the subject.
    required String addDescription,  // Additional description or context.
    required int numberOfQuestions,  // Number of questions to generate.
  }) async{
    // Initialize utils
    FlashcardUtils utils = FlashcardUtils();
    // Initialize gemini config
    GeminiConfig geminiConfig = GeminiConfig();

    await geminiConfig.init();
    // Get gemini model
    GenerativeModel model = geminiConfig.model;
    // Call the method using the instance
    List<Cardai> flashCards = [];

    String prompt = utils.constructGoogleAIPrompt(
      topic: topic,
      subject: subject,
      addDescription: addDescription,
      numberOfQuestions: numberOfQuestions
    );

    final result = await model.generateContent([Content.text(prompt)]);
    Map<String, dynamic> jsonData = utils.extractGoogleAIJsonFromText(result.text);

    if (jsonData.isNotEmpty) {
      try {
        // Extract the list of questions from the JSON response.
        List<dynamic> questionsList = jsonData['questions'];

        // Create [Cardai] objects from the question-answer pairs.
        for (var questionAnswerPair in questionsList) {
          String question = questionAnswerPair['question'];
          String answer = questionAnswerPair['answer'];
          Cardai flashcard = Cardai(question: question, answer: answer);
          flashCards.add(flashcard); // Add to the list.
        }
      } catch (e) {
        print(e); // Log any errors during processing.
        return flashCards; // Return any flashcards created so far.
      }
    }else{
      throw ApiException(400, 'Error: The AI did not respond please try again');
    }
    return flashCards;
  }
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

  /// Sends a request to the Gemini API to generate flashcards based on the provided data.
  /// This function performs API availability checks, sends a POST request with the necessary
  /// payload, processes the response, and returns a list of [Cardai] objects.
  /// It handles various error cases by throwing appropriate exceptions based on the HTTP status codes.
  ///
  /// Parameters:
  /// - [id]: A unique identifier for the API request. This can represent the user or session.
  /// - [subject]: The subject or field of knowledge for the flashcards (e.g., "Math").
  /// - [topic]: A more specific topic within the subject (e.g., "Algebra").
  /// - [addDescription]: Additional description or context to include with the request.
  /// - [pdfFileName]: The name of the PDF file to be associated with the flashcard generation.
  /// - [pdfFileExtension]: The file extension for the PDF (e.g., '.pdf').
  /// - [numberOfQuestions]: The number of flashcard questions to generate. If invalid or 0, no cards will be generated.
  ///
  /// Returns:
  /// - A `Future` that resolves to a list of [Cardai] objects representing the generated flashcards.
  ///
  /// Throws:
  /// - [ApiException]: If the API request fails with a specific status code.
  /// - [IncompleteRequestBodyException], [NumberOfCardsException], [TextExtractionException],
  ///   [FileDeletionException], [NoInformationException], [MessageRouteException],
  ///   [InternalServerErrorException]: Specific exceptions based on different status codes.
  Future<List<Cardai>> sendAndRequestDataToGemini({
    required String id,              // Unique identifier for the API request.
    required String subject,         // Subject of the flashcards.
    required String topic,           // Topic within the subject.
    required String addDescription,  // Additional description or context.
    required String pdfFileName,     // Name of the associated PDF file.
    required String pdfFileExtension, // File extension of the PDF (e.g., '.pdf').
    required int numberOfQuestions,  // Number of questions to generate.
  }) async {

    // Check if the API is available before sending the request.
    if (!await checkAPIAvailability()) {
      throw ApiException(500, 'Error: API unavailable');
    }

    // Construct the request body in JSON format.
    Map<String, dynamic> requestBody = {
      'subject': subject,
      'topic': topic,
      'numberOfQuestions': numberOfQuestions,
      'fileName': pdfFileName,
      'addDescription': addDescription,
      'fileExtension': pdfFileExtension
    };

    // Send a POST request to the API with the request body and headers.
    final response = await http.post(
      Uri.parse('https://zdt8v319-3000.asse.devtunnels.ms/prompt/v2/gemini/$id'), // API endpoint.
      body: jsonEncode(requestBody), // JSON-encoded request body.
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8', // Specify content type as JSON.
      },
    );
    print(response.statusCode); // Log the status code for debugging.

    // Check if the response was successful (status code 200).
    if (response.statusCode == 200) {
      List<Cardai> flashCards = []; // List to store flashcards.

      // Parse the response body as a JSON object.
      var jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      print(jsonData); // Log parsed data for debugging.

      // If the JSON data is non-empty, process it.
      if (jsonData.isNotEmpty) {
        try {
          // Extract the list of questions from the JSON response.
          List<dynamic> questionsList = jsonData['questions'];

          // Create [Cardai] objects from the question-answer pairs.
          for (var questionAnswerPair in questionsList) {
            String question = questionAnswerPair['question'];
            String answer = questionAnswerPair['answer'];
            Cardai flashcard = Cardai(question: question, answer: answer);
            flashCards.add(flashcard); // Add to the list.
          }
        } catch (e) {
          print(e); // Log any errors during processing.
          return flashCards; // Return any flashcards created so far.
        }
      }

      return flashCards; // Return the generated flashcards.

    } else {
      // Handle errors based on status codes using a switch-case.
      switch (response.statusCode) {
        case 418:
          throw IncompleteRequestBodyException('Incomplete request body: ${response.body}');
        case 420:
          throw NumberOfCardsException('Unknown number of cards: ${response.body}');
        case 421:
          throw TextExtractionException('Text Extraction error: ${response.body}');
        case 422:
          throw FileDeletionException('File was not deleted: ${response.body}');
        case 423:
          throw NoInformationException('Incomplete request body: ${response.body}');
        case 424:
          throw MessageRouteException('Internal server error: ${response.body}');
        case 425:
          throw RequestException('Internal server: ${response.body}');
        case 500:
        case 501:
          throw InternalServerErrorException('Internal server error: ${response.body}');
        default:
          print(response.statusCode); // Log unexpected status codes.
          throw ApiException(response.statusCode, 'Error: ${response.body}'); // Generic error handling.
      }
    }
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
      Uri.parse('https://zdt8v319-3000.asse.devtunnels.ms/prompt/v1/openAI/$id'), // API endpoint
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
      // Handle errors based on status codes using a switch-case.
      switch (response.statusCode) {
        case 418:
          throw IncompleteRequestBodyException('Incomplete request body: ${response.body}');
        case 420:
          throw NumberOfCardsException('Unknown number of cards: ${response.body}');
        case 421:
          throw TextExtractionException('Text Extraction error: ${response.body}');
        case 422:
          throw FileDeletionException('File was not deleted: ${response.body}');
        case 423:
          throw NoInformationException('Incomplete request body: ${response.body}');
        case 424:
          throw MessageRouteException('Internal server error: ${response.body}');
        case 425:
          throw RequestException('Internal server: ${response.body}');
        case 500:
        case 501:
          throw InternalServerErrorException('Internal server error: ${response.body}');
        default:
          print(response.statusCode); // Log unexpected status codes.
          throw ApiException(response.statusCode, 'Error: ${response.body}'); // Generic error handling.
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
      Uri.parse('https://zdt8v319-3000.asse.devtunnels.ms/response/v1/openAI/$id?thread_id=$threadID&run_id=$runID'), // API endpoint
    );

    // Check if the response is successful (status code 200 means OK)
    if (response.statusCode == 200) {
      // Initialize an empty list to store flashcards
      List<Cardai> flashCards = [];

      // Parse the response body as a list of JSON objects
      var jsonData = jsonDecode(response.body) as List;

      // Check if the parsed data is valid and non-empty
      if (jsonData.isNotEmpty) {
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

