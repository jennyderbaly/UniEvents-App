import 'package:flutter/material.dart';
import 'data/dummy_data.dart';
import 'person.dart';
import 'models/event.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  // Helper to navigate based on role

  void _goToRolePage(BuildContext ctx, Person user) {
    final route = user.isStudent ? '/student' : '/admin';
    Navigator.pushNamed(ctx, route, arguments: user);   // <-- pass user
  }

  @override
  Widget build(BuildContext context) {
    // receive Person from login
    final Person user = ModalRoute.of(context)!.settings.arguments as Person;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                "Welcome, ${user.name}",
                style: const TextStyle(
                  color: Colors.yellow,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                )
            ),
            const Text(
                "Your hub for university events",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                )
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
                'Past Events',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                )
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: events.length,
                itemBuilder: (_, i) {
                  final e = events[i];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    child: ListTile(
                      leading: Image.asset(e.imagePath, width: 120, fit: BoxFit.cover),
                      title: Text(e.title),
                      subtitle: Text(e.description),
                    ),
                  );
                },
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () => _goToRolePage(context, user),
                child: const Text('View More'),
              )
            ),
          ],
        ),
      ),
    );
  }
}