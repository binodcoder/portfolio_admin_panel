class SocialLink {
  const SocialLink({this.id, required this.platform, required this.url});
  final String? id;
  final String platform;
  final String url;

  SocialLink copyWith({String? id, String? platform, String? url}) => SocialLink(
    id: id ?? this.id,
    platform: platform ?? this.platform,
    url: url ?? this.url,
  );

  Map<String, dynamic> toMap() => {'platform': platform, 'url': url};
  factory SocialLink.fromMap(Map<String, dynamic> map) => SocialLink(
    id: map['id'] as String?,
    platform: (map['platform'] ?? '').toString(),
    url: (map['url'] ?? '').toString(),
  );
}
