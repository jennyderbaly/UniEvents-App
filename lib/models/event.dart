class Event {
  final int id;
  final String title;
  final String description;
  final String eventDate;
  final String image;
  final List<int> participants;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.eventDate,
    required this.image,
    required this.participants,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: int.parse(json['id'].toString()),
      title: json['title'],
      description: json['description'],
      eventDate: json['event_date'],
      image: json['image'],
      participants: (json['participants'] as List)
          .map((p) => int.parse(p.toString()))
          .toList(),
    );
  }
}
