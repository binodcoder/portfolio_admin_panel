// ignore_for_file: public_member_api_docs, sort_constructors_first
class Certification {
  const Certification({
    this.id,
    required this.name,
    this.issuer,
    this.issueDate,
    this.expiryDate,
    this.credentialId,
    this.credentialUrl,
  });

  final String? id;
  final String name;
  final String? issuer;
  final DateTime? issueDate; // YYYY-MM-DD
  final DateTime? expiryDate; // YYYY-MM-DD
  final String? credentialId;
  final String? credentialUrl;

  Map<String, dynamic> toMap() => {
    'name': name,
    'issuer': issuer,
    'issueDate': issueDate?.toIso8601String(),
    'expiryDate': expiryDate?.toIso8601String(),
    'credentialId': credentialId,
    'credentialUrl': credentialUrl,
  };

  factory Certification.fromMap(Map<String, dynamic> map) => Certification(
    id: map['id'] as String?,
    name: (map['name'] ?? '').toString(),
    issuer: map['issuer']?.toString(),
    issueDate: map['issueDate'] == null
        ? null
        : DateTime.parse(map['issueDate'].toString()),
    expiryDate: map['expiryDate'] == null
        ? null
        : DateTime.parse(map['expiryDate'].toString()),
    credentialId: map['credentialId']?.toString(),
    credentialUrl: map['credentialUrl']?.toString(),
  );

  Certification copyWith({
    String? id,
    String? name,
    String? issuer,
    DateTime? issueDate,
    DateTime? expiryDate,
    String? credentialId,
    String? credentialUrl,
  }) {
    return Certification(
      id: id ?? this.id,
      name: name ?? this.name,
      issuer: issuer ?? this.issuer,
      issueDate: issueDate ?? this.issueDate,
      expiryDate: expiryDate ?? this.expiryDate,
      credentialId: credentialId ?? this.credentialId,
      credentialUrl: credentialUrl ?? this.credentialUrl,
    );
  }
}
