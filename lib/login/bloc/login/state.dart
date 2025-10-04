import 'package:dod/login/bloc/login/view.dart';
import 'package:dod/model/usermodel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../api.dart';
import 'cubit.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final Dio dio = Dio(
    BaseOptions(
      validateStatus: (status) => status != null && status < 500,
    ),
  );

  Future<void> registerOrLogin() async {
    emit(AuthLoading());
    print("Success------------------------------------------->");
    try {
      final response = await dio.post(
        Api.apiurl + "register",
        data: {
          "provider": "mobile",
          "firebase_id": FirebaseAuth.instance.currentUser!.uid,
          "name": "No Name Provided",
          "email":
          "num${FirebaseAuth.instance.currentUser!.phoneNumber}@gmail.com",
          "password": "",
          "mobile": "${FirebaseAuth.instance.currentUser!.phoneNumber}",
          "platform_type": "android",
          "role": "customer",
          "referral_number": "NAN",
          "fcm_token": "gyhjhj",
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
            "fcm_token": "gyhjhj",
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
