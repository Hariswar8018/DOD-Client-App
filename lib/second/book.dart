import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_widget/google_maps_widget.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../api.dart';
import '../global.dart';
import '../other/say_no.dart' show Say_No;

class Book_OneWay extends StatefulWidget {
  String str,str2;
  DateTime dateTime;
  double lat1,lat2, lon1,lon2;
   Book_OneWay({super.key,
     required this.dateTime,required this.str,required this.str2,required this.lat1,
     required this.lat2,required this.lon1,required this.lon2});

  @override
  State<Book_OneWay> createState() => _Book_OneWayState();
}

class _Book_OneWayState extends State<Book_OneWay> {
  final mapsWidgetController = GlobalKey<GoogleMapsWidgetState>();

  bool now = false;
  void initState(){
    given=widget.dateTime;
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {

  }

  void _handlePaymentError(PaymentFailureResponse response) {

    print(response);
    Send.message(context, response.toString(), false);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {

    print(response);
    Send.message(context, response.toString(), false);
  }



  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        centerTitle: true,
        title: Text("Book One Way",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
      ),
      body: Stack(
        children: [
          Container(
            width: w,
            height: 600,
            child: Column(
              children: [
                Container(
                  width: w,
                  height: 500,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        width: w,
                        height: 300,
                        child: GoogleMapsWidget(
                          apiKey: Api.googlemap,
                          key: mapsWidgetController,
                          sourceLatLng: LatLng(
                            widget.lat2,
                            widget.lon2,
                          ),
                          destinationLatLng: LatLng(
                            widget.lat1,
                            widget.lon1,
                          ),
                          updatePolylinesOnDriverLocUpdate: true,
                          onPolylineUpdate: (_) {
                            print("Polyline updated");
                          },
                          // mock stream
                          totalTimeCallback: (time) => print(time),
                          totalDistanceCallback: (distance) => print(distance),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: w,
            height: h,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: w,
                    height: 290,
                    color: Colors.transparent,
                  ),
                  Container(
                    width: w,
                    height: 700,
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10,),
                        Center(
                          child: Container(
                            width: w-20,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4), // Rounded corners
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1), // Shadow color
                                  spreadRadius: 1, // How much the shadow spreads
                                  blurRadius: 6, // Softness of the shadow
                                  offset: Offset(0, 3), // Shadow position (x, y)
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: 15,),
                                Icon(Icons.import_export,color: Colors.green,),
                                SizedBox(width: 10,),
                                Text(widget.str2.length>27?widget.str2.substring(0,26)+"...":widget.str2,),
                                Spacer(),
                                InkWell(
                                  onTap: (){
                                    _showCustomDialog(context);
                                  },
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(4)
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 14.0,vertical: 4),
                                      child: Row(
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text("${formatDate(given)}",style: TextStyle(fontSize: 11),),
                                              Text("${formatTime(given)}",style: TextStyle(fontSize: 11),),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 7.0),
                                            child: Icon(Icons.keyboard_arrow_down,color: Colors.black,),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8,)
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Text("   Car for Today",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 17),),
                        SizedBox(height: 5),
                        InkWell(
                          onTap: (){
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 10,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Text(
                                            "Select Transmission & Car Types",
                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Divider(),
                                        Text(
                                          "Transmission",
                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                                        ),
                                        SizedBox(height: 4,),
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap:(){
                                                setState(() {
                                                  trasmission="Manual";
                                                });
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                decoration:BoxDecoration(
                                                    color:trasmission=="Manual"?Colors.white:Colors.blue.shade50,
                                                  borderRadius: BorderRadius.circular(10)
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 14.0,vertical: 5),
                                                  child: Center(child: Text("Manual")),
                                                ),
                                              ),
                                            ),SizedBox(width: 9,),
                                            InkWell(
                                              onTap:(){
                                                setState(() {
                                                  trasmission="Automatic";
                                                });
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                decoration:BoxDecoration(
                                                    color:trasmission=="Automatic"?Colors.white:Colors.blue.shade50,
                                                    borderRadius: BorderRadius.circular(10)
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 14.0,vertical: 5),
                                                  child: Center(child: Text("Automatic")),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        Text(
                                          "Car Type",
                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                                        ),
                                        SizedBox(height: 4,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            con("Hatchbacks", w),
                                            con("Sedan", w),
                                            con("SUV", w),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Row(
                            children: [
                              SizedBox(width: 15,),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 0.8
                                  ),
                                  borderRadius: BorderRadius.circular(5)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 5),
                                  child: Row(
                                    children: [
                                      Icon(Icons.car_crash,color: Colors.green,),
                                      SizedBox(width: 9),
                                      Text(type,style: TextStyle(fontWeight: FontWeight.w700),),
                                      SizedBox(width: 7,),
                                      Icon(Icons.keyboard_arrow_down_rounded,),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 8,),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade300,
                                        width: 0.8
                                    ),
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 5),
                                  child: Row(
                                    children: [
                                      Icon(Icons.auto_awesome_mosaic,color: Colors.green,),
                                      SizedBox(width: 9),
                                      Text(trasmission,style: TextStyle(fontWeight: FontWeight.w700),),
                                      SizedBox(width: 7,),
                                      Icon(Icons.keyboard_arrow_down_rounded,),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20,),
                        Text("   Estimated Usage",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 17),),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            SizedBox(width: 10,),
                            r(w, 1),r(w, 2),r(w, 3),
                            r(w, 4),r(w, 5),r(w, 6),
                          ],
                        ),
                        SizedBox(height: 15,),
                        Row(
                          children: [
                            Text("   Trip is DOD Secured ",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 17),),
                            Spacer(),
                            Switch(
                              value: isSwitched,
                              onChanged: (value) {
                                setState(() {
                                  isSwitched = value;
                                  if(isSwitched){

                                      price=price+40;
                                  }else{
                                    price=price-40;
                                  }
                                });
                              },
                              activeColor: Colors.green.shade200,
                              inactiveThumbColor: Colors.grey,
                              inactiveTrackColor: Colors.grey[300],
                            ),
                            SizedBox(width: 10,)
                          ],
                        ),
                        SizedBox(height: 18),
                        Center(
                          child: Container(
                            width: w-30,
                            height: 2,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10)
                            ),
                          ),
                        ),
                        SizedBox(height: 22),
                        Text("   Choose Driver Type",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 17),),
                        SizedBox(height: 5),
                        InkWell(
                          onTap: (){

                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Container(
                                width: w-10,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: classic?Colors.green:Colors.white
                                  )
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: AssetImage("assets/logo.jpg"),
                                  ),
                                  trailing: Text("₹$price",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 23),),
                                  title: Text("DOD Classic",style: TextStyle(fontWeight: FontWeight.w900),),
                                  subtitle: Text("Verified, Trained & Tested",style: TextStyle(color: Colors.grey.shade500),),
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0,right: 8),
                            child: Center(
                              child: Container(
                                width: w-10,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: classic?Colors.white:Colors.green
                                    )
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: AssetImage("assets/plus.png"),
                                  ),
                                  trailing: Text("₹${price+100}",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 23,color: Colors.grey),),
                                  title: Text("DOD Plus",style: TextStyle(fontWeight: FontWeight.w900,color: Colors.grey),),
                                  subtitle: Text("Not Available at the moment",style: TextStyle(color: Colors.grey.shade400),),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          )
        ],
      ),
      backgroundColor: Colors.white,
      persistentFooterButtons: [
        Column(
          children: [
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>
                    Say_No(str: "Offers & Coupons",
                        description: "We don't have any Coupons or Offers")));
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0,right: 8,bottom: 8,top: 3),
                child: Row(
                  children: [
                    Icon(Icons.discount,color: Colors.green,),
                    Text("  Select Offers",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w800),),
                    Spacer(),
                    Container(width: 1,height: 24,color: Colors.grey,),
                    SizedBox(width: 9),
                    Icon(Icons.account_balance,color: Colors.green,),
                    Text("  Cash",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w800),),
                    SizedBox(width: 18,),
                    Spacer(),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: (){
                var options = {
                  'key': 'rzp_test_RJ578yxdNSR2zM',
                  'amount': price*100,
                  'name': 'Booking for Classic Driver',
                  'description': "",
                  'prefill': {
                    'contact': "${FirebaseAuth.instance.currentUser!.phoneNumber??""}",
                  }
                };
                _razorpay.open(options);
              },
              child: Container(
                width: w-10,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(6)
                ),
                child: Center(child: Text("Request Classic Driver",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),)),
              ),
            ),
          ],
        )
      ],
    );
  }
  Razorpay _razorpay = Razorpay();


  void _showCustomDialog(BuildContext context) {


    showDialog(
      context: context,
      barrierDismissible: true, // Tap outside to close
      builder: (BuildContext context) {
        if(now){
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: 350,
              height: 310,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: const Text(
                      "When do you need Driver ?",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Divider(),
                  ),
                  const SizedBox(height: 9),
                  InkWell(
                    onTap: (){
                      setState(() {
                        now=!now;
                      });
                      Navigator.pop(context);
                      _showCustomDialog(context);
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color:Global.grey,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 8),
                              child: Center(child: Text("Later",style: TextStyle(fontWeight: FontWeight.w400),)),
                            ),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color:Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 8),
                              child: Center(child: Text("Now",style: TextStyle(fontWeight: FontWeight.w800),)),
                            ),),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 3),
                  Image.asset("assets/car2.gif",width: 100,),
                  SizedBox(height: 5,),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text("Pickup Time : 18 mins from Now",style: TextStyle(fontWeight: FontWeight.w800,color: Colors.grey),),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () async {
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Container(
                        width: 300,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Color(0xff009D60),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Center(child: Text("Set Pickup Time to Now",style: TextStyle(color: Colors.white),)),
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                ],
              ),
            ),
          );
        }else{
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: 350,
              height: 310,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: const Text(
                      "When do you need Driver ?",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Divider(),
                  ),
                  const SizedBox(height: 3),
                  InkWell(
                    onTap: (){
                      setState(() {
                        now=!now;
                      });
                      Navigator.pop(context);
                      _showCustomDialog(context);
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 8),
                              child: Center(child: Text("Later",style: TextStyle(fontWeight: FontWeight.w800),)),
                            ),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color:Global.grey,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 8),
                              child: Center(child: Text("Now",style: TextStyle(fontWeight: FontWeight.w400),)),
                            ),),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 9,),
                  Text("Pickup Time : "+formatDateTime(given),style: TextStyle(fontWeight: FontWeight.w800,color: Colors.grey),),
                  Spacer(),
                  InkWell(
                    onTap: () async {
                      DateTime? dateTime = await showOmniDateTimePicker(
                        context: context,
                        initialDate: given,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(
                          const Duration(days: 7),
                        ),
                        is24HourMode: false,
                        isShowSeconds: false,
                        minutesInterval: 1,
                        secondsInterval: 1,
                        isForce2Digits: false,
                        borderRadius: const BorderRadius.all(Radius.circular(16)),
                        constraints: const BoxConstraints(
                          maxWidth: 350,
                          maxHeight: 650,
                        ),
                        transitionBuilder: (context, anim1, anim2, child) {
                          return FadeTransition(
                            opacity: anim1.drive(
                              Tween(
                                begin: 0,
                                end: 1,
                              ),
                            ),
                            child: child,
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 200),
                        barrierDismissible: true,
                        barrierColor: const Color(0x80000000),
                        selectableDayPredicate: (dateTime) {
                          if (dateTime == DateTime(2023, 2, 25)) {
                            return false;
                          } else {
                            return true;
                          }
                        },
                        type: OmniDateTimePickerType.dateAndTime,
                        title: Text('Select Date & Time'),
                        titleSeparator: Divider(),
                        separator: SizedBox(height: 16),
                        padding: EdgeInsets.all(16),
                        insetPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 24),
                        theme: ThemeData.light(),
                      );
                      if(dateTime!=null){
                        given=dateTime;
                        setState(() {

                        });
                        Navigator.pop(context);
                        _showCustomDialog(context);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Container(
                        width: 300,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Center(child: Text("Change Date & Time")),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () async {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Container(
                        width: 300,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Color(0xff009D60),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Center(child: Text("Confirm Date & Time",style: TextStyle(color: Colors.white),)),
                      ),
                    ),
                  ),
                  SizedBox(height: 15,)
                ],
              ),
            ),
          );}
      },
    );
  }
  String formatDateTime(DateTime dateTime) {
    // Format: DD MonthName, HH:MM AM/PM
    final DateFormat formatter = DateFormat('dd MMMM, hh:mm a');
    return formatter.format(dateTime);
  }
  String formatDate(DateTime dateTime) {
    // Format: DD MonthName, HH:MM AM/PM
    final DateFormat formatter = DateFormat('dd MMM');
    return formatter.format(dateTime);
  }
  String formatTime(DateTime dateTime) {
    // Format: DD MonthName, HH:MM AM/PM
    final DateFormat formatter = DateFormat('hh:mm a');
    return formatter.format(dateTime);
  }
  DateTime given = DateTime.now();

  bool ki=true;
  Widget con(String str,double w)=>Padding(
    padding: const EdgeInsets.all(2.0),
    child: InkWell(
      onTap: (){
        type=str;
        setState(() {

        });
        Navigator.pop(context);
      },
      child: Container(
        width: w/4-14,
        child: Column(
          children: [
            Container(
              width: w/4-14,
              height: w/4-14,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(image: AssetImage("assets/car.jpg")),
                border: Border.all(
                  color: type==str?Colors.blue:Colors.grey.shade400,
                  width: type==str?2:1
                )
              ),
            ),
            Text(str,style: TextStyle(fontWeight: FontWeight.w800,color: Colors.grey.shade600,fontSize: 11),)
          ],
        ),
      ),
    ),
  );
  String type="Hatchbacks";
  String trasmission="Manual";

  int price=99;
  bool classic=true;
  bool isSwitched = false;
  int i = 1;
  Widget r (double w, int y)=>InkWell(
    onTap: (){
      setState(() {
        i=y;
        if(isSwitched){
          price=(369*y).toInt()+40;
        }else{
          price=(369*y).toInt();
        }
      });
    },
    child: Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: Stack(
        children: [
          Container(
            width: w/6-7,
            height: 65,
            decoration: BoxDecoration(
              color: i==y?Colors.blue.shade50:Colors.white,
              border: Border.all(
                color: Colors.grey.shade200,
              ),
              borderRadius: BorderRadius.circular(8)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Text(y.toString(),style: TextStyle(color:i==y?Colors.black:Colors.grey,fontWeight: FontWeight.w800),),
                Text("Hr",style: TextStyle(color:i==y?Colors.black:Colors.grey,fontWeight: FontWeight.w800),)
                ,Spacer(),
              ],
            ),
          ),
          i==y?Container(
            width: w/6-7,
            height: 65,
            child: Column(
              children: [
                SizedBox(height: 3,),
                Row(
                  children: [
                    Spacer(),
                    Icon(Icons.verified,color: Colors.green,size: 20,),
                    SizedBox(width: 3,)
                  ],
                ),
                Spacer(),
              ],
            ),
          ):SizedBox(),
        ],
      ),
    ),
  );
}
