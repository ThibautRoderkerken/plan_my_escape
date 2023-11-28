class Member {
  final String id;
  final String firstName;
  final String lastName;
  final String mail;

  Member({required this.id, required this.firstName, required this.mail, required this.lastName});

  static Member fromJson(Map<String, dynamic> memberJson) {
    return Member(
      id: memberJson['id'],
      firstName: memberJson['firstname'],
      lastName: memberJson['lastname'],
      mail: memberJson['email'],
    );
  }
}
