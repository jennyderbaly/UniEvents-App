import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'models/event.dart';
import 'person.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({Key? key}) : super(key: key);

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  String _filter = 'this week';
  final Set<int> _selectedEventIds = {};
  List<Event> _events = [];
  bool _loading = true;

  final String baseUrl = "https://aishachaaban.atwebpages.com"; // your domain

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  // Fetch all events from server
  Future<void> fetchEvents() async {
    try {
      final res = await http.get(Uri.parse("$baseUrl/api/get_events.php"));
      final data = jsonDecode(res.body) as List;

      setState(() {
        _events = data.map((e) => Event.fromJson(e)).toList();
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  // Filter events by selected timeframe
  List<Event> get _filteredEvents {
    final now = DateTime.now();

    return _events.where((e) {
      final date = DateTime.parse(e.eventDate);

      if (_filter == 'this week') {
        return date.isAfter(now) && date.isBefore(now.add(const Duration(days: 7)));
      } else if (_filter == 'next week') {
        return date.isAfter(now.add(const Duration(days: 7))) &&
            date.isBefore(now.add(const Duration(days: 14)));
      } else {
        return date.isAfter(now.add(const Duration(days: 14)));
      }
    }).toList();
  }

  // Join selected events
  Future<void> joinSelected(Person user) async {
    final userId = int.parse(user.id); // convert String → int

    for (var eventId in _selectedEventIds) {
      await http.post(
        Uri.parse("$baseUrl/api/join_event.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"event_id": eventId, "user_id": userId}),
      );
    }

    _selectedEventIds.clear();
    await fetchEvents(); // refresh events
  }

  // Leave event
  Future<void> leaveEvent(int eventId, String userIdStr) async {
    final userId = int.parse(userIdStr);

    await http.post(
      Uri.parse("$baseUrl/api/leave_event.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"event_id": eventId, "user_id": userId}),
    );

    await fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    final Person user = ModalRoute.of(context)!.settings.arguments as Person;
    final userId = int.parse(user.id);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        centerTitle: true,
        title: const Text(
          'Student Dashboard',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.yellow,
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // FILTER RADIO BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: ['this week', 'next week', 'later']
                  .map((opt) => Row(
                children: [
                  Radio<String>(
                    value: opt,
                    groupValue: _filter,
                    onChanged: (v) => setState(() => _filter = v!),
                  ),
                  Text(opt),
                ],
              ))
                  .toList(),
            ),
            const SizedBox(height: 8),

            // AVAILABLE EVENTS
            Expanded(
              child: ListView.builder(
                itemCount: _filteredEvents.length,
                itemBuilder: (_, i) {
                  final ev = _filteredEvents[i];
                  final alreadyJoined = ev.participants.contains(userId);
                  final selected = _selectedEventIds.contains(ev.id);

                  return Card(
                    child: ListTile(
                      leading: Image.network(
                        "$baseUrl/${ev.image}",
                        width: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                        const Icon(Icons.image),
                      ),
                      title: Text(ev.title),
                      subtitle: Text(ev.description),
                      trailing: alreadyJoined
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : Checkbox(
                        value: selected,
                        onChanged: (v) {
                          setState(() {
                            v == true
                                ? _selectedEventIds.add(ev.id)
                                : _selectedEventIds.remove(ev.id);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),

            ElevatedButton(
              onPressed: _selectedEventIds.isEmpty
                  ? null
                  : () => joinSelected(user),
              child: const Text('Join Selected Events'),
            ),

            const Divider(),
            const Text(
              'Joined Events',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            // JOINED EVENTS
            Expanded(
              child: ListView(
                children: _events
                    .where((e) => e.participants.contains(userId))
                    .map((e) => ListTile(
                  leading: Image.network(
                    "$baseUrl/${e.image}",
                    width: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image),
                  ),
                  title: Text(e.title),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => leaveEvent(e.id, user.id),
                  ),
                ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
