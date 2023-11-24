class Member {
  final String id;
  final String name;

  Member({required this.id, required this.name});

  static Member fromJson(Map<String, dynamic> memberJson) {
    return Member(
      id: memberJson['id'],
      name: memberJson['name'],
    );
  }
}
