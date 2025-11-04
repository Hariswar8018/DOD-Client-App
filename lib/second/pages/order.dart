import 'package:dod/model/ordermodel.dart';
import 'package:dod/second/pages/track.dart';
import 'package:flutter/material.dart';

import '../../main/second/gethelp.dart' show GetHelp;
import 'mybooking_full.dart';

class Myorder extends StatelessWidget {
  OrderModel order;
   Myorder({super.key,required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        centerTitle: true,
        title: Text("Order Issue / Info",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
      ),
      body: Column(
        children: [
          InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>MyBookingFull(order: order)));
              },
              child: lis(Icon(Icons.indeterminate_check_box), "My Order", "Info about your Product")),
          InkWell(
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (_)=>Track()));
              },
              child: lis(Icon(Icons.my_location_outlined), "Track Driver", "Track Driver of their Location")),
          InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>GetHelp()));
              },
              child: lis(Icon(Icons.support_agent), "Support Team", "Raise Ticket or Reach Customer Care")),
          InkWell(
              onTap: (){
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Cancel your Order ?"),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      content: const Text("Please reach out to Customer Care to Cancel your Order"),
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
                            Navigator.push(context, MaterialPageRoute(builder: (_)=>GetHelp()));
                               },
                        ),
                      ],
                    );
                  },
                );
              },
              child: lis(Icon(Icons.cancel_presentation,color: Colors.red,), "Cancellation", "Cancel & Terminate your Sheduled Ride")),

        ],
      ),
    );
  }
  Widget lis(Widget c, String str,String str2)=>ListTile(
    leading: c,
    title: Text(str),
    subtitle: Text(str2),
    trailing: Icon(Icons.arrow_forward),
  );
}
