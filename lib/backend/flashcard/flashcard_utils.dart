import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

import '../models/card.dart';

class FlashcardUtils{
  static final ValueNotifier<bool> updateSettingsNeeded = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> updateLatestReview = ValueNotifier<bool>(false);
  void shuffleList(List items) {
    final random = Random();
    for (var i = items.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final temp = items[i];
      items[i] = items[j];
      items[j] = temp;
    }
  }
  String capitalizeFirstLetterOfWords(String input) {
    if (input.isEmpty) {
      return input;
    }

    // Split the input string into words
    List<String> words = input.split(' ');

    // Capitalize the first letter of each word
    List<String> capitalizedWords = words.map((word) {
      if (word.isEmpty) {
        return word; // Return empty string as is
      }
      // Capitalize the first letter and concatenate with the rest of the word
      return '${word[0].toUpperCase()}${word.substring(1)}';
    }).toList();

    // Join the capitalized words back into a single string
    return capitalizedWords.join(' ');
  }
  String cleanSpaces(String input) {
    // Use a regular expression to replace multiple consecutive spaces with a single space
    return input.replaceAll(RegExp(r'\s+'), ' ');
  }
  void sortByTerm(List<Cards> cards) {
    cards.sort((a, b) => a.term.compareTo(b.term));
  }

  String constructGoogleAIPrompt({
    String? topic,
    String? subject,
    String? addDescription,
    required int numberOfQuestions,
  }) {
    // Initialize prompt
    String prompt =
        'I want you to act as a Professor providing students with questions and answers but strictly, '
        'answer in JSON format and no introductory sentences, write it like a code generator. '
        'The format is {questions:{question: "1+1", answer: "2"}, {question: "2+3", answer: "5"}}.';

    String instruction =
        'Instructions: give me $numberOfQuestions questions with answers.';

    String lastLinePrompt =
        'Do not repeat questions. Also make the questions 1-2 sentences max and the answers 1 sentence max or the keypoint only.';

    // Condition to determine prompt
    if (subject != null) prompt += 'The subject is $subject. ';
    if (topic != null) prompt += 'And the topic is $topic. ';
    if (addDescription != null) prompt += 'Additional description: $addDescription. ';

    prompt += instruction;
    prompt += lastLinePrompt;

    return prompt;
  }

  Map<String, dynamic> extractGoogleAIJsonFromText(String? response) {
    // Check if the response is null or not a string
    if (response == null || response.isEmpty) {
      print('Invalid input: response is missing or not a string');
      return {}; // Return an empty map if input is invalid
    }

    // Remove the backticks and the 'json' keyword
    String cleanedText = response
        .replaceFirst(RegExp(r'^```json\s*'), '') // Remove leading ```json
        .replaceFirst(RegExp(r'```$'), ''); // Remove trailing ```

    try {
      // Parse the cleaned text into a JSON object
      return jsonDecode(cleanedText) as Map<String, dynamic>;
    } catch (error) {
      print('Failed to parse JSON: $error');
      return {}; // Return an empty map if parsing fails
    }
  }
}