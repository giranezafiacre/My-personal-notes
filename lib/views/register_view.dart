import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:mypersonalnotes/constants/routes.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email1;
  late final TextEditingController _password;

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
    // TODO: Handle this case.
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register',
          style: TextStyle(
            color: Color.fromARGB(255, 244, 245, 248), // Text color in AppBar
          ),
        ),
        backgroundColor: Color.fromARGB(255, 94, 117, 247),
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
              try {
                final userCredential = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: email, password: password);
                print(userCredential);
              } on FirebaseAuthException catch (e) {
                switch (e.code) {
                  case 'weak-password':
                    print('Fiacre weak password');
                    break;
                  case 'email-already-in-use':
                    print('Fiacre you have already used this email');
                    break;
                  case 'invalid-email':
                    print('Fiacre this email is invalid');
                    break;
                  default:
                    print('An unexpected error occurred: ${e.code}');
                }
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (route) => false,
              );
            },
            child: const Text('Already Registered? Login here!'),
          )
        ],
      ),
    );
  }
}
