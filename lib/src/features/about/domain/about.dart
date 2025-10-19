class About {
  const About({this.id, required this.value});
  final String? id;
  final String value;

  About copyWith({String? id, String? value}) {
    return About(id: id ?? this.id, value: value ?? this.value);
  }

  Map<String, dynamic> toMap() => <String, dynamic>{'value': value};

  factory About.fromMap(Map<String, dynamic> map) {
    return About(id: map['id'] as String?, value: (map['value'] ?? '').toString());
  }
}
