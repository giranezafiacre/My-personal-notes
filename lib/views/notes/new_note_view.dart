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
  late final Future<DatabaseNote> _noteFuture;

  @override
  void initState() {
    super.initState();
    _notesService = NotesService();
    _textController = TextEditingController();
    _noteFuture = createOrGetNote();
    _textController.addListener(_textControllerListener);
  }

  Future<DatabaseNote> createOrGetNote() async {
    if (_note != null) return _note!;

    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email!;
    final owner = await _notesService.getUser(email: email);
    final newNote = await _notesService.createNote(owner: owner);

    setState(() {
      _note = newNote;
    });

    return newNote;
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) return;

    final newText = _textController.text;
    if (note.text != newText) {
      await _notesService.updateNote(
        note: note,
        text: newText,
      );
    }
  }

  void _deleteNoteIfTextIsEmpty() {
    if (_note != null && _textController.text.isEmpty) {
      _notesService.deleteNote(id: _note!.id);
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
      body: FutureBuilder<DatabaseNote>(
        future: _noteFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              final note = snapshot.data!;
              _note = note; // Update the local state
              _textController.text = note.text;

              return TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Start typing your note...',
                ),
              );
            } else {
              return const Center(
                child: Text('Failed to load note'),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
