class PriceResponse {
  final bool success;
  final String message;
  final PriceModel data;

  PriceResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PriceResponse.fromJson(Map<String, dynamic> json) {
    return PriceResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: PriceModel.fromJson(json['data'] ?? {}),
    );
  }
}
class PriceModel {
  final double subTotal;
  final double discountAmount;
  final double coinUses;
  final double perHourCharge;
  final double foodAllowance;
  final double stayAllowance;
  final double paidAmount;

  PriceModel({
    required this.subTotal,
    required this.discountAmount,
    required this.coinUses,
    required this.perHourCharge,
    required this.foodAllowance,
    required this.stayAllowance,
    required this.paidAmount,
  });

  factory PriceModel.fromJson(Map<String, dynamic> json) {
    double _parse(dynamic v) =>
        v is double ? v : double.tryParse(v.toString()) ?? 0.0;

    return PriceModel(
      subTotal: _parse(json['sub_total']),
      discountAmount: _parse(json['discount_amount']),
      coinUses: _parse(json['coin_uses']),
      perHourCharge: _parse(json['per_hour_charge']),
      foodAllowance: _parse(json['food_allowance']),
      stayAllowance: _parse(json['stay_allowance']),
      paidAmount: _parse(json['paid_amount']),
    );
  }
}
