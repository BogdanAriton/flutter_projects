import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import 'package:learningdart/constants/routes.dart' as routes;

enum MeniuAction { logout }

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  String computeTitle() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return "Welcome: ${user.email.toString()}";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Notes",
              style: TextStyle(fontSize: 20.0),
            ),
            Text(
              computeTitle(),
              style: const TextStyle(
                color: Color.fromARGB(108, 0, 0, 4),
                fontSize: 12.0,
              ),
            )
          ],
        ),
        actions: [
          PopupMenuButton<MeniuAction>(
            onSelected: (value) async {
              switch (value) {
                case MeniuAction.logout:
                  final shouldLogout = await showLogoutDialog(context);
                  devtools.log(shouldLogout.toString());
                  if (shouldLogout) {
                    devtools.log("logging out");
                    await FirebaseAuth.instance.signOut();

                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      FirebaseAuth.instance.currentUser!.reload();
                    }
                    devtools.log("logged out");
                    if (mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          routes.loginRoute, (_) => false);
                    }
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MeniuAction>(
                  value: MeniuAction.logout,
                  child: Text("Log Out"),
                )
              ];
            },
          ),
        ],
      ),
      body: TextButton(
        onPressed: () {
          if (mounted) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              routes.calendarRoute,
              (route) => false,
            );
          }
        },
        child: const Text("Calendar"),
      ),
    );
  }
}

Future<bool> showLogoutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Sign out"),
          content: const Text("Are you sure you want to sign out"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("Cancel")),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text("Log out"))
          ],
        );
      }).then((value) => value ?? false);
}
