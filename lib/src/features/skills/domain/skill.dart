class Skill {
  const Skill({this.id, required this.name, required this.level, this.category});
  final String? id;
  final String name;
  final int level; // 0-100
  final String? category;

  Skill copyWith({String? id, String? name, int? level, String? category}) {
    return Skill(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'level': level,
        'category': category,
      };

  factory Skill.fromMap(Map<String, dynamic> map) {
    return Skill(
      id: map['id'] as String?,
      name: (map['name'] ?? '').toString(),
      level: (map['level'] ?? 0) is int ? (map['level'] as int) : int.tryParse(map['level'].toString()) ?? 0,
      category: (map['category']?.toString()),
    );
  }
}

