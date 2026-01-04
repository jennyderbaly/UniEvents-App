import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
  bool _isLoading = false;

  Future<void> _register() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      final response = await http.post(
        Uri.parse("https://aishachaaban.atwebpages.com/api/register.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id": _idCtrl.text.trim(),
          "name": _nameCtrl.text.trim(),
          "email": _emailCtrl.text.trim(),
          "password": _pwCtrl.text,
          "is_student": _isStudent,
        }),
      );

      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        Navigator.pop(context); // Go back to login page on success
      } else {
        ScaffoldMessenger.of(context).showSnackBar( // Show error in UI
          SnackBar(content: Text('Registration failed: ${data['error']}')),
        );
        print('Registration failed: ${data['error']}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar( // Show connection error
        SnackBar(content: Text('Error connecting to server: $e')),
      );
      print('Error connecting to server: $e');
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
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
            ElevatedButton(
              onPressed: _isLoading ? null : _register, // Disable button while loading
              child: _isLoading
                  ? CircularProgressIndicator() // Show loading indicator
                  : const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
