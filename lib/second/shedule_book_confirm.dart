import 'dart:math';

import 'package:dio/dio.dart';
import 'package:dod/second/message/success.dart' show BookingSuccess;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';

import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../api.dart';
import '../global.dart';
import '../login/bloc/login/view.dart';

class Daily_Driver extends StatefulWidget {
  final String pickup, drop;
  Daily_Driver({super.key,required this.pickup, required this.drop});

  @override
  State<Daily_Driver> createState() => _Daily_DriverState();
}

class _Daily_DriverState extends State<Daily_Driver> {
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
        centerTitle: false,
        title: Text("Daily DOD Driver",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
      ),
      body:Container(
          width: w,
          height: h,
          child: SingleChildScrollView(
            child: Container(
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
                          Container(
                              width: w-90,
                              child: Text(widget.pickup,style: TextStyle(fontSize: 12),)),
                          SizedBox(width: 8,),
                        ],
                      ),
                    ),
                  ),
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
                          Container(
                              width: w-90,
                              child: Text(widget.drop,style: TextStyle(fontSize: 12),)),
                          SizedBox(width: 8,)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text("   Select Car Type",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 17),),
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
                  Text("   Select Estimated per Day Usage",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 17),),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      SizedBox(width: 10,),
                      r(w, 4),r(w, 6),r(w, 8),
                      r(w, 10),r(w, 12)
                    ],
                  ),
                  SizedBox(height: 15,),
                  ""==""?SizedBox():Row(
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
                  SizedBox(height: 22),
                  Text("   Select PickUp Time ",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 17),),
                  SizedBox(height: 10,),
                  Center(
                    child: Container(
                      width: w - 20,
                      height: 45,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade200,
                        ),
                        borderRadius: BorderRadius.circular(5), // Optional rounded corners
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        child: DropdownButtonHideUnderline( // Removes underline
                          child: DropdownButton<String>(
                            isExpanded: true, // Makes dropdown fill the width
                            hint: Text("Select a Time"),
                            value: selectedValue,
                            items: items.map((String item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedValue = newValue;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 22),
                  Text("   Select Pickup Dates ",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 17),),
                  SizedBox(height: 10,),
                  Center(
                    child: InkWell(
                      onTap: () async {
                        List<DateTime>? dateTimeList = await showOmniDateTimeRangePicker(
                          context: context,
                          startInitialDate: DateTime.now(),
                          startFirstDate: DateTime.now(),
                          startLastDate: DateTime.now().add(
                            const Duration(days: 10),
                          ),
                          endInitialDate: DateTime.now(),
                          endFirstDate:DateTime.now(),
                          endLastDate: DateTime.now().add(
                            const Duration(days: 30),
                          ),
                          is24HourMode: false,
                          isShowSeconds: false,
                          minutesInterval: 1,
                          secondsInterval: 1,
                          isForce2Digits: false,
                          isForceEndDateAfterStartDate: true,
                          onStartDateAfterEndDateError: () {
                            // Handle error when start date is after end date
                            print('Start date cannot be after end date!');
                          },
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
                          barrierColor: Colors.black54,
                          startSelectableDayPredicate: (dateTime) {
                            if (dateTime == DateTime(2023, 2, 25)) {
                              return false;
                            } else {
                              return true;
                            }
                          },
                          endSelectableDayPredicate: (dateTime) {
                            // Disable 26th Feb 2023 for end date
                            if (dateTime == DateTime(2023, 2, 26)) {
                              return false;
                            } else {
                              return true;
                            }
                          },
                          type: OmniDateTimePickerType.date,
                          title: Text('Select Date & Time Range'),
                          titleSeparator: Divider(),
                          startWidget: Text('Start'),
                          endWidget: Text('End'),
                          separator: SizedBox(height: 16),
                          defaultTab: DefaultTab.start,
                          padding: EdgeInsets.all(16),
                          insetPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 24),
                          theme: ThemeData.light(),
                        );
                        if(dateTimeList!=null){
                          List<DateTime> allDates = getDatesBetween(dateTimeList.first, dateTimeList.last);
                            date=allDates;
                          setState(() {

                          });
                        }
                      },
                      child: Container(
                        width: w - 20,
                        height: 45,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade200,
                          ),
                          borderRadius: BorderRadius.circular(5), // Optional rounded corners
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(date.isNotEmpty?"${date.length} Days Chosen":"Choose Dates",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
                        )
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  ""==""?SizedBox():Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("   Select Driver Language ",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 17),),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          width: w/2-15,
                          child: MultiSelectDialogField(
                            items: item.map((e) => MultiSelectItem<String>(e, e)).toList(),
                            title: Text("Select Language"),
                            selectedColor: Colors.blue,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              border: Border.all(
                                color: Colors.grey.shade200,
                                width: 1,
                              ),
                            ),
                            buttonText: Text(
                              selectedValue1.isEmpty?"Select Lang":"${selectedValue1.length} Languages",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                            ),
                            chipDisplay: MultiSelectChipDisplay.none(),
                            onConfirm: (results) {
                              setState(() {
                                selectedValue1 = results;
                              });
                            },
                          ),
                        ),
                      )

                    ],
                  ),
                ],
              ),
            ),
          )
      ),
      persistentFooterButtons: [
        progress ? Center(child: CircularProgressIndicator(),):InkWell(
          onTap: () async {
            if(date.isEmpty){
              Send.message(context, "Choose Date", false);
              return ;
            }
            start();
          },
          child: Container(
              width: w-20,
              height: 45,
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Center(child: Text("Continue to Shedule Driver",style: TextStyle(color: Colors.white,),))
          ),
        )
      ],

    );
  }
  Future<void> start() async {

    on(true);
    final Dio dio = Dio(
      BaseOptions(
        validateStatus: (status) => status != null && status < 500,
      ),
    );
    String utcString = date.last.toUtc().toIso8601String();

    double dlat = await latitute(widget.drop);
    double dlon = await latitute(widget.drop);

    double plat = await latitute(widget.pickup);
    double plon = await latitute(widget.pickup);
    double distance = double.parse(
      haversine(plat, plon, dlat, dlon).toStringAsFixed(2),
    );
    List<Map<String, dynamic>> allRoutes = [];
    List<DateTime> dates = date;

    final result = getPickupAndDropTime("9:00 AM", 3);

    String drop = result['pickup']!;
    String drop2=result['drop']!;

    for (final date in dates) {
      allRoutes.addAll([
        {
          "pickup_location": widget.pickup,
          "pickup_latitude": plat,
          "pickup_longitude": plon,
          "drop_location": widget.drop,
          "drop_latitude": dlat,
          "drop_longitude": dlon,
          "pickup_time": drop,
          "drop_time": drop2,
          "date": "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        },
        {
          "pickup_location": widget.drop,
          "pickup_latitude": dlat,
          "pickup_longitude": dlon,
          "drop_location": widget.pickup,
          "drop_latitude": plat,
          "drop_longitude": plon,
          "pickup_time": drop,
          "drop_time":drop2,
          "date": "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        },
      ]);
    }

    final List<String> days = dates.map((d) => [
      "monday",
      "tuesday",
      "wednesday",
      "thursday",
      "friday",
      "saturday",
      "sunday"
    ][d.weekday - 1])
        .toSet()
        .toList();

    final data = {
      "coupon_id": "",
      "booking_type": "monthly",
      "trip_type": "upcoming",
      "status": "pending",
      "paymentmethod": "cash",
      "pickup_location": widget.pickup,
      "pickup_latitude": plat,
      "pickup_longitude": plon,
      "drop_location": widget.drop,
      "drop_latitude": dlat,
      "drop_longitude": dlon,
      "booking_time": utcString,
      "distance_km": distance.toInt() + 10,
      "waiting_hours": i,
      "routes": allRoutes,
      "start_date":
      "${dates.first.year}-${dates.first.month.toString().padLeft(2, '0')}-${dates.first.day.toString().padLeft(2, '0')}",
      "end_date":
      "${dates.last.year}-${dates.last.month.toString().padLeft(2, '0')}-${dates.last.day.toString().padLeft(2, '0')}",
      "days": days,
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
        on(false);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>BookingSuccess(
          time: date.last,
          address: widget.pickup, tid: "${DateTime.now().millisecondsSinceEpoch}",)));
        return ;
      }
      on(false);

      Send.message(context, "Error ${response.statusMessage}", false);
      return ;

    } catch (e) {
      on(false);

      Send.message(context, "Error $e", false);
      print("Error during API call: $e");
    }
  }
  bool progress = false;
  void on(bool given){
    setState(() {
      progress=given;
    });
  }

  Map<String, String> getPickupAndDropTime(String pickupTimeStr, int addHours) {
    // Define a formatter to parse 12-hour format time like "9:00 AM"
    final DateFormat inputFormat = DateFormat('h:mm a');

    // Parse pickup time
    DateTime pickupTime = inputFormat.parse(pickupTimeStr);

    // Add hours to get drop time
    DateTime dropTime = pickupTime.add(Duration(hours: addHours));

    // Format both times back to 12-hour format
    final DateFormat outputFormat = DateFormat('h:mm a');
    String formattedPickup = outputFormat.format(pickupTime);
    String formattedDrop = outputFormat.format(dropTime);

    return {
      "pickup": formattedPickup,
      "drop": formattedDrop,
    };
  }

  Future<double> latitute(String str) async {
    List<Location> locations = await locationFromAddress(str);
    return locations.first.latitude;
  }
  Future<double> longitude(String str) async {
    List<Location> locations = await locationFromAddress(str);
    return locations.first.longitude;
  }
  List<DateTime> getDatesBetween(DateTime start, DateTime end) {

    if (start.isAfter(end)) {
      final temp = start;
      start = end;
      end = temp;
    }

    int totalDays = end.difference(start).inDays;
    return List.generate(totalDays + 1, (index) {
      return DateTime(start.year, start.month, start.day + index);
    });
  }

  List<DateTime> date = [];
  Razorpay _razorpay = Razorpay();
  String? selectedValue; // Store the selected value

  // List of items for the dropdown
// Existing fruits
  final List<String> items = [];

// Add time slots from 1:00 AM to 12:00 PM
  void addTimeSlots() {
    for (int i = 1; i <= 12; i++) {
      items.add("${i}:00 AM");
    }
    for (int i = 1; i <= 12; i++) {
      items.add("${i}:00 PM");
    }
  }

// Call this in initState or before using items
  @override
  void initState() {
    super.initState();
    addTimeSlots();

  }


  List selectedValue1 = []; // Store the selected value

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

  final List<String> item = [
    "English",
    "Assamese",
    "Bengali",
    "Bodo",
    "Dogri",
    "Gujarati",
    "Hindi",
    "Kannada",
    "Kashmiri",
    "Konkani",
    "Maithili",
    "Malayalam",
    "Manipuri",
    "Marathi",
    "Nepali",
    "Odia",
    "Punjabi",
    "Sanskrit",
    "Santali",
    "Sindhi",
    "Tamil",
    "Telugu",
    "Urdu"
  ];


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
  int i = 4;
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
