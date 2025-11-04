class CouponModel {
  final int id;
  final String name;
  final String type;
  final String code;
  final String discountType;
  final double amount;
  final String startDate;
  final String endDate;
  final int status;
  final String createdAt;
  final String updatedAt;

  CouponModel({
    required this.id,
    required this.name,
    required this.type,
    required this.code,
    required this.discountType,
    required this.amount,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: _parseInt(json['id']),
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      code: json['code'] ?? '',
      discountType: json['discount_type'] ?? '',
      amount: _parseDouble(json['amount']),
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      status: _parseInt(json['status']),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static double _parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}

class CouponResponse {
  final bool success;
  final String message;
  final List<CouponModel> coupons;

  CouponResponse({
    required this.success,
    required this.message,
    required this.coupons,
  });

  factory CouponResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> couponList =
        json['data']?['data'] ?? []; // the actual coupons array
    return CouponResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      coupons:
      couponList.map((coupon) => CouponModel.fromJson(coupon)).toList(),
    );
  }
}
