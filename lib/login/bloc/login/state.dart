import 'package:dod/login/bloc/login/view.dart';
import 'package:dod/model/usermodel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../api.dart';
import 'cubit.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final Dio dio = Dio(
    BaseOptions(
      validateStatus: (status) => status != null && status < 500,
    ),
  );

  Future<String> getfcm() async {
    try {
      final FirebaseMessaging _messaging = FirebaseMessaging.instance;

      await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      String token = await FirebaseMessaging.instance.getToken() ?? "NA";
      print("FCM Token: $token");
      return token;
    }catch(e){
      return "NA";
    }
  }

  Future<void> registerOrLogin() async {
    emit(AuthLoading());
    print("Success------------------------------------------->");
    SharedPreferences sg = await SharedPreferences.getInstance();
    String coupon = sg.getString('coupon')??'None';
    String token = await getfcm();
    try {
      final response = await dio.post(
        Api.apiurl + "register",
        data: {
          "provider": "mobile",
          "firebase_id": FirebaseAuth.instance.currentUser!.uid,
          "name": "No Name Provided",
          "email": "num${FirebaseAuth.instance.currentUser!.phoneNumber}@gmail.com",
          "password": "",
          "mobile": "${FirebaseAuth.instance.currentUser!.phoneNumber}",
          "platform_type": "android",
          "role": "customer",
          "referral_number": coupon,
          "fcm_token": token,
        },
      );
      print(response.data);
      print(response.statusCode);
      print(response.statusMessage);
      if (response.statusCode == 201) {

      } else if (response.statusCode == 422) {
        final loginResponse = await dio.post(
          Api.apiurl + "login",
          data: {
            "provider": "mobile",
            "firebase_id": FirebaseAuth.instance.currentUser!.uid,
            "mobile": "${FirebaseAuth.instance.currentUser!.phoneNumber}",
            "fcm_token": token,
          },
        );
        print(loginResponse.data);
        print(loginResponse.statusCode);
        print(loginResponse.statusMessage);
        print(loginResponse.data);
        final authResponse = AuthResponse.fromJson(loginResponse.data);

        UserModel.token=authResponse.token;
        emit(AuthSuccess(authResponse.data));
        print("Success");
      } else {
        emit(AuthFailure("Error: ${response.statusMessage}"));
      }
    } catch (e) {
      emit(AuthFailure("Exception: $e"));
    }
  }
}

class AuthResponse {
  final bool status;
  final String message;
  final UserData data;
  final String token;
  final String tokenType;

  AuthResponse({
    required this.status,
    required this.message,
    required this.data,
    required this.token,
    required this.tokenType,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: UserData.fromJson(json['data'] ?? {}),
      token: json['token'] ?? '',
      tokenType: json['token_type'] ?? '',
    );
  }
}
