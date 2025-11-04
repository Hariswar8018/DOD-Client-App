




import 'package:dio/dio.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../../api.dart' show Api;
import '../../login/bloc/login/view.dart';


class BookingFunction{

  static final Dio dio = Dio(
    BaseOptions(validateStatus: (status) => status != null && status < 500),
  );


  static Future<String?> updateBookingStatus({
    required String bookingId,
    required BookingStatus status,
  }) async {
    const allowedStatuses = [
      'open',
      'accepted',
      'confirmed',
      'arriving',
      'arrived',
      'in-trip',
      'over',
      'payment-over-due',
      'completed',
    ];
    if (!allowedStatuses.contains(status.apiValue)) {
      throw ArgumentError(
          'Invalid status "${status.apiValue}". Must be one of: ${allowedStatuses.join(", ")}');
    }
    try {
      print("|---------------------------------");
      final response = await dio.put(
        '${Api.apiurl}user-booking-update/${bookingId}',
        options: Options(
          headers: {"Authorization": "Bearer ${UserModel.token}"},
        ),
        data: {
          'booking_id': bookingId,
          'status': status.apiValue,
          'customer_id': UserModel.user.id,
        },
      );
      print(response);
      return '✅ Booking status updated successfully';
    } on DioException catch (e) {
      print('❌ Error updating booking status: ${e.response?.data ?? e.message}');
      return e.toString();
    }
  }
}

enum BookingStatus {
  open,
  accepted,
  confirmed,
  arriving,
  arrived,
  inTrip,
  over,
  paymentOverDue,
  completed,
  issueExists,
  canceled,
}
extension BookingStatusExtension on BookingStatus {
  String get apiValue {
    switch (this) {
      case BookingStatus.open:
        return 'open';
      case BookingStatus.accepted:
        return 'accepted';
      case BookingStatus.confirmed:
        return 'confirmed';
      case BookingStatus.arriving:
        return 'arriving';
      case BookingStatus.arrived:
        return 'arrived';
      case BookingStatus.inTrip:
        return 'in-trip';
      case BookingStatus.over:
        return 'over';
      case BookingStatus.paymentOverDue:
        return 'payment-over-due';
      case BookingStatus.completed:
        return 'completed';
      case BookingStatus.issueExists:
        return 'issue-exists';
      case BookingStatus.canceled:
        return 'canceled';
    }
  }
}
