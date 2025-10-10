class OrderModel {
  final int id;
  final int userId;
  final String bookingType;
  final String tripType;
  final String pickupLocation;
  final String dropLocation;
  final String paymentMethod;
  final double amount;
  final String status;
  final DateTime createdAt;
  final User user;

  OrderModel({
    required this.id,
    required this.userId,
    required this.bookingType,
    required this.tripType,
    required this.pickupLocation,
    required this.dropLocation,
    required this.paymentMethod,
    required this.amount,
    required this.status,
    required this.createdAt,
    required this.user,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: _parseInt(json['id']),
      userId: _parseInt(json['user_id']),
      bookingType: json['booking_type'] ?? '',
      tripType: json['trip_type'] ?? '',
      pickupLocation: json['pickup_location'] ?? '',
      dropLocation: json['drop_location'] ?? '',
      paymentMethod: json['paymentmethod'] ?? '',
      amount: _parseDouble(json['amount']),
      status: json['status'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      user: User.fromJson(json['user'] ?? {}),
    );
  }

  // ✅ Helper functions for safe parsing
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
class User {
  final int id;
  final String name;
  final String email;
  final String mobile;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: OrderModel._parseInt(json['id']),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile']?.toString() ?? '',
    );
  }
}
