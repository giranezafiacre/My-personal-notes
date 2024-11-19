import 'package:flutter/material.dart';
import 'package:mypersonalnotes/constants/routes.dart';
import 'package:mypersonalnotes/enums/menu_action.dart';
import 'package:mypersonalnotes/services/auth/auth_service.dart';
import 'package:mypersonalnotes/services/crud/notes_services.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NotesService _notesService;
  String? get userEmail => AuthService.firebase().currentUser!.email;

  @override
  void initState() {
    _notesService = NotesService();
    super.initState();
  }

  @override
  void dispose() {
    _notesService.closeDb();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
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
          'Main UI',
          style: TextStyle(
            color: Color.fromARGB(255, 244, 245, 248), // Text color in AppBar
          ),
        ),
        shadowColor: const Color.fromARGB(255, 39, 54, 63),
        backgroundColor: const Color.fromARGB(255, 94, 117, 247),
        elevation: 4.0,
      ),
      body: FutureBuilder(
          future: _notesService.getOrCreateUser(email: userEmail ?? ''),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return StreamBuilder(
                    stream: _notesService.allNotes,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        // TODO: Handle this case.
                        case ConnectionState.waiting:
                          return Text('Waiting for all notes...');

                        case ConnectionState.active:
                        // TODO: Handle this case.
                        case ConnectionState.done:
                        // TODO: Handle this case.
                        default:
                          return CircularProgressIndicator();
                      }
                    });
              default:
                return CircularProgressIndicator();
            }
          }),
    );
  }
}

Future<bool> showLogoutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Are you sure you want to signout?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Logout'))
        ],
      );
    },
  ).then((value) => value ?? false);
}
