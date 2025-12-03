class SpecialOffersResponse {
  final bool success;
  final String message;
  final List<SpecialOffer> data;

  SpecialOffersResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SpecialOffersResponse.fromJson(Map<String, dynamic> json) {
    return SpecialOffersResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => SpecialOffer.fromJson(item))
          .toList() ??
          [],
    );
  }
}
class SpecialOffer {
  final int id;
  final String title;
  final String image;

  SpecialOffer({
    required this.id,
    required this.title,
    required this.image,
  });

  factory SpecialOffer.fromJson(Map<String, dynamic> json) {
    return SpecialOffer(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      image: json['image'] ?? '',
    );
  }
}
