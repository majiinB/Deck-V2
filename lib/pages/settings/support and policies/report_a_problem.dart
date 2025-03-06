import 'package:flutter/material.dart';


class ReportAProblem extends StatefulWidget {
  const ReportAProblem({super.key});

  @override
  _ReportAProblemState createState() => _ReportAProblemState();
}
class _ReportAProblemState extends State<ReportAProblem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report A Proble'),
        centerTitle: true, // Centers the title
      ),
      body: Center(
        child: Text('Body content goes here'), // Placeholder for body content
      ),
    );
  }
}