import 'package:flutter/material.dart';
import 'data/dummy_data.dart';
import 'person.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _idCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  bool _isStudent = true;

  void _register() {
    final newPerson = Person(
      id: _idCtrl.text.trim(),
      name: _nameCtrl.text.trim(),
      isStudent: _isStudent,
      email: _emailCtrl.text.trim(),
      password: _pwCtrl.text,
    );
    users.add(newPerson);
    Navigator.pop(context); // back to welcome page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: const Text(
          'SignUp',
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
        child: ListView(
          children: [
            const SizedBox(height: 12),
            Text('ID', textAlign: TextAlign.start, style: const TextStyle(fontSize: 18.0),),
            TextField(
                controller: _idCtrl,
                style: const TextStyle(fontSize: 18.0),
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Enter your ID'
                )
            ),
            Text('Name', textAlign: TextAlign.start, style: const TextStyle(fontSize: 18.0),),
            TextField(
                controller: _nameCtrl,
                style: const TextStyle(fontSize: 18.0),
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Enter your Name'
                )
            ),
            Row(
              children: [
                Checkbox(
                  value: _isStudent,
                  onChanged: (v) => setState(() => _isStudent = v ?? true),
                ),
                const Text('Student'),
              ],
            ),
            Text('Email', textAlign: TextAlign.start, style: const TextStyle(fontSize: 18.0),),
            TextField(
                controller: _emailCtrl,
                style: const TextStyle(fontSize: 18.0),
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Enter your Email'
                )
            ),
            Text('Password', textAlign: TextAlign.start, style: const TextStyle(fontSize: 18.0),),
            TextField(
                controller: _pwCtrl,
                style: const TextStyle(fontSize: 18.0),
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Enter your Password'
                ),
                obscureText: true
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _register, child: const Text('Sign Up')),
          ],
        ),
      ),
    );
  }
}