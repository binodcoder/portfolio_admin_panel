// ignore_for_file: public_member_api_docs, sort_constructors_first
class ContactInfo {
  const ContactInfo({
    this.id,
    this.email,
    this.phone,
    this.location,
    this.website,
    this.openToWork = true,
    this.message,
  });

  final String? id;
  final String? email;
  final String? phone;
  final String? location;
  final String? website;
  final bool openToWork;
  final String? message;

  Map<String, dynamic> toMap() => {
    'email': email,
    'phone': phone,
    'location': location,
    'website': website,
    'openToWork': openToWork,
    'message': message,
  };

  factory ContactInfo.fromMap(Map<String, dynamic> map) => ContactInfo(
    id: map['id'] as String?,
    email: map['email']?.toString(),
    phone: map['phone']?.toString(),
    location: map['location']?.toString(),
    website: map['website']?.toString(),
    openToWork: (map['openToWork'] ?? true) == true,
    message: map['message']?.toString(),
  );

  ContactInfo copyWith({
    String? id,
    String? email,
    String? phone,
    String? location,
    String? website,
    bool? openToWork,
    String? message,
  }) {
    return ContactInfo(
      id: id ?? this.id,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      website: website ?? this.website,
      openToWork: openToWork ?? this.openToWork,
      message: message ?? this.message,
    );
  }
}
