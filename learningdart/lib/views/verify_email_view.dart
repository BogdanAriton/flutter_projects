// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
        title: const Text("Email verification"),
      ),
      body: Column(children: [
        const Text("Please verify your email address."),
        TextButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              print("$user?.uid");
              await user?.sendEmailVerification();
            },
            child: const Text("Send email verification"))
      ]),
    );
  }
}
