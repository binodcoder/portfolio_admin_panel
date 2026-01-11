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
}
