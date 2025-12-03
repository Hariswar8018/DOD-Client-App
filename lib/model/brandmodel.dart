import 'BrandModel.dart';

class GetBrandsResponse {
  final bool success;
  final String message;
  final List<BrandModel> data;

  GetBrandsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory GetBrandsResponse.fromJson(Map<String, dynamic> json) {
    return GetBrandsResponse(
      success: json['success'],
      message: json['message'],
      data: (json['data'] as List<dynamic>)
          .map((item) => BrandModel.fromJson(item))
          .toList(),
    );
  }
}

class BrandModel {
  final int id;
  final String name;
  final String image;

  BrandModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }
}
