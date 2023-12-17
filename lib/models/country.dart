class Country {
  final String name;
  final String code;

  Country({required this.name, required this.code});

  static Country fromJson(Map<String, dynamic> json) {
    String name = json['name'] ?? 'Belgium';
    String code = json['code'] ?? '2060';

    return Country(
      name: name,
      code: code,
    );
  }
}
