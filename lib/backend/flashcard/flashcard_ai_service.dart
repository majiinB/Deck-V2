import 'dart:convert';

import 'package:deck/backend/custom_exceptions/api_exception.dart';
import 'package:deck/backend/flashcard/flashcard_utils.dart';
import 'package:deck/backend/models/cardAi.dart';
import 'package:http/http.dart' as http;

class FlashcardAiService{
  String ipAddress = "192.168.195.13";

  Future<String> testFunction() async {
    final res = await http.get(
      Uri.parse('http://192.168.0.26:8080/hello'),
    );
    if(res.statusCode == 200){
      return res.body;
    } else {
      return 'not hellow world';
    }
  }

  // Method to send data to api gateway
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

    print(ipAddress);

    // Define request body
    Map<String, dynamic> requestBody = {
      'subject': subject,
      'topic': topic,
      'numberOfQuestions': numberOfQuestions,
      'pdfFileName': pdfFileName,
      'addDescription': addDescription,
      'isNewMessage': isNewMessage,
      'threadID': threadID,
    };

    // Make the API call
    final response = await http.post(
      Uri.parse('http://$ipAddress:8080/message/$id'), //API endpoint
      body: jsonEncode(requestBody),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    // Check if the response is successful
    if (response.statusCode == 200) {
      // Parse the JSON data
      final jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      // If the server did not return a 200 OK response, throw an exception
      print(response.statusCode);
      print(response.body);
      if(response.statusCode == "418"){
        throw IncompleteRequestBodyException('Incomplete request body: ${response.body}');
      }else if(response.statusCode == "420"){
        throw NumberOfCardsException('Unknown number of cards: ${response.body}');
      }else if(response.statusCode == "421"){
        throw TextExtractionException('Text Extraction error: ${response.body}');
      }else if(response.statusCode == "422"){
        throw FileDeletionException('File was not deleted: ${response.body}');
      }else if(response.statusCode == "423"){
        throw NoInformationException('Incomplete request body: ${response.body}');
      }else if(response.statusCode == "424"){
        throw MessageRouteException('Internal server error: ${response.body}');
      }else if(response.statusCode == "425"){
        throw RequestException('Internal server: ${response.body}');
      }else if(response.statusCode == "500" || response.statusCode == "501"){
        throw InternalServerErrorException('Internal server error: ${response.body}');
      }
      else{
        throw ApiException(response.statusCode, 'Error: ${response.body}');
      }
    }
  }
  //===========================================================================================

  Future<List<Cardai>> fetchData({
    required String id,
    required String threadID,
    required String runID,
  }) async {
    print(ipAddress);
    // Make the API call
    final response = await http.get(
      Uri.parse('http://$ipAddress:8080/response/$id?thread_id=$threadID&run_id=$runID'), //API endpoint
    );

    // Check if the response is successful
    if (response.statusCode == 200) {
      // Parse the JSON data
      List<Cardai> flashCards = [];
      var jsonData = jsonDecode(response.body) as List;

      if (jsonData != null && jsonData.isNotEmpty && jsonData is List<dynamic>) {
        try{
          List<dynamic> questionsList = jsonData[0]['questions'];
          for (var questionAnswerPair in questionsList) {
            String question = questionAnswerPair['question'];
            String answer = questionAnswerPair['answer'];
            Cardai flashcard = Cardai(question: question, answer: answer);
            flashCards.add(flashcard);
            // Use question and answer as needed
          }
        }catch(e){
          return flashCards;
        }
      }

      //List<Flashcard> flashCards = jsonData.map((flashObj) => Flashcard.fromJson(flashObj)).toList();

      return flashCards;
    } else {

      print(response.statusCode);

      // If the server did not return a 200 OK response, throw an exception
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  }
}