import 'package:dod/model/ordermodel.dart' show OrderModel;

class BookingsResponse {
  final bool success;
  final String message;
  final PaginationData data;

  BookingsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory BookingsResponse.fromJson(Map<String, dynamic> json) {
    return BookingsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: PaginationData.fromJson(json['data'] ?? {}),
    );
  }
}
class PaginationData {
  final int currentPage;
  final List<OrderModel> bookings;
  final int lastPage;
  final int perPage;
  final int total;

  PaginationData({
    required this.currentPage,
    required this.bookings,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory PaginationData.fromJson(Map<String, dynamic> json) {
    final list = json['data'] as List? ?? [];

    return PaginationData(
      currentPage: json['current_page'] ?? 1,
      bookings: list.map((e) => OrderModel.fromJson(e)).toList(),
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 0,
      total: json['total'] ?? 0,
    );
  }
}
