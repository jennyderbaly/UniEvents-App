import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'person.dart';
import 'models/event.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Future<List<Event>> fetchEvents() async {
    final response = await http.get(
      Uri.parse('https://aishachaaban.atwebpages.com/api/get_events.php'),
    );

    if (response.statusCode != 200) {
      throw Exception('Server error');
    }

    final List data = jsonDecode(response.body);

    return data.map((e) => Event.fromJson(e)).toList();
  }

  void _goToRolePage(BuildContext context, Person user) {
    final route = user.isStudent ? '/student' : '/admin';
    Navigator.pushNamed(context, route, arguments: user);
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args == null || args is! Person) {
      return const Scaffold(
        body: Center(child: Text('User not found')),
      );
    }

    final Person user = args;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        centerTitle: true,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome, ${user.name}",
              style: const TextStyle(
                color: Colors.yellow,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Your hub for university events",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<Event>>(
          future: fetchEvents(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            final events = snapshot.data!;

            if (events.isEmpty) {
              return const Center(child: Text('No events available'));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Events',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Divider(),

                Expanded(
                  child: ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final e = events[index];
                      final joined =
                      e.participants.contains(user.id);

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          leading: Image.network(
                            'https://aishachaaban.atwebpages.com/images/${e.image}',
                            width: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                            const Icon(Icons.image),
                          ),
                          title: Text(e.title),
                          subtitle: Text(
                            '${e.description}\nDate: ${e.eventDate}',
                          ),
                          trailing: joined
                              ? const Icon(Icons.check_circle,
                              color: Colors.green)
                              : null,
                        ),
                      );
                    },
                  ),
                ),

                Center(
                  child: ElevatedButton(
                    onPressed: () => _goToRolePage(context, user),
                    child: const Text('View More'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
