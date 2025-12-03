import 'package:dod/global.dart';
import 'package:dod/model/ordermodel.dart';
import 'package:dod/return_functions/driver_location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_widget/google_maps_widget.dart';

import '../../main/second/gethelp.dart';

class Track extends StatefulWidget {
  OrderModel order;
  Track({super.key,required this.order});

  @override
  State<Track> createState() => _TrackState();
}

class _TrackState extends State<Track> {

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
        title: InkWell(
            onTap: (){
              print(widget.order.driver!.firebaseId);
            },
            child: Text("Track Driver",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),)),
      ),
      body: check()?
      DriverMapWidget(driverId: widget.order.driver!.firebaseId, initialCameraPosition: LatLng(Global.mylat!, Global.mylong!)):
      error(w),
    );
  }
  bool check(){
    if(widget.order.status=="arriving"||widget.order.status=="arrived"){
      return true;
    }
    if(widget.order.tripType!="monthly"||widget.order.tripType!="weekly"){
      return canShowStartButton(startDateTimeString: widget.order.bookingTime.toString(), isDailyDriver: false, endDateString: widget.order.bookingTime.toString());
    }else{
      return canShowStartButton(startDateTimeString: widget.order.recurringBooking!.startDate, isDailyDriver: true, endDateString: widget.order.recurringBooking!.endDate);
    }
  }
  bool canShowStartButton({
    required String startDateTimeString,
    required bool isDailyDriver,
    required String endDateString,   // ← changed here
  }) {
    // Parse the start datetime string
    DateTime? startDateTime = DateTime.tryParse(startDateTimeString);
    if (startDateTime == null) return false; // invalid input

    // Parse end date string (only date required)
    DateTime? endDate = DateTime.tryParse(endDateString);
    if (endDate == null) return false; // invalid input

    DateTime now = DateTime.now();

    // ---------------------------
    // CASE 1: One-Time Driver
    // ---------------------------
    if (!isDailyDriver) {
      // window: (start - 20 minutes) ≤ now < start
      DateTime windowStart = startDateTime.subtract(Duration(minutes: 20));
      return now.isAfter(windowStart) && now.isBefore(startDateTime);
    }

    // --------------------------------
    // CASE 2: Daily Driver
    // --------------------------------

    // Extract only the TIME from the startDateTime (hour/minute)
    int hour = startDateTime.hour;
    int minute = startDateTime.minute;

    // Today’s schedule time (same time every day)
    DateTime todayScheduled = DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    DateTime todayWindowStart =
    todayScheduled.subtract(Duration(minutes: 20));

    // Convert dates to compare only date part
    DateTime startDateOnly = DateTime(startDateTime.year, startDateTime.month, startDateTime.day);
    DateTime endDateOnly = DateTime(endDate.year, endDate.month, endDate.day);
    DateTime todayDateOnly = DateTime(now.year, now.month, now.day);

    // Check if today is between start and end date
    bool dateValid = todayDateOnly.isAtSameMomentAs(startDateOnly) ||
        (todayDateOnly.isAfter(startDateOnly) && todayDateOnly.isBefore(endDateOnly)) ||
        todayDateOnly.isAtSameMomentAs(endDateOnly);

    if (!dateValid) return false;

    // Time check (20 minutes window)
    return now.isAfter(todayWindowStart) && now.isBefore(todayScheduled);
  }

  Widget error(double w){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(child: Image.asset("assets/error.png",width: w/2,)),
        SizedBox(height: 19,),
        Center(child: Text(isAfter(widget.order.bookingTime.toString())==-1?"Time is behind of you !":"Time is ahead of you !",style: TextStyle(fontSize: 21,fontWeight: FontWeight.w800),)),
        Center(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0,vertical: 8),
          child: Text(textAlign: TextAlign.center,"You could only Track Driver just 20 minutes before and after, Or else the Status should be Arriving",
          style: TextStyle(fontSize: 14,),),
        )),
        SizedBox(height: 30,),
        Center(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0,vertical: 8),
          child: Text(textAlign: TextAlign.center,"If you want, You could Raise a Dispute",
            style: TextStyle(fontSize: 14,),),
        )),
        SizedBox(height: 3,),
        InkWell(
          onTap: (){
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Raise an Dispute? ?"),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  content: const Text("Please reach out to Customer Care to Raise an Dispute with Driver"),
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
                        Navigator.of(context).pop();
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>GetHelp()));
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Container(
            width: w-25,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.support_agent_outlined,color: Colors.white,),
                SizedBox(width: 14,),
                Text("Raise an Dispute",
                  style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w900),),
              ],
            ),
          ),
        ),
        SizedBox(height: 40,),
      ],
    );
  }

  int isAfter(String dateString) {
    try {
      DateTime parsed = DateTime.parse(dateString).toUtc();
      final now = DateTime.now().toUtc();

      final diffMinutes = now.difference(parsed).inMinutes;

      if (diffMinutes > 20) {
        return 1;  // parsed is more than 20 min in the past
      } else if (diffMinutes < -20) {
        return -1; // parsed is more than 20 min in the future
      } else {
        return 0;  // within ±20 minutes
      }
    } catch (e) {
      return -1;
    }
  }

  int isWithin20Minutes(DateTime dateTime) {
    final now = DateTime.now().toUtc();

    final difference = now.difference(dateTime).inMinutes.abs();

    return difference;
  }

}
