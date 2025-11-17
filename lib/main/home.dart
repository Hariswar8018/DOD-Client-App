import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:dod/api.dart';
import 'package:dod/global.dart';
import 'package:dod/main/googlemap.dart';
import 'package:dod/main/second/offers.dart';
import 'package:dod/main/second/refer.dart';
import 'package:dod/return_functions/location.dart';
import 'package:dod/second/one_way.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' show Placemark, placemarkFromCoordinates;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_widget/google_maps_widget.dart';
import 'package:location/location.dart' as lk;
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../global/contacts.dart';
import '../login/bloc/login/view.dart';
import '../model/booking_response.dart';
import '../model/ordermodel.dart' show OrderModel;
import '../second/book_daily.dart' show Daily;
import '../second/pages/my_bookings.dart';
import '../second/pages/mypayments.dart';

class Home extends StatefulWidget {
   Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  void initState() {
    super.initState();
    all();
  }



  all() async {
    await getvalue();
    await getCurrentLocation();
    await gets();
    setState(() {

    });
  }

  Future<LatLng> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception("Location permission denied");
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception("Location permission permanently denied");
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      print("Latitude: ${position.latitude}, Longitude: ${position.longitude}");

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks.first;

      String mynew =
          "${place.subLocality ?? ''}, ${place.street ?? ''}, ${place.subAdministrativeArea ?? ''}, "
          "${place.locality ?? ''}, ${place.postalCode ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}";

      print("Current Address: $mynew");

      Global.mylocation = mynew;
      Global.mylat = position.latitude;
      Global.mylong = position.longitude;
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      print("Error getting location: $e");
      throw Exception("Failed to fetch location");
    }
  }


  String home = "NA";

  Future<void> getvalue() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    home=pref.getString("History")??"NA";
  }
  Stream<String> alternatingTextStream({String text1="Your Next Driver", String text2="41 MINS AWAY"}) async* {
    bool showFirst = true;
    while (true) {
      yield showFirst ? text1 : text2;
      showFirst = !showFirst;
      await Future.delayed(const Duration(seconds: 4));
    }
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
          orders.add(order);
        }
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
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor:Global.grey,
      body: Container(
        width: w,height: h,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: w,
                    height: 90+460,
                    child: Column(
                      children: [
                        Container(
                          width: w,
                          height: 90,
                          color: Color(0xff25252D),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                InkWell(
                                    child: Text("Hire Drivers",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w800,color: Colors.white),)),
                                Spacer(),
                                StreamBuilder<String>(
                                  stream: alternatingTextStream(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) return const SizedBox();
                                    return Text(
                                      snapshot.data!,
                                      style:  TextStyle(fontSize: 13, color: snapshot.data=="Your Next Driver"? Colors.white:Colors.blue,fontWeight: FontWeight.w800,),
                                      textAlign: TextAlign.center,
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: w,
                          height: 460,
                          color: Global.grey,
                          child: Stack(
                            children: [
                              GoogleMap3(),
                              Padding(
                                padding: const EdgeInsets.only(top: 210.0),
                                child: Column(
                                  children: [
                                    Center(
                                      child: Container(
                                        width: w-20,
                                        height: 80,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(3)
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            a(w,Icon(Icons.arrow_right_alt,size: 30,),"One Way",0),
                                            a(w,Icon(
                                              CupertinoIcons.arrow_2_squarepath,size: 30,
                                            ),"Round Trip",1),
                                            a(w,Icon(
                                              CupertinoIcons.bus,size: 30,
                                            ),"Outstation",2),
                                            a(w,Icon(Icons.calendar_month,size: 30),"Daily",3),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    i==3?Center(
                                      child: InkWell(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (_) =>
                                              Daily(
                                              )));  },
                                        child: Container(
                                          width: w - 20,
                                          height: 140,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(3),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Container(
                                                width: w,
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                                  child: Row(
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text("Get Daily Drivers",style: TextStyle(fontSize: 21,color: Colors.green,fontWeight: FontWeight.w800),),
                                                          Text("Get Daily Drivers at your Door Step",style: TextStyle(fontSize: 13),),
                                                          Text("who even speak your Language",style: TextStyle(fontSize: 13),)
                                                        ],
                                                      ),Spacer(),
                                                      Image.asset("assets/clocl.jpg",width: w/4,),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 30,
                                                width: w-60,
                                                decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius: BorderRadius.circular(5)
                                                ),
                                                child: Center(child: Text("Reserve Now",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w800,color: Colors.white),)),
                                              ),
                                              SizedBox(height: 8,)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ):Center(
                                      child: InkWell(
                                        onTap: (){
                                          Navigator.push(context,MaterialPageRoute(builder: (_)=>One_Way(dateTime: given,i: i,)));
                                        },
                                        child: Container(
                                          width: w - 20,
                                          height: 140,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(3),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(height: 7),
                                              InkWell(
                                                onTap: (){
                                                  Navigator.push(context,MaterialPageRoute(builder: (_)=>One_Way(dateTime: given,i: i,)));
                                                },
                                                child: Container(
                                                  width: w - 40,
                                                  height: 45,
                                                  decoration: BoxDecoration(
                                                    color: Global.grey,
                                                    borderRadius: BorderRadius.circular(3),
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      SizedBox(width: 15),
                                                      Icon(Icons.search),
                                                      SizedBox(width: 15),
                                                      Text(i==1?"Where from ?":"Where to ?",
                                                        style: TextStyle(fontWeight: FontWeight.w700,color: Colors.grey,fontSize: 17),),
                                                      Spacer(),
                                                      InkWell(
                                                        onTap: (){
                                                          _showCustomDialog(context);
                                                        },
                                                        child: Container(
                                                          height: 30,
                                                          decoration: BoxDecoration(
                                                              color: Colors.blue.shade50,
                                                              borderRadius: BorderRadius.circular(4)
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 14.0,vertical: 4),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Icon(Icons.calendar_month,size: 15,),
                                                                Padding(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                                  child: Text(now?"Now":"Later",style: TextStyle(fontSize: 12),),
                                                                ),
                                                                Icon(Icons.keyboard_arrow_down,color: Colors.black,size: 15,)
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 3),
                                              Row(
                                                children: [
                                                  SizedBox(width: 15),
                                                  Icon(Icons.location_searching_sharp, color: Colors.green),
                                                  SizedBox(width: 10),
                                                  Text("My Location : ", style: TextStyle(color: Colors.green)),
                                                  Text(
                                                    Global.mylocation!.length > 27 ? Global.mylocation!.substring(0, 27) + '...' : Global.mylocation!,
                                                    style: TextStyle(color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 3),
                                              Row(
                                                children: [
                                                  SizedBox(width: 15),
                                                  Icon(Icons.history, color: Colors.grey),
                                                  SizedBox(width: 10),
                                                  Text(home=="NA"?"No History":home.length>40?home.substring(0,40)+"...":home, style: TextStyle(color: Colors.grey)),
                                                ],
                                              ),
                                              SizedBox(height: 3),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 75.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: w-40,
                          height: 45,
                          decoration: BoxDecoration(
                              color: Global.grey,
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: InkWell(
                            onTap: () async {
                              String s =await Navigator.push(context, MaterialPageRoute(builder: (_)=>Location()));
                              if(s!=null){
                                setState(() {
                                  Global.mylocation=s;
                                });
                              }
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: 15),
                                Icon(Icons.location_on),
                                SizedBox(width: 15),
                                Expanded(
                                  child: InkWell(
                                    onTap: () async {
                                      String s =await Navigator.push(context, MaterialPageRoute(builder: (_)=>Location()));
                                      if(s!=null){
                                        setState(() {
                                          Global.mylocation=s;
                                        });
                                      }
                                    },
                                    child: Text(
                                      Global.mylocation!.length > 34 ? Global.mylocation!.substring(0, 34) + '...' : Global.mylocation!,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              orders.isEmpty?SizedBox():SizedBox(height: 10,),
              orders.isEmpty?SizedBox():Container(
                width: w,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (_)=>
                              MyBookings()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("My Upcoming Bookings",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 19),),
                            Text("See All >  ",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 14,color: Colors.blue),),
                          ],
                        ),
                      ),
                      SizedBox(height: 13,),
                      Container(
                        width: w,
                        height: 220,
                        child: ListView.builder(
                          itemCount: orders.length,scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            final OrderModel myorder = orders[index];
                            return OrderCards(myorder: myorder,onUpdate: () async {
                              await gets();
                              setState(() {

                              });
                            },);
                          },
                        ),
                      ),
                      SizedBox(height: 9,),

                    ],
                  ),
                ),
              ),
              SizedBox(height: 25,),
              Container(
                width: w,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Services",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 19),),
                      SizedBox(height: 13,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                              onTap:(){
                                Navigator.push(context, MaterialPageRoute(builder: (_)=>Offers()));
                              },
                              child: cont(w, Colors.greenAccent.shade100, "assets/normal-forms-svgrepo-com.svg", "Offers & Coupons")),
                          InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (_)=>
                                    MyBookings()));
                              },
                              child: cont(w, Colors.blue.shade50, "assets/online-order-shopping-ecommerce-svgrepo-com.svg", "My Bookings")),
                          InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (_)=>Refer()));
                              },
                              child: cont(w, Colors.orange.shade50, "assets/share-svgrepo-com.svg", "Refer & Earn")),
                        ],
                      ),
                      SizedBox(height: 9,),

                    ],
                  ),
                ),
              ),
              SizedBox(height: 25,),
              Container(
                width: w,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Special Offers",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 19),),
                      SizedBox(height: 13,),
                      Container(
                        width: w,
                        height: 140,
                        child: CarouselSlider(
                          options: CarouselOptions(
                              height: 130.0,enableInfiniteScroll: true,enlargeCenterPage: true,
                            viewportFraction: 1.0,           // Shows only 1 image at a time
                            autoPlay: true,                  // Optional: autoplay if you want
                          ),
                          items: special_offer.map((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.symmetric(horizontal: 1.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                        image: DecorationImage(image: NetworkImage(i),fit: BoxFit.cover)
                                    ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
              InkWell(
                onTap: Contacts.launchwhatsapp,
                child: Container(
                  width: w-30,
                  color: Colors.green.shade100,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: ListTile(
                      leading: CircleAvatar(
                          backgroundColor: Global.grey,
                          child: Icon(Icons.two_wheeler)),
                      title: Text("Learn Driving",style: TextStyle(fontWeight: FontWeight.w700),),
                      subtitle: Text("We have a Service about Learning to Drive too",style: TextStyle(fontSize: 11),),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8,),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>
                      MyPayments()));
                },
                child: Container(
                  width: w-30,
                  color: Colors.red.shade100,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: ListTile(
                      leading: CircleAvatar(
                          backgroundColor: Global.grey,
                          child: Icon(Icons.payments)),
                      title: Text("See My Payments",style: TextStyle(fontWeight: FontWeight.w700),),
                      subtitle: Text("Check all your Transactions done in App",style: TextStyle(fontSize: 11),),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                width: w,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child:Image.asset("assets/home_bottom.jpg",fit: BoxFit.cover,)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


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
                      Navigator.push(context,MaterialPageRoute(builder: (_)=>One_Way(dateTime: DateTime.now().add(Duration(minutes: 25)),i: i,)));
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
                      // Disable 25th Feb 2023
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
                    Navigator.push(context,MaterialPageRoute(builder: (_)=>One_Way(dateTime: given,i: i,)));
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
  bool now = false;
  String formatDateTime(DateTime dateTime) {
    // Format: DD MonthName, HH:MM AM/PM
    final DateFormat formatter = DateFormat('dd MMMM, hh:mm a');
    return formatter.format(dateTime);
  }

  DateTime given = DateTime.now().add(Duration(hours: 4));


  List<String> special_offer=[
    "https://www.sliderrevolution.com/wp-content/uploads/2023/02/carousels.jpg",
    "https://www.sliderrevolution.com/wp-content/uploads/2023/09/mobile-carousel.jpg",
    "https://cdn.prod.website-files.com/6009ec8cda7f305645c9d91b/60108425d58c7fb3aac2e496_6002086f72b727411a01e2a6_sigma-template.jpeg",
    "https://res.cloudinary.com/cloudinary-marketing/images/f_auto,q_auto/v1682458232/blog-responsive-carousel/blog-responsive-carousel.jpg?_i=AA",
    "https://i.ytimg.com/vi/3GJach7WmFY/maxresdefault.jpg"
  ];

  Widget cont(double w,Color color,String str,String str2){
    return Column(
      children: [
        Container(
          width: w/3-38,
          height: w/3-38,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color:color,
          ),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: SvgPicture.asset(
              str,
            ),
          )
        ),
        SizedBox(height: 3,),
        Text(str2,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 12),)
      ],
    );
  }



  TextEditingController controller=TextEditingController();

  Widget a(double w,Widget icon,String str,int u)=>InkWell(
    onTap: (){
      setState(() {
        i=u;
      });
    },
    child: Container(
      width: w/4-10,
      height: 80,
      child: Column(
        children: [
          Spacer(),
          SizedBox(height: 3,),
          icon,
          SizedBox(height: 3,),
          Text(str,style: TextStyle(fontWeight: i==u?FontWeight.w400:FontWeight.w300,color:i==u?Colors.black: Colors.grey),),
          Spacer(),
          Container(
            width: w/4-10,
            height: 4,
            decoration: BoxDecoration(
                color: i==u?Colors.green:Colors.white,
                borderRadius: BorderRadius.circular(10)
            ),
          )
        ],
      ),
    ),
  );

  int i = 0;
}



