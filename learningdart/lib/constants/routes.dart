import 'package:flutter/material.dart';

import 'package:learningdart/views/login_view.dart';
import 'package:learningdart/views/register_view.dart';
import 'package:learningdart/views/notes_veiew.dart';
// import 'package:learningdart/views/calendar.dart';

const loginRoute = '/login/';
const registernRoute = '/register/';
const notesRoute = '/notes/';
const calendarRoute = '/calendar/';

Map<String, Widget Function(BuildContext)> routesDef = {
  loginRoute: (context) => const LoginView(),
  registernRoute: (context) => const RegisterView(),
  notesRoute: (context) => const NotesView(),
  // calendarRoute: (constext) => const Calendar(title: "Calendar"),
};
