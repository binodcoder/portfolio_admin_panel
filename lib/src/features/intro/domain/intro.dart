class Intro {
  const Intro({this.id, required this.value});
  final String? id;
  final String value;

  Intro copyWith({String? id, String? value}) {
    return Intro(id: id ?? this.id, value: value ?? this.value);
  }

  Map<String, dynamic> toMap() => <String, dynamic>{'value': value};

  factory Intro.fromMap(Map<String, dynamic> map) {
    return Intro(id: map['id'] as String?, value: (map['value'] ?? '').toString());
  }
  @override
  String toString() => 'Intro(id: ${id ?? 'null'}, value: $value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Intro && other.id == id && other.value == value;
  }

  @override
  int get hashCode => Object.hash(id, value);
}
