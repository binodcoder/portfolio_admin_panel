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
  final String? issueDate; // YYYY-MM
  final String? expiryDate; // YYYY-MM
  final String? credentialId;
  final String? credentialUrl;

  Map<String, dynamic> toMap() => {
        'name': name,
        'issuer': issuer,
        'issueDate': issueDate,
        'expiryDate': expiryDate,
        'credentialId': credentialId,
        'credentialUrl': credentialUrl,
      };

  factory Certification.fromMap(Map<String, dynamic> map) => Certification(
        id: map['id'] as String?,
        name: (map['name'] ?? '').toString(),
        issuer: map['issuer']?.toString(),
        issueDate: map['issueDate']?.toString(),
        expiryDate: map['expiryDate']?.toString(),
        credentialId: map['credentialId']?.toString(),
        credentialUrl: map['credentialUrl']?.toString(),
      );
}

