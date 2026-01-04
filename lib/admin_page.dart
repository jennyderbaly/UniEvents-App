import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/event.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  String _selectedMonth = DateTime.now().month.toString();
  late Future<List<Event>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _eventsFuture = fetchEvents();
  }

  Future<List<Event>> fetchEvents() async {
    final res = await http.get(
      Uri.parse('https://aishachaaban.atwebpages.com/api/get_events.php'),
    );

    final List data = jsonDecode(res.body);
    return data.map((e) => Event.fromJson(e)).toList();
  }

  Future<void> _refresh() async {
    setState(() {
      _eventsFuture = fetchEvents();
    });
  }

  List<Event> _filterByMonth(List<Event> events) {
    final month = int.parse(_selectedMonth);
    return events.where((e) {
      final eventMonth = DateTime.parse(e.eventDate).month;
      return eventMonth == month;
    }).toList();
  }

  Future<void> _openAddEvent() async {
    final result = await Navigator.pushNamed(context, '/addEvent');
    if (result == true) {
      _refresh();
    }
  }

  Future<void> _deleteEvent(int eventId) async {
    try {
      final res = await http.post(
        Uri.parse('https://aishachaaban.atwebpages.com/api/delete_event.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'event_id': eventId}),
      );

      final data = jsonDecode(res.body);

      if (data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event deleted')),
        );
        _refresh();
      } else {
        throw Exception(data['error'] ?? 'Delete failed');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        centerTitle: true,
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.yellow,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<Event>>(
          future: _eventsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            final filtered = _filterByMonth(snapshot.data!);

            return ListView(
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedMonth,
                  decoration: const InputDecoration(
                    labelText: 'Month',
                    border: OutlineInputBorder(),
                  ),
                  items: List.generate(
                    12,
                        (i) => DropdownMenuItem(
                      value: '${i + 1}',
                      child: Text('Month ${i + 1}'),
                    ),
                  ),
                  onChanged: (v) {
                    setState(() => _selectedMonth = v!);
                  },
                ),
                const SizedBox(height: 12),

                if (filtered.isEmpty)
                  const Center(child: Text('No events for this month')),

                ...filtered.map(
                      (ev) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.event),
                      title: Text(ev.title),
                      subtitle: Text(ev.description),
                      trailing: IconButton(
                        icon:
                        const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteEvent(ev.id),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: _openAddEvent,
                  child: const Text('Add Event'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
