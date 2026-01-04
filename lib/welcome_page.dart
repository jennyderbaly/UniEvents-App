import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'person.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final _idCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  String? _error;
  bool _loading = false;

  Future<void> _login() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final response = await http.post(
        Uri.parse("https://aishachaaban.atwebpages.com/login.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id": _idCtrl.text.trim(),
          "password": _pwCtrl.text,
        }),
      );


      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        final user = Person(
          id: data['users']['id'],
          name: data['users']['name'],
          email: data['users']['email'],
          isStudent: data['users']['is_student'] == 1 ||
              data['users']['is_student'] == '1',

          password: '',
        );

        Navigator.pushReplacementNamed(
          context,
          '/home',
          arguments: user,
        );
      } else {
        setState(() => _error = data['message'] ?? 'Invalid credentials');
      }
    } catch (e) {
      setState(() => _error = 'Unable to connect to server');
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('UniEvent')),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Image.asset('assets/welcomeevent.jpg', height: 180),
          const SizedBox(height: 12),
          TextField(
            controller: _idCtrl,
            decoration: const InputDecoration(labelText: 'ID'),
          ),
          TextField(
            controller: _pwCtrl,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          const SizedBox(height: 12),
          if (_error != null)
            Text(_error!,
                style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _loading ? null : _login,
            child: _loading
                ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
                : const Text('Sign In'),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/signup'),
            child: const Text('Sign Up'),
          ),
        ],
      ),
    ),
  );
}
