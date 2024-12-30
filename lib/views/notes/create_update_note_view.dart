import 'package:flutter/material.dart';
import 'package:mypersonalnotes/services/auth/auth_service.dart';
import 'package:mypersonalnotes/services/crud/notes_services.dart';
import 'package:mypersonalnotes/utility/generics/get_arguments.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  DatabaseNote? _note;
  late final NotesService _notesService;
  late final TextEditingController _textController;
  late FocusNode _focusNode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _notesService = NotesService();
    _textController = TextEditingController();
    // _initializeNote();
    _textController.addListener(_textControllerListener);
    _focusNode = FocusNode();
  }


  Future<DatabaseNote> _createOrGetExistingNote(BuildContext context) async {
    debugPrint('Fetching or creating a note...');
    final widgetNote = context.getArgument<DatabaseNote>();

    if (widgetNote != null) {
      _note = widgetNote;
      _textController.text = widgetNote.text;
      return widgetNote;
    }
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }

    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email!;
    final owner = await _notesService.getUser(email: email);
    final newNote = await _notesService.createNote(owner: owner);
    _note = newNote;
    return newNote;
  }

  void _textControllerListener() async {
    if (_note == null) return;

    final currentText = _textController.text;
    if (_note!.text != currentText) {
      try {
        await _notesService.updateNote(
          note: _note!,
          text: currentText,
        );

        // Update the local _note object to reflect changes
       
          _note = _note!.copyWith(text: currentText);
      
      } catch (e) {
        debugPrint('Error updating note: $e');
      }
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
    _focusNode.dispose();
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
      body: FutureBuilder(
        future: _createOrGetExistingNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _textControllerListener();
              return TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                focusNode: _focusNode,
                decoration: const InputDecoration(
                  hintText: 'Start typing your note...',
                ),
              );

            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      // body: _isLoading
      //     ? const Center(child: CircularProgressIndicator())
      //     : TextField(
      //         controller: _textController,
      //         keyboardType: TextInputType.multiline,
      //         maxLines: null,
      //         decoration: const InputDecoration(
      //           hintText: 'Start typing your note...',
      //         ),
      //       ),
    );
  }
}
