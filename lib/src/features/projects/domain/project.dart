class Project {
  const Project({this.id, required this.title, this.description, this.repoUrl, this.liveUrl, this.tags = const []});
  final String? id;
  final String title;
  final String? description;
  final String? repoUrl;
  final String? liveUrl;
  final List<String> tags;

  Project copyWith({String? id, String? title, String? description, String? repoUrl, String? liveUrl, List<String>? tags}) {
    return Project(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      repoUrl: repoUrl ?? this.repoUrl,
      liveUrl: liveUrl ?? this.liveUrl,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'description': description,
        'repoUrl': repoUrl,
        'liveUrl': liveUrl,
        'tags': tags,
      };

  factory Project.fromMap(Map<String, dynamic> map) {
    final tags = (map['tags'] as List?)?.map((e) => e.toString()).toList() ?? <String>[];
    return Project(
      id: map['id'] as String?,
      title: (map['title'] ?? '').toString(),
      description: map['description']?.toString(),
      repoUrl: map['repoUrl']?.toString(),
      liveUrl: map['liveUrl']?.toString(),
      tags: tags,
    );
  }
}

