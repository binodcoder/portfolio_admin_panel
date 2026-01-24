// ignore_for_file: public_member_api_docs, sort_constructors_first
class Education {
  const Education({
    this.id,
    required this.institution,
    this.degree,
    this.field,
    this.start,
    this.end,
    this.location,
    this.gpa,
    this.description,
  });

  final String? id;
  final String institution;
  final String? degree;
  final String? field;
  final DateTime? start; // YYYY-MM-DD
  final DateTime? end; // YYYY-MM-DD
  final String? location;
  final String? gpa;
  final String? description;

  Map<String, dynamic> toMap() => {
    'institution': institution,
    'degree': degree,
    'field': field,
    'start': start?.toIso8601String(),
    'end': end?.toIso8601String(),
    'location': location,
    'gpa': gpa,
    'description': description,
  };

  factory Education.fromMap(Map<String, dynamic> map) => Education(
    id: map['id'] as String?,
    institution: (map['institution'] ?? '').toString(),
    degree: map['degree']?.toString(),
    field: map['field']?.toString(),
    start: map['start'] == null ? null : DateTime.parse(map['start'].toString()),
    end: map['end'] == null ? null : DateTime.parse(map['end'].toString()),
    location: map['location']?.toString(),
    gpa: map['gpa']?.toString(),
    description: map['description']?.toString(),
  );

  Education copyWith({
    String? id,
    String? institution,
    String? degree,
    String? field,
    DateTime? start,
    DateTime? end,
    String? location,
    String? gpa,
    String? description,
  }) {
    return Education(
      id: id ?? this.id,
      institution: institution ?? this.institution,
      degree: degree ?? this.degree,
      field: field ?? this.field,
      start: start ?? this.start,
      end: end ?? this.end,
      location: location ?? this.location,
      gpa: gpa ?? this.gpa,
      description: description ?? this.description,
    );
  }
}
