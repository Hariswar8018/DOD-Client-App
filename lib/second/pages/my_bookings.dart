import 'package:dio/dio.dart';
import 'package:dod/global.dart';
import 'package:dod/model/ordermodel.dart';
import 'package:dod/second/booking/book_api.dart';
import 'package:dod/second/pages/mybooking_full.dart';
import 'package:dod/second/pages/order.dart';
import 'package:dod/second/pages/track.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
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
        print(response.data);
        print("----------------------------->");
        print(UserModel.token);
        final bookingsResponse = BookingsResponse.fromJson(response.data);
        print("✅ Total bookings: ${bookingsResponse.bookings.length}");
        orders=[];
        for (var order in bookingsResponse.bookings) {
          print("📦 Booking ID: ${order.id}, Status: ${order.status}, User: ${order.user.name}");
          print("oooooooooooooooooooooooooooooooooooooooooooooooooooo");
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
          return OrderCards(myorder: myorder,onUpdate: (){
            gets();
          },);
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

class OrderCards extends StatefulWidget {
  OrderModel myorder;
  final VoidCallback? onUpdate;

  OrderCards({super.key,required this.myorder, this.onUpdate,
});

  @override
  State<OrderCards> createState() => _OrderCardsState();
}

class _OrderCardsState extends State<OrderCards> {
  Future<void> oop(BookingStatus status,BuildContext context) async {
    final s = await BookingFunction.updateBookingStatus(bookingId: widget.myorder.id.toString(),
        status: status
    );
    Send.message(context, "$s", true);
    widget.onUpdate!();
  }

  void yeshow(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Kindly Contact Driver or Customer Care"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          content: const Text("Please reach out to Driver or contact Customer Care"),
          actions: [
            TextButton(
              child: const Text("Driver Location"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(context,MaterialPageRoute(builder: (_)=>Track(order: widget.myorder,)));

              },
            ),
            TextButton(
              child: const Text("Issue"),
              onPressed: () async {
                Navigator.of(context).pop();
                Navigator.push(context, MaterialPageRoute(builder: (_)=>Myorder(order: widget.myorder,)));
              },
            ),
          ],
        );
      },
    );
  }

  void showerror(BuildContext context,String str, String str2){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text(str),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          content: Text(str2),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Razorpay _razorpay = Razorpay();
  void initState(){
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    oop(BookingStatus.over, context);
    payments(response.orderId!, response.paymentId, response.signature);
  }
  Future<void> payments(String orderid,paymentid,sign) async {
    try {
      final Dio dio = Dio(
        BaseOptions(
          validateStatus: (status) => status != null && status < 500,
        ),
      );
      print(UserModel.token);
      final response = await dio.put(
        Api.apiurl + "user-booking-payment-status/$paymentid",
        data: {
          "amount":"${widget.myorder.amount}",
          "paymentmethod":"online",
          "razorpay_order_id":orderid,
          "razorpay_payment_id":paymentid,
          "razorpay_signature":sign,
          "status":"Success",
        },
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

  void _handlePaymentError(PaymentFailureResponse response) {
    showerror(context, response.message??"Error", response.error.toString());
  }


  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Center(
      child: InkWell(
        onTap: () async {
          if(widget.myorder.status=="payment-over-due"){
            var options = {
              'key': 'rzp_live_ROEbzdCOAGyyGu',
              'amount': (widget.myorder.amount*100),
              'name': '#000${widget.myorder.id} Trip Order for ${widget.myorder.waitingHours} hr',
              'description': '',
              'prefill': {
                'contact': '${UserModel.user.mobile}',
                'email': '${UserModel.user.email}'

              }
            };
            _razorpay.open(options);

            return ;
          }
          if(widget.myorder.status=="arriving"){
            Navigator.push(context,MaterialPageRoute(builder: (_)=>Track(order: widget.myorder,)));
            return ;
          }
          if(widget.myorder.status=="arrived"){
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Do the Driver Arrived?"),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero, // makes it rectangular
                  ),
                  content: const Text("Do the Driver Arrived at current Location. Kindly Confirm"),
                  actions: [
                    TextButton(
                      child: const Text("NO"),
                      onPressed: () {
                        Navigator.of(context).pop();
                        yeshow(context);
                      },
                    ),
                    TextButton(
                      child: const Text("YES"),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        oop(BookingStatus.inTrip, context);
                      },
                    ),
                  ],
                );
              },
            );
            return ;
          }
          Navigator.push(context, MaterialPageRoute(builder: (_)=>MyBookingFull(order: widget.myorder)));
        },
        onLongPress: (){
          Navigator.push(context, MaterialPageRoute(builder: (_)=>Myorder(order: widget.myorder,)));
        },
        onDoubleTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (_)=>Myorder(order: widget.myorder,)));
        },
        child: widget.myorder.bookingType=="monthly"||widget.myorder.bookingType=="weekly"?
        daily_driver(w):Card(
          color: Colors.white,
          child: Container(
            width: w-20,
            height: 220,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0,top: 15,right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Order ID : #DOD000000${widget.myorder.id} ",style: TextStyle(fontWeight: FontWeight.w800),),
                      isAfter()?Column(
                        children: [
                          Text("Still Finding Drivers",style: TextStyle(fontSize: 9,color: Colors.grey),),
                          SizedBox(height: 2,),
                          Container(
                            width: w/5+10,
                            height: 3,
                            child: LinearProgressIndicator(),
                          )
                        ],
                      ):InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (_)=>Myorder(order: widget.myorder,)));

                          },
                          child: Icon(Icons.more_vert_outlined)),
                    ],
                  ),
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
                          Text("${widget.myorder.pickupLocation} ",maxLines:1,style: TextStyle(fontWeight: FontWeight.w800),),
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
                          Text("${widget.myorder.dropLocation} ",maxLines:1,style: TextStyle(fontWeight: FontWeight.w800),),
                        ],
                      ),
                    ),
                  ],
                ),
                open()?SizedBox():Padding(
                  padding: const EdgeInsets.only(left: 15.0,top: 5),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_month,color: Colors.black,),
                      Text(" ${widget.myorder.status!="over"?"Sheduled for":"Trip done at"} : ${formatDateTime(widget.myorder.bookingTime.toString())}"
                        ,style: TextStyle(fontWeight: FontWeight.w500),),
                    ],
                  ),
                ),
                sh(w),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget daily_driver(double w){
    print("ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo");
    print(widget.myorder.toString());
    return Card(
      color: Colors.white,
      child: Container(
        width: w-20,
        height: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0,top: 15,right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Daily Driver ID : #DOD000000${widget.myorder.id} ",style: TextStyle(fontWeight: FontWeight.w800),),
                  isAfter()?Column(
                    children: [
                      Text("Still Finding Drivers",style: TextStyle(fontSize: 9,color: Colors.grey),),
                      SizedBox(height: 2,),
                      Container(
                        width: w/5+10,
                        height: 3,
                        child: LinearProgressIndicator(),
                      )
                    ],
                  ):InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>Myorder(order: widget.myorder,)));

                      },
                      child: Icon(Icons.more_vert_outlined)),
                ],
              ),
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
                      Text("${widget.myorder.pickupLocation} ",maxLines:1,style: TextStyle(fontWeight: FontWeight.w800),),
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
                      Text("${widget.myorder.dropLocation} ",maxLines:1,style: TextStyle(fontWeight: FontWeight.w800),),
                    ],
                  ),
                ),
              ],
            ),
            open()?SizedBox():Padding(
              padding: const EdgeInsets.only(left: 15.0,top: 5),
              child: Row(
                children: [
                  Icon(Icons.calendar_month,color: Colors.black,),
                  Text(" ${widget.myorder.status!="over"?"Sheduled for":"Trip done at"} : ${formatDateTime(widget.myorder.bookingTime.toString())}"
                    ,style: TextStyle(fontWeight: FontWeight.w500),),
                ],
              ),
            ),
            sh(w),
          ],
        ),
      ),
    );
  }

  bool open(){
    return widget.myorder.status=="arriving"||widget.myorder.status=="arrived"||
        widget.myorder.status=="in-trip"
    ||widget.myorder.status=="payment-over-due";
  }

  Widget sh(double w){
    print("--------------------------------------------->");
    print(widget.myorder.status);
    if(widget.myorder.status=="over"){
      return info();
    }
    if(widget.myorder.status=="arriving"){
      return track(w);
    }
    if(widget.myorder.status=="arrived"){
      return confirm(w);
    }
    if(widget.myorder.status=="in-trip"){
      return intrip(w);
    }
    if(widget.myorder.status=="payment-over-due"){
      return pay(w);
    }
    if(widget.myorder.driverId!=null){
      return info();
    }
    if(widget.myorder.status=="open"){
      return info();
    }
    return info();
  }

  Widget info(){
    return Padding(
      padding: const EdgeInsets.only(left: 15.0,top: 5,bottom: 15),
      child: Row(
        children: [
          Icon(Icons.access_time_filled,color: Colors.grey,),
          t("${widget.myorder.waitingHours} Hour"),
          Icon(Icons.add_road_sharp,color: Colors.grey,),
          t("${capitalizeFirst(widget.myorder.bookingType)}"),
          Icon(Icons.safety_check_outlined,color: Colors.blue,),
          t1("${up(widget.myorder.status)}"),
        ],
      ),
    );
  }

  Widget pay(double w){
    return Padding(
      padding: const EdgeInsets.only(left: 15.0,top: 10,bottom: 10),
      child: Container(
        width: w-50,
        height: 55,
        decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(5)
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset("assets/pay.png",height: 30,),
            ),
            SizedBox(width: 8,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Payment Overdue"
                  ,style: TextStyle(fontWeight: FontWeight.w900,color: Colors.black),),
                Text("Either Pay the Money by Cash or Online"
                  ,style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 9),),

              ],
            ),
            Spacer(),
            Image.asset("assets/razoarpay.webp",height: 20,),
            Text("  Pay      "
              ,style: TextStyle(fontWeight: FontWeight.w600,color: Colors.black),),
          ],
        ),
      ),
    );
  }

  Widget intrip(double w){
    return Padding(
      padding: const EdgeInsets.only(left: 15.0,top: 10,bottom: 10),
      child: Container(
        width: w-50,
        height: 55,
        decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(5)
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset("assets/car2.gif",height: 30,),
            ),
            SizedBox(width: 8,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Enjoy your sheduled Trip"
                  ,style: TextStyle(fontWeight: FontWeight.w900,color: Colors.black),),
                Text("You and Driver are in Trip according to Shedule"
                  ,style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 9),),

              ],
            ),
            Spacer(),
            Text("  🎉      "
              ,style: TextStyle(fontWeight: FontWeight.w600,color: Colors.black),),

          ],
        ),
      ),
    );
  }

  Widget shedule(double w){
    return Padding(
      padding: const EdgeInsets.only(left: 15.0,top: 10,bottom: 10),
      child: Row(
        children: [
          Icon(Icons.access_alarm,color: Colors.green,),
          Text("  Driver Scheduled "
            ,style: TextStyle(fontWeight: FontWeight.w900,color: Colors.green),),
          SizedBox(width: 10,),
          Icon(Icons.album,color: Colors.blue,),
          Text("  Status : ${capitalizeFirst(widget.myorder.status)}"
            ,style: TextStyle(fontWeight: FontWeight.w900,color: Colors.blue),),
        ],
      ),
    );
  }

  Widget confirm(double w){
    return Padding(
      padding: const EdgeInsets.only(left: 15.0,top: 10,bottom: 10),
      child: Container(
        width: w-50,
        height: 55,
        decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(5)
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset("assets/location.gif",height: 30,),
            ),
            SizedBox(width: 8,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Driver in Sheduled Location "
                  ,style: TextStyle(fontWeight: FontWeight.w900,color: Colors.black),),
                Text("Kindly Confirm the Driver at your Location"
                  ,style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 9),),

              ],
            ),
            Spacer(),
            Container(
              width: 70,
              height: 30,
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Center(child: Text("Yes / No",style: TextStyle(fontSize:10,color: Colors.white,fontWeight: FontWeight.w800),)),
            ),
            SizedBox(width: 8,)
          ],
        ),
      ),
    );
  }

  Widget confirm2(double w){
    return Padding(
      padding: const EdgeInsets.only(left: 15.0,top: 10,bottom: 10),
      child: Container(
        width: w-50,
        height: 55,
        decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(5)
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset("assets/location.gif",height: 30,),
            ),
            SizedBox(width: 8,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Trip Completed "
                  ,style: TextStyle(fontWeight: FontWeight.w900,color: Colors.black),),
                Text("Kindly Confirm the is the Trip Completed"
                  ,style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 9),),
              ],
            ),
            Spacer(),
            Container(
              width: 70,
              height: 30,
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Center(child: Text("Yes / No",style: TextStyle(fontSize:10,color: Colors.white,fontWeight: FontWeight.w800),)),
            ),
            SizedBox(width: 8,)
          ],
        ),
      ),
    );
  }

  Widget track(double w){
    return Padding(
      padding: const EdgeInsets.only(left: 15.0,top: 10,bottom: 10),
      child: Container(
        width: w-50,
        height: 55,
        decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(5)
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset("assets/car2.gif",height: 30,),
            ),
            SizedBox(width: 8,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Arriving to Location "
                  ,style: TextStyle(fontWeight: FontWeight.w900,color: Colors.black),),
                Text("Driver on the Way "
                  ,style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 9),),

              ],
            ),
            Spacer(),
            Image.asset("assets/go.png",height: 20,),
            Text("  Track >      "
              ,style: TextStyle(fontWeight: FontWeight.w600,color: Colors.black),),

          ],
        ),
      ),
    );
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  bool isAfter() {
    return widget.myorder.driver==null;
    }

  String up(String str){
    return str.substring(0,1).toUpperCase()+str.substring(1);
  }

  Widget t1(String str)=>Text(" $str    ",style: TextStyle(fontWeight: FontWeight.w900,color: Colors.blue),);

  Widget t(String str)=>Text(" $str    ",style: TextStyle(fontWeight: FontWeight.w600,color: Colors.grey.shade500),);

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

  DateTime formatDate(String dateTime) {
    try {
      print("---------------------This $dateTime");
      DateTime utcTime = DateTime.parse(dateTime);

      // Convert to local time (e.g., IST)
      return utcTime.toLocal();

    } catch (e) {
      return DateTime.now();
    }
  }

  String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
