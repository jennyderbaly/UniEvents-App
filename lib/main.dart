import 'package:flutter/material.dart';
import 'welcome_page.dart';
import 'home_page.dart';
import 'signup_page.dart';
import 'student_page.dart';
import 'admin_page.dart';
import 'add_event_page.dart';

void main() => runApp(const UniEventApp());

class UniEventApp extends StatelessWidget {
  const UniEventApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniEvent',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      initialRoute: '/',
      routes: {
        '/': (c) => const WelcomePage(),
        '/home': (c) => const HomePage(),
        '/signup': (c) => const SignUpPage(),
        '/student': (c) => const StudentPage(),
        '/admin': (c) => const AdminPage(),
        '/addEvent': (_) => const AddEventPage(),
      },
    );
  }
}


