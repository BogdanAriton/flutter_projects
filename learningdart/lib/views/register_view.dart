import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import 'package:learningdart/constants/routes.dart' as routes;
import 'package:learningdart/utils/dialogs.dart' as utils;

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        title: const Text("Register"),
      ),
      body: Column(
        children: [
          Center(
            child: TextField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'Enter email here'),
              autocorrect: false,
              enableSuggestions: true,
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
                    .createUserWithEmailAndPassword(
                        email: emailFieldText, password: passFieldText);
                devtools.log(userCreds.toString());
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
                        "Please enter a valid user name or password! Password must have at least 6 characters!";
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
                  "Unable to register",
                  errorMessage,
                );
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  routes.loginRoute,
                  (route) => false,
                );
              },
              child: const Text("Already registered? Login here!"))
        ],
      ),
    );
  }
}
