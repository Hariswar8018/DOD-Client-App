import 'package:dio/dio.dart';

import '../api.dart' show Api;
import '../login/bloc/login/view.dart';
import '../model/price.dart';

class Price{

  static Future<void> gets() async {
    final Dio dio = Dio(
      BaseOptions(
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    try {
      final response = await dio.get(
        Api.apiurl + "price-management",
        options: Options(
          headers: {
            "Authorization": "Bearer ${UserModel.token}",
          },
        ),
      );
      print("pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp----------------------------->");
      if (response.statusCode == 200||response.statusCode == 201) {
        print(response.data);
        print(UserModel.token);
        final bookingsResponse = PriceResponse.fromJson(response.data);
        price = bookingsResponse.data!;
      } else {
        print("❌ Error: ${response.statusMessage}");
      }
    } catch (e) {
      print("Error during API call: $e");
    }
  }
  static late PriceModel price ;
}