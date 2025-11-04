import 'package:dod/model/ordermodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyBookingFull extends StatelessWidget {
  OrderModel order;
   MyBookingFull({super.key,required this.order});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:AppBar(
        backgroundColor: Color(0xff25252D),
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        title: Text("Booking ID #${order.id}",style: TextStyle(color: Colors.white),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                width: w-20,
                margin: EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                        color: Colors.grey.shade400
                    )
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      header("Car Type"),
                      ro("Trip Type","${capitalizeFirst(order.tripType)}"),
                      ro("Car Type","SUV"),
                      ro("Transmission","Manual"),
                      ro("DOD Secured Trip","No"),
                      ro("Hours to be used","${order.waitingHours} hr"),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: InkWell(
                onTap: () async {

                },
                child: Container(
                  width: w-20,
                  margin: EdgeInsets.only(top: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          color: Colors.grey.shade400
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        header("Instructions ( Optional )"),
                        desc("No Instruction given"),
                        SizedBox(height: 5,),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                width: w-20,
                margin: EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                        color: Colors.grey.shade400
                    )
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      header("Address"),
                      header1("Your Pickup Location"),
                      desc(order.pickupLocation),
                      SizedBox(height: 10,),
                      header1("Drop Location"),
                      desc(order.pickupLocation),
                      SizedBox(height: 10,),
                      header1("PickUp Time"),
                      desc(formatDateTime(order.bookingTime.toString())),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                width: w-20,
                margin: EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                        color: Colors.grey.shade400
                    )
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      header("Order Details"),
                      header1("Booked Time"),
                      desc(formatDateTime(order.createdAt.toString())),
                      SizedBox(height: 10,),
                      header1("Last Updated"),
                      desc(formatDateTime(order.updatedAt.toString())),
                      SizedBox(height: 10,),
                      header1("Driver Status"),
                      desc(order.status=="Booking"?"Finding Drivers":"Driver Sheduled"),
                    ],
                  ),
                ),
              ),
            ),

            Center(
              child: Container(
                width: w-20,
                margin: EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                        color: Colors.grey.shade400
                    )
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      header("Coupons"),
                      desc("You haven't chosen any Coupon for this Order")
                    ],
                  ),
                ),
              ),
            ),
            Center(
                child: Container(
                  width: w-20,
                  margin: EdgeInsets.only(top: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          color: Colors.grey.shade400
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        header("Fare Estimate"),
                        ro("Driver Cost","₹${(order.amount).toStringAsFixed(1)}"),
                        ro("Payment Method","${(order.paymentMethod)}"),
                      ],
                    ),
                  ),
                )
            ),
            SizedBox(height: 15,),
            Text("Cancellation Policy",style: TextStyle(color: Colors.red,fontWeight: FontWeight.w800,fontSize: 15),),
            SizedBox(height: 60,)
          ],
        ),
      ),
    );
  }

  int i = 0 ;
  Widget listtile(double w,int j, String str, String str2)=>InkWell(
    onTap: (){
    },
    child: Container(
      width: w-25,
      height: 60,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
              color: i==j?Colors.blue:Colors.grey.shade100
          )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CircleAvatar(
              backgroundColor: i==j?Colors.blue:Colors.grey,
              radius: 10,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(str,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 15),),
              Text(str2,style: TextStyle(fontSize: 11),),
            ],
          )
        ],
      ),
    ),
  );
  Widget header(String str)=>Padding(
    padding: const EdgeInsets.only(bottom: 7.0),
    child: Text(str,style: TextStyle(fontWeight: FontWeight.w900,fontSize: 20),),
  );
  Widget header1(String str)=>Padding(
    padding: const EdgeInsets.only(bottom: 1.0),
    child: Text(str,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15),),
  );
  Widget desc(String str)=>Padding(
    padding: const EdgeInsets.only(bottom: 7.0),
    child: Text(str,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 13,color: Colors.grey.shade700),),
  );
  Widget ro(String sr,String str2)=>Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(sr),
      Text(str2),
    ],);
  Widget ro1(String sr,String str2)=>Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(sr,style: TextStyle(fontSize: 19,fontWeight: FontWeight.w700),),
      Text(str2,style: TextStyle(fontSize: 19,fontWeight: FontWeight.w700),),
    ],);
  String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  String formatDateTime(String dateTime) {
    try {
      print("---------------------This $dateTime");
      DateTime utcTime = DateTime.parse(dateTime);

      // Convert to local time (e.g., IST)
      DateTime localTime = utcTime.toLocal();

      final DateFormat formatter = DateFormat('dd MMMM, hh:mm a');
      return formatter.format(localTime);
    } catch (e) {
      return "Error";
    }
  }

}
