
import 'car_model.dart';

class GetCarModelsResponse {
  final bool success;
  final String message;
  final List<CarModel> data;

  GetCarModelsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory GetCarModelsResponse.fromJson(Map<String, dynamic> json) {
    return GetCarModelsResponse(
      success: json['success'],
      message: json['message'],
      data: (json['data'] as List<dynamic>)
          .map((item) => CarModel.fromJson(item))
          .toList(),
    );
  }
}


class CarModel {
  final int id;
  final String name;
  final String image;

  CarModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }
}
