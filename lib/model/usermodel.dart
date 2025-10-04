class UserData {
  final int id;
  final String firebaseId;
  final String provider;
  final String referralNumber;
  final String name;
  final String role;
  final String email;
  final String mobile;
  final String? emailVerifiedAt;
  final String fcmToken;
  final String platformType;
  final String status;
  final String createdAt;
  final String updatedAt;
  final double? latitude;
  final double? longitude;
  final String? joined;
  final String? lastOnline;
  final bool online; // keep as bool

  UserData({
    required this.id,
    required this.firebaseId,
    required this.provider,
    required this.referralNumber,
    required this.name,
    required this.role,
    required this.email,
    required this.mobile,
    this.emailVerifiedAt,
    required this.fcmToken,
    required this.platformType,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.latitude,
    this.longitude,
    this.joined,
    this.lastOnline,
    required this.online,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? 0,
      firebaseId: json['firebase_id'] ?? '',
      provider: json['provider'] ?? '',
      referralNumber: json['referral_number']?.toString() ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      emailVerifiedAt: json['email_verified_at'],
      fcmToken: json['fcm_token'] ?? '',
      platformType: json['platform_type'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      latitude: json['latitude'] != null ? double.tryParse(json['latitude'].toString()) : null,
      longitude: json['longitude'] != null ? double.tryParse(json['longitude'].toString()) : null,
      joined: json['joined'],
      lastOnline: json['last_online'],
      online: json['online'] == 1 || json['online'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firebase_id': firebaseId,
      'provider': provider,
      'referral_number': referralNumber,
      'name': name,
      'role': role,
      'email': email,
      'mobile': mobile,
      'email_verified_at': emailVerifiedAt,
      'fcm_token': fcmToken,
      'platform_type': platformType,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'latitude': latitude,
      'longitude': longitude,
      'joined': joined,
      'last_online': lastOnline,
      'online': online ? 1 : 0, // store as int for backend
    };
  }
}
