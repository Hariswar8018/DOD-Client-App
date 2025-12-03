import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api.dart';
import '../../global/global_list.dart';
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
  void on(bool iss){
    setState(() {
      progress = iss;
    });
  }

  Future<void> gets() async {
    final Dio dio = Dio(
      BaseOptions(
        validateStatus: (status) => status != null && status < 500,
      ),
    );
    on(true);
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

        });on(false);
      } else {
        print("❌ Error: ${response.statusMessage}");
        print(response.data);on(false);
      }
    } catch (e) {
      on(false);
      print("Error during API call: $e");
    }
  }

  List<OrderModel> orders = [];
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Color(0xff25252D),
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        title: Text("My Transactions",style: TextStyle(color: Colors.white),),
      ),
      body: Column(
        children: [
          progress
              ?  GlobalShimmer.shimmer(w)
              : orders.isEmpty
              ? GlobalShimmer.empty(context,"Transactions")
              :SizedBox()
        ],
      ),
    );
  }
  bool progress = false;
}
