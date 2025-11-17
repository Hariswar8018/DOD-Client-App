import 'package:dod/model/ordermodel.dart';
import 'package:flutter/material.dart';

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
        title: Text("Track Driver",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
      ),
      body: error(w),
    );
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
