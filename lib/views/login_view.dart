import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
           style: TextStyle(
            color: Color.fromARGB(255, 244, 245, 248), // Text color in AppBar
          ),),
        backgroundColor: Color.fromARGB(255, 94, 117, 247),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email1,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            enableSuggestions: false,
            decoration: const InputDecoration(hintText: 'Please enter you email'),
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
                    .signInWithEmailAndPassword(email: email, password: password);
                print(userCredential);
              } on FirebaseAuthException catch (e) {
                print('---------------------------');
                print(e.code);
                if (e.code == 'user-not-found') {
                  print('not authenticated');
                } else if (e.code == 'wrong-password') {
                  print('wrong-password');
                }
      
                print('---------------------------');
                print(e.message);
                print('---------------------------');
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/register/',
                (route) => false,
              );
            },
            child: Text('Not Registered? Register here!'),
          )
        ],
      ),
    );
  }
}
