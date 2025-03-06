import 'package:flutter/material.dart';


class SuggestImprovement extends StatefulWidget {
  const SuggestImprovement({super.key});

  @override
  _SuggestImprovementState createState() => _SuggestImprovementState();
}
class _SuggestImprovementState extends State<SuggestImprovement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Suggest Improvement'),
        centerTitle: true, // Centers the title
      ),
      body: Center(
        child: Text('Body content goes here'), // Placeholder for body content
      ),
    );
  }
}