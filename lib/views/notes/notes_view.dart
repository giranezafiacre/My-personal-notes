import 'package:flutter/material.dart';
import 'package:mypersonalnotes/constants/routes.dart';
import 'package:mypersonalnotes/enums/menu_action.dart';
import 'package:mypersonalnotes/services/auth/auth_service.dart';
import 'package:mypersonalnotes/services/cloud/cloud_note.dart';
import 'package:mypersonalnotes/services/cloud/firebase_cloud_storage.dart';
import 'package:mypersonalnotes/utility/dialogs/logout_dialog.dart';
import 'package:mypersonalnotes/views/notes/notes_list_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              )),
          PopupMenuButton<MenuAction>(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogoutDialog(context);
                  if (shouldLogout) {
                    await AuthService.firebase().logout();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (_) => false);
                  }
                  break;
                // TODO: Handle this case.
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Logout'),
                ),
              ];
            },
          )
        ],
        title: const Text(
          'Your Notes',
          style: TextStyle(
            color: Color.fromARGB(255, 244, 245, 248), // Text color in AppBar
          ),
        ),
        shadowColor: const Color.fromARGB(255, 39, 54, 63),
        backgroundColor: const Color.fromARGB(255, 94, 117, 247),
        elevation: 4.0,
      ),
      body: StreamBuilder(
          stream: _notesService.allNotes(ownerUserId: userId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const Center(child: Text('No connection.'));
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allNotes = snapshot.data as Iterable<CloudNote>;
                  if (allNotes.isEmpty) {
                    return const Center(child: Text('No notes available.'));
                  } else {
                    print('allNotes: $allNotes');
                    return NotesListView(
                      notes: allNotes,
                      onDeleteNote: (note) async {
                        await _notesService.deleteNote(documentId: note.documentId);
                      },
                      onTap: (note) => {
                        Navigator.of(context).pushNamed(
                          createOrUpdateNoteRoute,
                          arguments: note,
                        )
                      },
                    );
                  }
                } else {
                  return const Text('no notes');
                }

              // TODO: Handle this case.
              case ConnectionState.done:
                return const Center(child: Text('Stream closed.'));
              default:
                return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
