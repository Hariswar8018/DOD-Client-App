
class PriceResponse {
  final bool success;
  final String message;
  final PriceModel? data;

  PriceResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PriceResponse.fromJson(Map<String, dynamic> json) {
    return PriceResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? "",
      data: json['data'] != null ? PriceModel.fromJson(json['data']) : null,
    );
  }
}


class PriceModel {
  final double baseChargesPerKm;
  final double hourlyChargesPrice;
  final double outStationCharges;
  final double foodAccommodationCharges;
  final double driverCommissionRate;
  final double driverWithdrawalLimit;
  final double referredUserAmount;
  final double newUserAmount;
  final double newDriverAmount;

  PriceModel({
    required this.baseChargesPerKm,
    required this.hourlyChargesPrice,
    required this.outStationCharges,
    required this.foodAccommodationCharges,
    required this.driverCommissionRate,
    required this.driverWithdrawalLimit,
    required this.referredUserAmount,
    required this.newUserAmount,
    required this.newDriverAmount,
  });

  factory PriceModel.fromJson(Map<String, dynamic> json) {
    return PriceModel(
      baseChargesPerKm: _toDouble(json['base_chargesperkm']),
      hourlyChargesPrice: _toDouble(json['hourly_charges_price']),
      outStationCharges: _toDouble(json['out_station_charges']),
      foodAccommodationCharges: _toDouble(json['food_accommodation_charges']),
      driverCommissionRate: _toDouble(json['driver_commission_rate']),
      driverWithdrawalLimit: _toDouble(json['driver_withdrawal_limit']),
      referredUserAmount: _toDouble(json['referred_user_amount']),
      newUserAmount: _toDouble(json['new_user_amount']),
      newDriverAmount: _toDouble(json['new_driver_amount']),
    );
  }

  static double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    return double.tryParse(v.toString()) ?? 0.0;
  }
}
