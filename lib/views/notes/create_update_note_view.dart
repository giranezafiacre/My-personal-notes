import 'package:flutter/material.dart';
import 'package:mypersonalnotes/services/auth/auth_service.dart';
import 'package:mypersonalnotes/utility/dialogs/cannot_share_empty_note_dialog.dart';
import 'package:mypersonalnotes/utility/generics/get_arguments.dart';
import 'package:mypersonalnotes/services/cloud/cloud_note.dart';
import 'package:mypersonalnotes/services/cloud/firebase_cloud_storage.dart';
import 'package:share_plus/share_plus.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  CloudNote? _note;
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController _textController;
  late FocusNode _focusNode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _notesService = FirebaseCloudStorage();
    _textController = TextEditingController();
    // _initializeNote();
    _textController.addListener(_textControllerListener);
    _focusNode = FocusNode();
  }

  Future<CloudNote> _createOrGetExistingNote(BuildContext context) async {
    debugPrint('Fetching or creating a note...');
    final widgetNote = context.getArgument<CloudNote>();

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
    final email = currentUser.email;
    final userId = currentUser.id;
    final newNote = await _notesService.createNewNote(ownerUserId: userId);
    _note = newNote;
    return newNote;
  }

  void _textControllerListener() async {
    final note = _note;
    final text = _textController.text;
    if (note != null && text.isNotEmpty) {
      await _notesService.updateNote(
        documentId: note.documentId,
        text: text,
      );
    }
  }

  void _deleteNoteIfTextIsEmpty() {
    if (_textController.text.isEmpty && _note != null) {
      _notesService.deleteNote(
        documentId: _note!.documentId,
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
        actions: [
          IconButton(
              onPressed: () async {
                final text = _textController.text;
                if (_note == null || text.isEmpty) {
                  await showCannotShareEmptyDialog(context);
                } else {
                  Share.share(text);
                }
              },
              icon: const Icon(Icons.share))
        ],
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
