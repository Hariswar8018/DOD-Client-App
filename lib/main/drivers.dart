import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_widget/google_maps_widget.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as lk;
import 'package:my_location_library21/my_location_library21.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api.dart';
import '../global.dart';
import '../return_functions/location.dart';
import '../second/book_daily.dart' show Daily;
import '../second/one_way.dart' show One_Way;

class Drivers extends StatefulWidget {
  const Drivers({super.key});

  @override
  State<Drivers> createState() => _DriversState();
}

class _DriversState extends State<Drivers> {
  final mapsWidgetController = GlobalKey<GoogleMapsWidgetState>();

  //call function
  Future<void> _getCurrentLocation() async {
    print("Find");
    lk.LocationData? locationData = await LocationService.getCurrentLocation();

    mylat=(await locationData!.longitude)!;
    mylong=(await locationData!.longitude)!;
    setState(() {

    });

    print('Current Location Latitude: ${locationData?.latitude}');
    print('Current Location  Longitude: ${locationData?.longitude}');


  }

  // initialized the function
  void initState() {
    super.initState();
    _getCurrentLocation();
    getvalue();
  }

  double mylat=23.0225,mylong=72.5714;

  String home = "NA";

  Future<void> getvalue() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    home=pref.getString("History")??"NA";
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body:  Stack(
        children: [
          Container(
            width: w,
            height: h-100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
                            onTap: (){
                              _getCurrentLocation();
                            },
                            child: Text("Hire Drivers",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w800,color: Colors.white),)),
                        Spacer(),
                        Text("41 MINS AWAY",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w800,color: Colors.white),)
                      ],
                    ),
                  ),
                ),
                Container(
                  width: w,
                  height: h-90-100,
                  color: Global.grey,
                  child: Stack(
                    children: [
                      Container(
                        width: w,
                        height: h-290,
                        child:  GoogleMapsWidget(
                          apiKey: Api.googlemap,
                          key: mapsWidgetController,
                          sourceLatLng: LatLng(
                            mylat,
                            mylong,
                          ),
                          destinationLatLng: LatLng(
                            mylat,
                            mylong,
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
                      Padding(
                        padding: EdgeInsets.only(top: h-420.0),
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
                                            mylocation.length > 27 ? mylocation.substring(0, 27) + '...' : mylocation,
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
                ),
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
                          mylocation=s;
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
                                  mylocation=s;
                                });
                              }
                            },
                            child: Text(
                              mylocation.length > 34 ? mylocation.substring(0, 34) + '...' : mylocation,
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
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Image.network(str),
            ),
          ),
        ),
        SizedBox(height: 2,),
        Text(str2,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 12),)
      ],
    );
  }

  String mylocation="Ahmedabad Junction Railway Station, Kalupur Railway Station Road, Sakar Bazzar, Kalupur, Ahmedabad, Gujarat 380002";

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
