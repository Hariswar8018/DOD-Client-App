import 'package:dio/dio.dart';
import 'package:dod/model/ordermodel.dart';
import 'package:dod/second/pages/about_driver.dart';
import 'package:dod/second/pages/track.dart';
import 'package:flutter/material.dart';

import '../../api.dart';
import '../../login/bloc/login/view.dart';
import '../../main/second/gethelp.dart' show GetHelp;
import 'mybooking_full.dart';

class Myorder extends StatelessWidget {
  OrderModel order;
   Myorder({super.key,required this.order});
  Future<void> as() async {
    final Dio dio = Dio(
      BaseOptions(
        validateStatus: (status) => status != null && status < 500,
      ),
    );
    try {
      print(UserModel.token);
      final response = await dio.put(
        Api.apiurl + "user-booking-payment-status/",
        options: Options(
          headers: {
            "Authorization": "Bearer ${UserModel.token}",
          },
        ),
      );
      print("Status: ${response.statusCode}");
      print("Response: ${response.data}");
      print(response.statusMessage);
    } catch (e) {
      print("Error during API call: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        centerTitle: true,
        title: Text("Order Issue / Info",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
      ),
      body: Column(
        children: [
          order.driver==null?SizedBox():InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>MyDriver(driver: order.driver!, order: order,)));
              },
              child: lis(Icon(Icons.drive_eta,color: Colors.black,), "My Driver", "Get in touch with your Driver")),
          InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>MyBookingFull(order: order,back: true,)));
              },
              child: lis(Icon(Icons.indeterminate_check_box,color: Colors.orange,), "My Order", "Info about your Product")),
          InkWell(
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (_)=>Track(order:order,)));
              },
              child: lis(Icon(Icons.my_location_outlined,color: Colors.brown,), "Track Driver", "Track Driver of their Location")),
          InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>GetHelp()));
              },
              child: lis(Icon(Icons.support_agent,color: Colors.blue,), "Support Team", "Raise Ticket or Reach Customer Care")),
          InkWell(
              onTap: (){
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Cancel your Order ?"),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      content: const Text("Please reach out to Customer Care to Cancel your Order"),
                      actions: [
                        TextButton(
                          child: const Text("Cancel"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text("Yes"),
                          onPressed: () async {
                            Navigator.push(context, MaterialPageRoute(builder: (_)=>GetHelp()));
                               },
                        ),
                      ],
                    );
                  },
                );
              },
              child: lis(Icon(Icons.cancel_presentation,color: Colors.red,), "Cancellation", "Cancel & Terminate your Sheduled Ride")),

        ],
      ),
    );
  }
  Widget lis(Widget c, String str,String str2)=>ListTile(
    leading: c,
    title: Text(str),
    subtitle: Text(str2),
    trailing: Icon(Icons.arrow_forward),
  );
}
