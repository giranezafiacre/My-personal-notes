import 'package:flutter/material.dart';


class NewNoteView extends StatefulWidget {
  const NewNoteView({super.key});

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Note',
          style: TextStyle(
            color: Color.fromARGB(255, 244, 245, 248), // Text color in AppBar
          ),),
        backgroundColor: const Color.fromARGB(255, 94, 117, 247),
        elevation: 4.0,
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 244, 245, 248), // Back icon color
        ),
        ),
      body: const Text('Write your new note here...'),
    );
  }
}