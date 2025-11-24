import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/event.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);
  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  String _selectedMonth = '${DateTime.now().month}';

  // events that belong to the chosen month
  List<Event> get _monthEvents {
    final month = int.parse(_selectedMonth);
    return events.where((e) => e.date.month == month).toList();
  }

  // ---- open the Add‑Event screen ----
  Future<void> _openAddEvent() async {
    // when the page pops we call setState to refresh the list
    await Navigator.pushNamed(context, '/addEvent');
    setState(() {});               // rebuild to show the newly added event
  }

  // ---- delete an event ----
  void _delete(Event ev) => setState(() => events.remove(ev));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.yellow,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ---- month selector (pure Material) ----
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
            onChanged: (v) => setState(() => _selectedMonth = v!),
          ),
          const SizedBox(height: 12),

          // ---- list of events for that month ----
          ..._monthEvents.map((ev) => Card(
            child: ListTile(
              leading: const Icon(Icons.event),
              title: Text(ev.title),
              subtitle: Text(ev.description),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _delete(ev),
              ),
            ),
          )),

          const SizedBox(height: 12),

          // ---- Add Event button (opens the new page) ----
          ElevatedButton(
            onPressed: _openAddEvent,
            child: const Text('Add Event'),
          ),
        ],
      ),
    );
  }
}