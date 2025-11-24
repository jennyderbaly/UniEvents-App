class Person {
  final String id;
  final String name;
  final bool isStudent;   // true → student, false → admin
  final String email;
  final String password;

  Person({
    required this.id,
    required this.name,
    required this.isStudent,
    required this.email,
    required this.password,
  });
}