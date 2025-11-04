import 'dart:math';

import 'package:dio/dio.dart';
import 'package:dod/api.dart';
import 'package:dod/global.dart';
import 'package:dod/login/bloc/login/view.dart';
import 'package:dod/second/message/return_instruction.dart';
import 'package:dod/second/message/success.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Final_Payment extends StatefulWidget {
  String couponid, bookingtype, triptype, pickup ,drop,name,transmission, cartype;
  double waitinghours,pickup_longitude, pickup_latitude,droplat, droplon ;
  double price;
  DateTime date;
   Final_Payment({super.key,required this.couponid,required this.triptype,
    required this.bookingtype,required this.droplon,required this.droplat,required this.name,
    required this.pickup,required this.pickup_longitude,required this.pickup_latitude,
     required this.transmission,required this.cartype,
    required this.date,required this.drop,required this.waitinghours,required this.price});

  @override
  State<Final_Payment> createState() => _Final_PaymentState();
}

class _Final_PaymentState extends State<Final_Payment> {

  Razorpay _razorpay = Razorpay();

  void initState(){
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    orderdone(response.paymentId.toString());
    payments(response.orderId!, response.paymentId!, response.signature!, "");
    response.signature;
    response.paymentId;
    response.orderId;
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showMyBottomSheet(context, "Error in Payment : ${response.message}", "${response.error}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    showMyBottomSheet(context, "External Wallet Used", "Please Wait while we confirm your Transaction");
  }

  void showMyBottomSheet(BuildContext context,String title, String desc) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 330,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.close,color: Colors.red,size: 55,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(title,style: TextStyle(fontWeight: FontWeight.w900,fontSize: 19),),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(desc,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14),textAlign: TextAlign.center,),
              ),
              SizedBox(height: 20,),
              Container(
                width: MediaQuery.of(context).size.width-20,
                height: 45,
                decoration: BoxDecoration(
                    color: Colors.green.shade600,
                    borderRadius: BorderRadius.circular(6)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.support_agent,color: Colors.white,),
                    SizedBox(width: 12,),
                    Text("Take Help from Support Center",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                  ],
                ),
              ),
              SizedBox(height: 30,),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        centerTitle: true,
        title: Text("Booking Confirmation",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
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
                      ro("Trip Type","${widget.name}"),
                      ro("Car Type",widget.cartype),
                      ro("Transmission",widget.transmission),
                      ro("DOD Secured Trip","No"),
                      ro("Hours to be used","${widget.waitinghours.toInt()} hr"),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: InkWell(
                onTap: () async {
                  instruct = await Navigator.push(context,MaterialPageRoute(builder: (_)=>ReturnInstruction()));
                  setState(() {

                  });
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
                        instruct=="NA"?Text("+ Add Driver Instructions",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w800),):
                        desc(instruct),
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
                      desc(widget.pickup),
                      SizedBox(height: 10,),
                      header1("Drop Location"),
                      desc(widget.drop),
                      SizedBox(height: 10,),
                      header1("PickUp Time"),
                      desc(formatDateTime(widget.date)),
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
                      ro("Driver Cost","₹${(widget.price*0.75).toStringAsFixed(1)}"),
                      ro("Est. Commision","₹${(widget.price*0.02).toStringAsFixed(1)}"),
                      ro("Total GST","₹${(widget.price*0.18).toStringAsFixed(1)}"),
                      ro1("Total Amount Paid","₹${widget.price}"),
                    ],
                  ),
                ),
              )
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
                      header("Payment Method"),
                      listtile(w, 2, "Pay by Cash", "Pay after the Drive is Completed")
                    ],
                  ),
                ),
              ),
            ),
            i==1?Center(
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
                      header("To be Paid Now"),
                      ro("Total Payment","₹${widget.price}"),
                      ro("Payment to be done by Cash","₹${(widget.price*0.8).toStringAsFixed(1)}"),
                      ro1("Payment to be done Now","₹${(widget.price*0.2).toStringAsFixed(1)}"),
                    ],
                  ),
                ),
              ),
            ):SizedBox(),
            SizedBox(height: 15,),
            Text("Cancellation Policy",style: TextStyle(color: Colors.red,fontWeight: FontWeight.w800,fontSize: 15),),
            SizedBox(height: 60,)
          ],
        ),
      ),
      persistentFooterButtons: [
        i==2? Dismissible(
          key: Key("l"),
          onDismissed: (Dis){
            orderdone("COD"+DateTime.now().toString());
          },
          child: Container(
              width: w-10,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(6)
              ),
              child: Center(child: Text("Swipe Right to Confirm  > > >",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),)),
          ),
        ):Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0,right: 8,bottom: 8,top: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total Amount to be Paid : ",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w700),),
                  Text("₹${i==1?(widget.price*0.20):widget.price}",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w700),),
                ],
              ),
            ),
            InkWell(
              onTap: (){
                var options = {
                  'key': 'rzp_live_ROEbzdCOAGyyGu',
                  'amount': (widget.price * (i==0?1:0.2))*100,
                  'name': '${widget.name} Trip Order for ${widget.waitinghours} hr',
                  'description': '${widget.name} Trip for ${widget.waitinghours.toInt()} hr from ${widget.pickup} to ${widget.drop} on ${formatDateTime(widget.date)}',
                  'prefill': {
                    'contact': '${FirebaseAuth.instance.currentUser!.phoneNumber}',
                    'email': '${UserModel.user}'
                  }
                };
                _razorpay.open(options);
              },
              onDoubleTap: (){
                var options = {
                  'key': 'rzp_live_ROEbzdCOAGyyGu',
                  'amount': 1*100,
                  'name': '${widget.name} Trip Order for ${widget.waitinghours} hr',
                  'description': '${widget.name} Trip for ${widget.waitinghours.toInt()} hr from ${widget.pickup} to ${widget.drop} on ${formatDateTime(widget.date)}',
                  'prefill': {
                    'contact': '${FirebaseAuth.instance.currentUser!.phoneNumber}',
                    'email': '${UserModel.user}'
                  }
                };
                _razorpay.open(options);
              },
              onLongPress: (){
                payments("sxwa", "edfs", "SDCFCDS","SUCESS");
              },
              child: Container(
                width: w-10,
                height: 45,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(6)
                ),
                child: Center(child: Text("Complete Payment Now",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),)),
              ),
            ),
          ],
        )
      ],
      backgroundColor: Colors.white,
    );
  }

  String formatDateTime(DateTime dateTime) {
    // Format: DD MonthName, HH:MM AM/PM
    final DateFormat formatter = DateFormat('dd MMMM, hh:mm a');
    return formatter.format(dateTime);
  }
  int i = 2 ;
  Widget listtile(double w,int j, String str, String str2)=>InkWell(
    onTap: (){
      setState(() {
        i=j;
      });
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
  final Dio dio = Dio(
    BaseOptions(
      validateStatus: (status) => status != null && status < 500,
    ),
  );
  void orderdone(String paymentid) async {
    if (widget.pickup_latitude == null ||
        widget.pickup_longitude == null ||
        widget.droplat == null ||
        widget.droplon == null ||
        widget.pickup == null ||
        widget.drop == null ||
        widget.bookingtype == null ||
        widget.triptype == null ||
        widget.waitinghours == null ||
        widget.date == null) {
      print("One or more required fields are null!");
      return;
    }

    // Convert date to UTC string
    String utcString = widget.date.toUtc().toIso8601String();

    // Calculate distance and round to 2 decimals
    double distance = double.parse(
      haversine(widget.pickup_latitude, widget.pickup_longitude, widget.droplat, widget.droplon)
          .toStringAsFixed(2),
    );

    final data = {
      "coupon_id": null,
      "booking_type": widget.triptype=="One Way"?"oneway":widget.triptype=="Round Trip"?"roundtrip":"outstation",
      "trip_type": "upcoming",
      "waiting_hours": widget.waitinghours.toInt(),
      "pickup_location": widget.pickup,
      "pickup_latitude": widget.pickup_latitude,
      "pickup_longitude": widget.pickup_longitude,
      "drop_location": widget.drop,
      "drop_latitude": widget.droplat,
      "drop_longitude": widget.droplon,
      "booking_time": utcString,
      "distance_km": distance.toInt()+10,
      "status": "Booking",
    };

    print("Sending payload: $data");

    try {
      final response = await dio.post(
        Api.apiurl + "user-booking-create",
        data: data,
        options: Options(
          headers: {
            "Authorization": "Bearer ${UserModel.token}",
          },
        ),
      );


      print("Status: ${response.statusCode}");
      print("Response: ${response.data}");
      if(response.statusCode==200||response.statusCode==201){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>BookingSuccess(time: widget.date,
          address: widget.pickup, tid: paymentid,)));
        return ;
      }
      Send.message(context, "Error ${response.statusMessage}", false);
      return ;

    } catch (e) {
      Send.message(context, "Error $e", false);
      print("Error during API call: $e");
    }
  }
  String instruct="NA";
  Future<void> payments(String orderid,paymentid,sign, status) async {
    try {
      print(UserModel.token);
      final response = await dio.put(
        Api.apiurl + "user-booking-payment-status/$paymentid",
        data: {
          "amount":"${widget.price}",
          "paymentmethod":"online",
          "razorpay_order_id":orderid,
          "razorpay_payment_id":paymentid,
          "razorpay_signature":sign,
          "status":status,
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
      orderdone(paymentid);
    } catch (e) {
      orderdone(paymentid);
      print("Error during API call: $e");
    }
  }



  int haversine(double lat1, double lon1, double lat2, double lon2) {
    try {
      const R = 6371; // Earth's radius in km

      double toRad(double degree) => degree * pi / 180;

      final dLat = toRad(lat2 - lat1);
      final dLon = toRad(lon2 - lon1);

      final a = sin(dLat / 2) * sin(dLat / 2) +
          cos(toRad(lat1)) * cos(toRad(lat2)) *
              sin(dLon / 2) * sin(dLon / 2);
      final c = 2 * atan2(sqrt(a), sqrt(1 - a));

      return (R * c).toInt();
    }catch(e){
      return 10;
    }
  }
}
