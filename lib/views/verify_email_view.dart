import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mypersonalnotes/constants/routes.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Verify',
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
          const Text('We \'ve sent you email Please open it and verify'),
          const Text(
              'If you have\'t received email yet, press the button below'),
          TextButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
              },
              child: const Text('Send email verification')),
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (_) => false);
            },
            child: const Text('Restart'),
          )
        ],
      ),
    );
  }
}
