import 'package:flutter/material.dart';
import 'data/dummy_data.dart';
import 'models/event.dart';
import 'person.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({Key? key}) : super(key: key);
  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  String _filter = 'this week';
  final Set<Event> _selected = {};

  // Helper to get events according to filter
  List<Event> get _filteredEvents {
    final now = DateTime.now();
    if (_filter == 'this week') {
      final end = now.add(const Duration(days: 7));
      return events.where((e) => e.date.isAfter(now) && e.date.isBefore(end)).toList();
    } else if (_filter == 'next week') {
      final start = now.add(const Duration(days: 7));
      final end = now.add(const Duration(days: 14));
      return events.where((e) => e.date.isAfter(start) && e.date.isBefore(end)).toList();
    } else {
      // later
      final later = now.add(const Duration(days: 14));
      return events.where((e) => e.date.isAfter(later)).toList();
    }
  }

  void _joinSelected(Person user) {
    setState(() {
      for (var ev in _selected) {
        if (!ev.participants.contains(user.id)) ev.participants.add(user.id);
      }
      _selected.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Person user = ModalRoute.of(context)!.settings.arguments as Person;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: const Text(
          'Student Dashboard',
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
            // Radio filter
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
            Expanded(
              child: ListView.builder(
                itemCount: _filteredEvents.length,
                itemBuilder: (_, i) {
                  final ev = _filteredEvents[i];
                  final checked = _selected.contains(ev);
                  return Card(
                    child: ListTile(
                      leading: Image.asset(ev.imagePath, width: 60, fit: BoxFit.cover),
                      title: Text(ev.title),
                      subtitle: Text(ev.description),
                      trailing: Checkbox(
                        value: checked,
                        onChanged: (v) => setState(() {
                          v == true ? _selected.add(ev) : _selected.remove(ev);
                        }),
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _selected.isEmpty ? null : () => _joinSelected(user),
              child: const Text('Join Selected Events'),
            ),
            const Divider(),
            const Text('Joined Events', style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView(
                children: events
                    .where((e) => e.participants.contains(user.id))
                    .map((e) => ListTile(
                  leading: Image.asset(e.imagePath, width: 50, fit: BoxFit.cover),
                  title: Text(e.title),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => setState(() => e.participants.remove(user.id)),
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