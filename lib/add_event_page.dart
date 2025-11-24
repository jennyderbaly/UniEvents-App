import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/event.dart';
import 'package:intl/intl.dart';   // only for formatting the selected date

class AddEventPage extends StatefulWidget {
  const AddEventPage({Key? key}) : super(key: key);
  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _imageCtrl = TextEditingController(); // optional asset path
  DateTime? _date;                            // chosen date

  // ---- pick a date with the built‑in date picker ----
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365 * 5)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  // ---- save the new event into the global list ----
  void _save() {
    if (_titleCtrl.text.isEmpty ||
        _descCtrl.text.isEmpty ||
        _date == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields except image are required')),
      );
      return;
    }

    final newEvent = Event(
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      imagePath: _imageCtrl.text.isEmpty
          ? 'assets/default.jpg'          // fallback picture
          : _imageCtrl.text.trim(),
      date: _date!,
    );

    events.add(newEvent);       // <-- add to the in‑memory list
    Navigator.pop(context);     // return to AdminPage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: const Text(
          'Add New Event',
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
          const SizedBox(height: 12),
          TextField(
              controller: _titleCtrl,
              style: const TextStyle(fontSize: 18.0),
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Title'
              )
          ),
          const SizedBox(height: 12),
          TextField(
              controller: _descCtrl,
              style: const TextStyle(fontSize: 18.0),
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Description'
              )
          ),
          const SizedBox(height: 12),
          TextField(
              controller: _imageCtrl,
              style: const TextStyle(fontSize: 18.0),
              decoration: const InputDecoration(
                  labelText: 'Image asset path (optional)',
                  border: OutlineInputBorder(),
                  hintText: 'e.g. assets/event1.jpg'
              )
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  _date == null
                      ? 'No date chosen'
                      : 'Date: ${DateFormat.yMMMd().format(_date!)}',
                ),
              ),
              TextButton(
                onPressed: _pickDate,
                child: const Text('Pick Date'),
              ),
            ],
          ),
          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: _save,
            child: const Text('Save Event'),
          ),
        ],
      ),
    );
  }
}