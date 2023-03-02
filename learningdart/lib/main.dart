import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:learningdart/firebase_options.dart';
import 'views/login_view.dart';
import 'views/verify_email_view.dart';
import 'views/notes_veiew.dart';
import 'package:learningdart/constants/routes.dart' as routes;
// import 'package:learningdart/views/calendar.dart';
import 'dart:developer' as devtools show log;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'MyNotes',
    // scrollBehavior: MyCustomScrollBehavior(),
    theme: ThemeData(
      primarySwatch: Colors.cyan,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: const HomePage(),
    routes: routes.routesDef,
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (FirebaseAuth.instance.currentUser != null) {
              devtools.log("logged in");
              FirebaseAuth.instance.currentUser!.reload();

              final user = FirebaseAuth.instance.currentUser;
              devtools.log(user.toString());
              if (user?.emailVerified ?? false) {
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            }
            return const LoginView();
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
