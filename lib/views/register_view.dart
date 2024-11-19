import 'package:flutter/material.dart';
import 'package:mypersonalnotes/constants/routes.dart';
import 'package:mypersonalnotes/services/auth/auth_exceptions.dart';
import 'package:mypersonalnotes/services/auth/auth_service.dart';
import 'package:mypersonalnotes/utility/show_error_dialog.dart';

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
        backgroundColor: const Color.fromARGB(255, 94, 117, 247),
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
                await AuthService.firebase()
                    .createUser(email: email, password: password);
                final user = AuthService.firebase().currentUser;
                if(user?.isEmailVerified==false){
                AuthService.firebase().sendEmailVerification();
                // if(i)
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(verifyEmailRoute, (_) => false);

                }

              } on WeakPasswordAuthException {
                if (context.mounted) {
                  await showErroDialog(
                    context,
                    'Error: Weak Password}',
                  );
                }
              } on EmailArleadyInUseAuthException {
                if (context.mounted) {
                  await showErroDialog(
                    context,
                    'Error: email already in use',
                  );
                }
              } on InvalidEmailAuthException {
                if (context.mounted) {
                  await showErroDialog(
                    context,
                    'Error: invalid email',
                  );
                }
              } on GenericAuthException {
                if (context.mounted) {
                  await showErroDialog(
                    context,
                    'Error: Failed to register',
                  );
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
