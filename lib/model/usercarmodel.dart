int toInt(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  if (v is String) return int.tryParse(v) ?? 0;
  return 0;
}

class UserCarModel {
  final int id;
  final String nickName;
  final String number;
  final int brand;
  final int model;
  final int year;
  final int transmission;
  final int fueltype;
  final int status;
  final String bookingstatus;

  UserCarModel({
    required this.id,
    required this.nickName,
    required this.number,
    required this.brand,
    required this.model,
    required this.year,
    required this.transmission,
    required this.fueltype,
    required this.status,
    required this.bookingstatus,
  });

  factory UserCarModel.fromJson(Map<String, dynamic> json) {
    return UserCarModel(
      id: toInt(json["id"]),
      nickName: json["nick_name"] ?? "",
      number: json["number"] ?? "",
      brand: toInt(json["brand"]),
      model: toInt(json["model"]),
      year: toInt(json["year"]),
      transmission: toInt(json["transmission"]),
      fueltype: toInt(json["fueltype"]),
      status: toInt(json["status"]),
      bookingstatus: json["bookingstatus"] ?? "",
    );
  }
}

class UserCarResponse {
  final bool success;
  final String message;
  final List<UserCarModel> data;

  UserCarResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UserCarResponse.fromJson(Map<String, dynamic> json) {
    return UserCarResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: (json["data"] as List<dynamic>)
          .map((e) => UserCarModel.fromJson(e))
          .toList(),
    );
  }
}
