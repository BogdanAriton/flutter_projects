import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import 'package:learningdart/constants/routes.dart' as routes;
import 'package:learningdart/utils/dialogs.dart' as utils;

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _HomePageState();
}

class _HomePageState extends State<LoginView> {
  late final TextEditingController email;
  late final TextEditingController password;

  @override
  void initState() {
    email = TextEditingController();
    password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Column(
        children: [
          Center(
            child: TextField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'Enter email here'),
              autocorrect: false,
              enableSuggestions: false,
            ),
          ),
          Center(
            child: TextFormField(
              controller: password,
              decoration:
                  const InputDecoration(hintText: 'Enter password here'),
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
            ),
          ),
          TextButton(
            onPressed: () async {
              final emailFieldText = email.text;
              final passFieldText = password.text;
              try {
                final userCreds = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: emailFieldText, password: passFieldText);
                devtools.log(userCreds.toString());
                if (mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    routes.notesRoute,
                    (route) => false,
                  );
                }
              } on FirebaseAuthException catch (err) {
                devtools.log(err.code);
                String? errorMessage = "";
                switch (err.code) {
                  case 'invalid-email':
                    errorMessage =
                        "Formatting issue!\nEmail address must have the following format: name@mail_provide.domain";
                    break;
                  case 'user-not-found':
                    errorMessage =
                        "Please enter a valid user name or password!";
                    break;
                  case 'invalid-password':
                    errorMessage =
                        "Please enter a valid user name or password!";
                    break;
                  default:
                    errorMessage = "Error message: ${err.message.toString()}";
                    break;
                }

                if (emailFieldText.isEmpty || passFieldText.isEmpty) {
                  errorMessage = "Email or password fields cannot be empty!";
                }

                await utils.okDialog(
                  context,
                  "Unable to login",
                  errorMessage,
                );
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  routes.registernRoute,
                  (route) => false,
                );
              },
              child: const Text("Not registered yet? Register here!")),
        ],
      ),
    );
  }
}
