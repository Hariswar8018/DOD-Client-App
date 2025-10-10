import 'package:dio/dio.dart';
import 'package:dod/model/ordermodel.dart';
import 'package:dod/second/pages/mybooking_full.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../api.dart';
import '../../login/bloc/login/view.dart';
import '../../model/booking_response.dart';

class MyBookings extends StatefulWidget {
  const MyBookings({super.key});

  @override
  State<MyBookings> createState() => _MyBookingsState();
}

class _MyBookingsState extends State<MyBookings> {

  void initState(){
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
        Api.apiurl + "user-bookings",
        options: Options(
          headers: {
            "Authorization": "Bearer ${UserModel.token}",
          },
        ),
      );

      if (response.statusCode == 200) {
        final bookingsResponse = BookingsResponse.fromJson(response.data);

        print("✅ Total bookings: ${bookingsResponse.bookings.length}");
        for (var order in bookingsResponse.bookings) {
          print("📦 Booking ID: ${order.id}, Status: ${order.status}, User: ${order.user.name}");
          orders.add(order);
        }
        setState(() {

        });
      } else {
        print("❌ Error: ${response.statusMessage}");
      }
    } catch (e) {
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
        title: Text("My Bookings",style: TextStyle(color: Colors.white),),
      ),
      body: orders.isNotEmpty?ListView.builder(
        itemCount: orders.length,
        itemBuilder: (BuildContext context, int index) {
          final OrderModel myorder = orders[index];
          return OrderCards(myorder: myorder);
        },
      ):ListView.builder(
        itemCount: 10,
        itemBuilder: (context,index){
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Shimmer.fromColors(
                child: Container(
                  width: w-20,
                  height: 150,
                  color: Colors.grey.shade200,
                ),
                baseColor: Colors.grey.shade200,
                highlightColor: Colors.white),
          );
        },
      ),
    );
  }
}

class OrderCards extends StatelessWidget {
  OrderModel myorder;
  OrderCards({super.key,required this.myorder});


  Future<void> full() async {
    final Dio dio = Dio(
      BaseOptions(
        validateStatus: (status) => status != null && status < 500,
      ),
    );
    final response = await dio.get(
      Api.apiurl + "user-bookings/${myorder.id}",
      options: Options(
        headers: {
          "Authorization": "Bearer ${UserModel.token}",
        },
      ),
    );
    print(response.statusMessage);
    print(response.data);
  }
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Center(
      child: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (_)=>MyBookingFull(order: myorder)));
        },
        onLongPress: full,
        child: Card(
          color: Colors.white,
          child: Container(
            width: w-20,
            height: 220,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0,top: 15),
                  child: Text("Order ID : #${myorder.createdAt} ",style: TextStyle(fontWeight: FontWeight.w800),),
                ),
                Row(
                  children: [
                    SizedBox(width: 15,),
                    Container(
                      width: 20,
                      height: 90,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.green,
                            radius: 6,
                          ),
                          SizedBox(width: 2,),
                          Container(
                            width: 2,
                            height: 25,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(5)
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 10,
                            child:Icon(Icons.location_on_sharp,color: Colors.red,size: 18,),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 15,),
                    Container(
                      width: w-15-20-20-20,
                      height: 90,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${myorder.pickupLocation} ",maxLines:1,style: TextStyle(fontWeight: FontWeight.w800),),
                          SizedBox(height: 8,),
                          Container(
                            width: w-15-20-20-20-15,
                            height: 2,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(15)
                            ),
                          ),
                          SizedBox(height: 8,),
                          Text("${myorder.dropLocation} ",maxLines:1,style: TextStyle(fontWeight: FontWeight.w800),),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0,top: 5),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_month,color: Colors.black,),
                      Text(" Sheduled for : ${formatDateTime(myorder.createdAt)}"
                        ,style: TextStyle(fontWeight: FontWeight.w500),),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0,top: 5,bottom: 15),
                  child: Row(
                    children: [
                      Icon(Icons.access_time_filled,color: Colors.grey,),
                      t("1 Hour"),
                      Icon(Icons.add_road_sharp,color: Colors.grey,),
                      t("${myorder.bookingType}"),
                      Icon(Icons.safety_check_outlined,color: Colors.grey,),
                      t("${myorder.status}"),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget t(String str)=>Text(" $str    ",style: TextStyle(fontWeight: FontWeight.w600,color: Colors.grey.shade500),);
  String formatDateTime(DateTime dateTime) {
    // Format: DD MonthName, HH:MM AM/PM
    final DateFormat formatter = DateFormat('dd MMMM, hh:mm a');
    return formatter.format(dateTime);
  }
}
