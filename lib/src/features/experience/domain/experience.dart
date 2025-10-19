class Experience {
  const Experience({
    this.id,
    required this.company,
    required this.title,
    this.location,
    this.start,
    this.end,
    this.current = false,
    this.description,
    this.technologies = const <String>[],
  });

  final String? id;
  final String company;
  final String title;
  final String? location;
  final String? start; // e.g. 2023-01
  final String? end; // e.g. 2024-06
  final bool current;
  final String? description;
  final List<String> technologies;

  Experience copyWith({
    String? id,
    String? company,
    String? title,
    String? location,
    String? start,
    String? end,
    bool? current,
    String? description,
    List<String>? technologies,
  }) {
    return Experience(
      id: id ?? this.id,
      company: company ?? this.company,
      title: title ?? this.title,
      location: location ?? this.location,
      start: start ?? this.start,
      end: end ?? this.end,
      current: current ?? this.current,
      description: description ?? this.description,
      technologies: technologies ?? this.technologies,
    );
  }

  Map<String, dynamic> toMap() => {
        'company': company,
        'title': title,
        'location': location,
        'start': start,
        'end': end,
        'current': current,
        'description': description,
        'technologies': technologies,
      };

  factory Experience.fromMap(Map<String, dynamic> map) {
    final techs = (map['technologies'] as List?)?.map((e) => e.toString()).toList() ?? <String>[];
    return Experience(
      id: map['id'] as String?,
      company: (map['company'] ?? '').toString(),
      title: (map['title'] ?? '').toString(),
      location: map['location']?.toString(),
      start: map['start']?.toString(),
      end: map['end']?.toString(),
      current: (map['current'] ?? false) == true,
      description: map['description']?.toString(),
      technologies: techs,
    );
  }
}

