import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingSuccess extends StatelessWidget {
  DateTime time; String address, tid;
   BookingSuccess({super.key,required this.time,required this.address,required this.tid});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/family-travel-by-car-baggage-600nw-2431573515.webp"
            ,width: w,),
          Text("🎉 Your Order is Placed with Us ! ",
            style: TextStyle(fontWeight: FontWeight.w900,fontSize: 19),),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10),
            child: Text(textAlign: TextAlign.center,"Thank you for Booking with Driver on Demand App. We are processing our Drivers to meet you as Sheduled on $time",
              style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16,color: Colors.grey.shade700),),
          ),
          SizedBox(height: 20,),
          Center(
            child: Container(
              width: w-20,
              margin: EdgeInsets.only(top: 1),
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
                    ro("Order Id ","#DOD${time.millisecondsSinceEpoch}"),
                    ro("Payment Id","UTETYWY8E98289W"),
                    Divider(),
                    ro("Pickup Time & Date",formatDateTime(time)),
                    ro("Pickup Location",""),
                    ro("Pickup Time & Date",""),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      persistentFooterButtons: [
        Container(
          width: w-10,
          height: 45,
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(6)
          ),
          child: Center(child: Text("Proceed",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),)),
        ),
      ],
    );
  }
  String formatDateTime(DateTime dateTime) {
    // Format: DD MonthName, HH:MM AM/PM
    final DateFormat formatter = DateFormat('dd MMMM, hh:mm a');
    return formatter.format(dateTime);
  }
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
}
