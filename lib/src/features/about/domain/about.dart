// ignore_for_file: public_member_api_docs, sort_constructors_first
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

  @override
  bool operator ==(covariant About other) {
    if (identical(this, other)) return true;

    return other.id == id && other.value == value;
  }

  @override
  int get hashCode => id.hashCode ^ value.hashCode;
}
