import 'package:flutter/material.dart';
import 'package:mypersonalnotes/constants/routes.dart';
import 'package:mypersonalnotes/services/auth/auth_service.dart';

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // The back button icon
          onPressed: () {
            Navigator.of(context).pop(); // Go back to the previous screen
          },
        ),
      ),
      body: Column(
        children: [
          const Text('We \'ve sent you email Please open it and verify'),
          const Text(
              'If you have\'t received email yet, press the button below'),
          TextButton(
              onPressed: () async {
                AuthService.firebase().sendEmailVerification();
              },
              child: const Text('Send email verification')),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().logout();
              if (!context.mounted) return;
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
