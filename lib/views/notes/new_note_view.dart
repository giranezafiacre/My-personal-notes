import 'package:flutter/material.dart';
import 'package:mypersonalnotes/services/auth/auth_service.dart';
import 'package:mypersonalnotes/services/crud/notes_services.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({super.key});

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
  DatabaseNote? _note;
  late final NotesService _notesService;
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _notesService = NotesService();
    _textController = TextEditingController();
    _initializeNote();
    _textController.addListener(_textControllerListener);
  }

  Future<void> _initializeNote() async {
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email!;
    final owner = await _notesService.getUser(email: email);

    // Create a new note for the owner
    final newNote = await _notesService.createNote(owner: owner);
    setState(() {
      _note = newNote;
    });
  }

  void _textControllerListener() async {
    if (_note == null) return;

    final currentText = _textController.text;
    if (_note!.text != currentText) {
      await _notesService.updateNote(
        note: _note!,
        text: currentText,
      );

      // Update the local _note object to reflect changes
      setState(() {
        _note = _note!.copyWith(text: currentText);
      });
    }
  }

  void _deleteNoteIfTextIsEmpty() {
    if (_note != null && _textController.text.isEmpty) {
      _notesService.deleteNote(
        id: _note!.id,
      );
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _textController.removeListener(_textControllerListener);
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Note',
          style: TextStyle(
            color: Color.fromARGB(255, 244, 245, 248),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 94, 117, 247),
        elevation: 4.0,
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 244, 245, 248),
        ),
      ),
      body: _note == null
          ? const Center(child: CircularProgressIndicator())
          : TextField(
              controller: _textController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Start typing your note...',
              ),
            ),
    );
  }
}
