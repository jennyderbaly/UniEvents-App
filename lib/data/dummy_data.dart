import '../person.dart';
import '../models/event.dart';

// -------------------------------------------------
// Users (saved in‑memory)
List<Person> users = [
  Person(
    id: 'admin',
    name: 'Admin',
    isStudent: false,
    email: 'admin@uni.edu',
    password: 'admin123',
  ),
  Person(
    id: '23',
    name: 'jenny',
    isStudent: true,
    email: 'jenny@uni.edu',
    password: 'jenny123',
  ),
  Person(
    id: '25',
    name: 'aisha',
    isStudent: false,
    email: 'aisha@uni.edu',
    password: 'aisha123',
  ),
  // add more demo students if you like
];

// -------------------------------------------------
// Events (pre‑populated)
List<Event> events = [
  Event(
    title: 'History Talk',
    description: 'Lets learn different cultures.',
    imagePath: 'assets/culturalevent.jpg',
    date: DateTime.now().add(const Duration(days: 2)),
  ),
  Event(
    title: 'tech Talk',
    description: 'Discover more about Flutter.',
    imagePath: 'assets/flutterevent.jpg',
    date: DateTime.now().add(const Duration(days: 20)),
  ),
  Event(
    title: 'Orientation',
    description: 'Welcome ceremony for new students.',
    imagePath: 'assets/orientationevent.jpg',
    date: DateTime.now().add(const Duration(days: 9)),
  ),
  // …more events
];