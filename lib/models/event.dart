class Event {
  final String title;
  final String description;
  final String imagePath; // e.g. 'assets/event1.jpg'
  final DateTime date;    // used for week filtering
  final List<String> participants = []; // list of user IDs

  Event({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.date,
  });
}