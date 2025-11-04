import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api.dart';
import '../../login/bloc/login/view.dart';
import '../../model/booking_response.dart';
import '../../model/ordermodel.dart';

class MyPayments extends StatefulWidget {
  const MyPayments({super.key});

  @override
  State<MyPayments> createState() => _MyPaymentsState();
}

class _MyPaymentsState extends State<MyPayments> {


  void initState(){
    print("kjfdv mjnfovo");
    gets();
  }

  Future<void> gets() async {
    final Dio dio = Dio(
      BaseOptions(
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    try {
      final response = await dio.get(
        Api.apiurl + "user-payments",
        options: Options(
          headers: {
            "Authorization": "Bearer ${UserModel.token}",
          },
        ),
      );

      if (response.statusCode == 200) {
        print("Got Response ----------------------------->");
        print(response.data);

        print(UserModel.token);
        print(response.data);
        setState(() {

        });
      } else {
        print("❌ Error: ${response.statusMessage}");
        print(response.data);
      }
    } catch (e) {
      print("Error during API call: $e");
    }
  }

  List<OrderModel> orders = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
        gets();
      }),
      appBar:AppBar(
        backgroundColor: Color(0xff25252D),
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        title: Text("My Transactions",style: TextStyle(color: Colors.white),),
      ),
    );
  }
}
