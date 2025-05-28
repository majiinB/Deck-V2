import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/report.dart';
import '../models/reportedDeck.dart';

class ReportService {
  final String apiUrl = "https://deck-report-api-taglvgaoma-uc.a.run.app";
  final String testUrl = "http://192.168.100.4:3000";

  Future<void> createReport(Report report) async {
    final url = Uri.parse('$testUrl/v1/report/create-report'); // Update with your endpoint

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'reportDetails': report.toJson()}),
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Report created successfully!');
      }
    } else {
      if (kDebugMode) {
        print('Failed to create report: ${response.body}');
      }
    }
  }

  Future<void> createReportedDeck(ReportedDeck report) async {
    final url = Uri.parse('$testUrl/v1/report/create-reported-deck'); // Update with your endpoint

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'reportedDeckDetails': report.toJson()}),
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Reported deck created successfully!');
      }
    } else {
      if (kDebugMode) {
        print('Failed to create report: ${response.body}');
      }
    }
  }
}