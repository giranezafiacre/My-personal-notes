import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypersonalnotes/constants/routes.dart';
import 'package:mypersonalnotes/services/auth/auth_exceptions.dart';
import 'package:mypersonalnotes/services/auth/bloc/auth_bloc.dart';
import 'package:mypersonalnotes/services/auth/bloc/auth_event.dart';
import 'package:mypersonalnotes/services/auth/bloc/auth_state.dart';
import 'package:mypersonalnotes/utility/dialogs/error_dialog.dart';
import 'package:mypersonalnotes/utility/dialogs/loading_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email1;
  late final TextEditingController _password;
  CloseDialog? _closeDialogHandle;

  @override
  void initState() {
    // TODO: implement initState
    _email1 = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _email1.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return BlocListener<AuthBloc, AuthState>(listener: (context,state){

    // },)
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          final closeDialog = _closeDialogHandle;

          if (!state.isLoading && closeDialog != null) {
            closeDialog();
            _closeDialogHandle = null;
          }
          if (state.isLoading && _closeDialogHandle == null) {
            _closeDialogHandle = showLoadingDialog(
              context: context,
              text: 'Loading...',
            );
          }
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(context, 'User not found');
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, 'Wrong credentials');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Authentication error');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Login',
            style: TextStyle(
              color: Color.fromARGB(255, 244, 245, 248), // Text color in AppBar
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 94, 117, 247),
          iconTheme: const IconThemeData(
            color: Colors.white, // Sets the back button color to white
          ),
        ),
        body: Column(
          children: [
            TextField(
              controller: _email1,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              enableSuggestions: false,
              decoration:
                  const InputDecoration(hintText: 'Please enter you email'),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration:
                  const InputDecoration(hintText: 'Please enter you password'),
            ),
            TextButton(
              onPressed: () async {
                final email = _email1.text;
                final password = _password.text;
                context.read<AuthBloc>().add(
                      AuthEventLogIn(
                        email,
                        password,
                      ),
                    );
              },
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(
                      const AuthEventShouldRegister(),
                    );
              },
              child: const Text('Not Registered? Register here!'),
            )
          ],
        ),
      ),
    );
  }
}
