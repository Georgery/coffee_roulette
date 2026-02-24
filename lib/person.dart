class Person {
  final String name;
  final String? email;

  Person({required this.name, this.email});

  factory Person.fromLine(String line) {
    final parts = line.split(',').map((s) => s.trim()).toList();
    return Person(
      name: parts[0],
      email: parts.length > 1 && parts[1].isNotEmpty ? parts[1] : null,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Person && name == other.name && email == other.email;

  @override
  int get hashCode => Object.hash(name, email);
}
