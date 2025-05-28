import 'package:cloud_firestore/cloud_firestore.dart';

class ReportedDeck {
  final String id;
  final String? deckId;
  final String reportedBy;
  final DateTime? submittedAt;
  final String title;
  final String? issueCode;
  final String details;
  final String status;

  ReportedDeck({
    required this.id,
    this.deckId,
    required this.reportedBy,
    this.submittedAt,
    required this.title,
    this.issueCode,
    required this.details,
    required this.status,
  });

  /// Convert Dart object to Firestore document
  Map<String, dynamic> toJson() {
    return {
      'deck_id': deckId,
      'reported_by': reportedBy,
      'submitted_at': submittedAt,
      'title': title,
      'issue_code': issueCode,
      'details': details,
      'status': status,
    };
  }
}