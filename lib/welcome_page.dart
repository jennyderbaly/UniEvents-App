import 'package:flutter/material.dart';
import 'data/dummy_data.dart';
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

  void _login() {
    final id = _idCtrl.text.trim();
    final pw = _pwCtrl.text;
    final user = users.firstWhere(
          (p) => p.id == id && p.password == pw,
      orElse: () =>
          Person(
              id: '',
              name: '',
              isStudent: true,
              email: '',
              password: ''
          ),
    );

    if (user.id.isEmpty) {
      setState(() => _error = 'Invalid credentials');
    } else {
      Navigator.pushReplacementNamed(context, '/home',
          arguments: user); // pass Person to home page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: const Text(
            'UniEvent',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.yellow,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Image.asset('assets/welcomeevent.jpg', height: 180),
              const SizedBox(height: 12),
              Text('ID', textAlign: TextAlign.left, style: const TextStyle(fontSize: 18.0),),
              TextField(
                controller: _idCtrl,
                style: const TextStyle(fontSize: 18.0),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Enter your ID'
                )
              ),
              const SizedBox(height: 12),
              Text('Password', textAlign: TextAlign.start, style: const TextStyle(fontSize: 18.0)),
              TextField(
                  controller: _pwCtrl,
                  style: const TextStyle(fontSize: 18.0),
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Enter your Password'
                  ),
                  obscureText: true
              ),
              const SizedBox(height: 12),
              if (_error != null)
                Text(_error!,
                  style: const TextStyle(color: Colors.red)),
              ElevatedButton(onPressed: _login, child: const Text('Sign In')),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/signup'),
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
    );
    }
}