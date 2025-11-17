import 'package:dod/main/second/gethelp.dart';
import 'package:dod/model/ordermodel.dart' show User, OrderModel;
import 'package:dod/second/pages/track.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class MyDriver extends StatelessWidget {
  final OrderModel order;
  const MyDriver({super.key, required this.driver, required this.order});
  final User driver;

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
        title: Text("Driver Info",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () async {

            },
            child: Padding(
              padding: const EdgeInsets.all(13),
              child: Container(
                width: w,
                height: 240,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage("assets/car.webp"),fit: BoxFit.cover,
                      opacity: 0.3),
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.blue,
                      child: Center(child: Text("A",style: TextStyle(color: Colors.white,fontSize: 27),)),
                    ),
                    SizedBox(height: 10,),
                    InkWell(
                        child: Text(driver.name,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 17),)),
                    SizedBox(height: 10,),
                    Text("Member Since : ${formatDate(driver.updatedAt)}",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400),)
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
          InkWell(
            onTap: () async {
              final Uri _url = Uri.parse('tel:${driver.mobile}');
              if (!await launchUrl(_url)) {
              throw Exception('Could not launch $_url');
              }

            },
            child: Container(
                  width: w-25,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.call,color: Colors.white,),
                      SizedBox(width: 14,),
                      Text("Call Driver",
                        style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w900),),
                    ],
                  ),
            ),
          ),
          SizedBox(height: 12,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                  onTap: () async {
                    final Uri _url = Uri.parse('mailto:${driver.email}');
                    if (!await launchUrl(_url)) {
                      throw Exception('Could not launch $_url');
                    }

                  },
                  child: c(w/2-17, Colors.black,0)),
              InkWell(
                  onTap: () async {
                    Navigator.push(context,MaterialPageRoute(builder: (_)=>Track(order: order,)));
                  },
                  child: c(w/2-17, Colors.black,1)),
            ],
          ),
          SizedBox(height: 10,),
          Text("OR",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),),
          SizedBox(height: 10,),
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
        ],
      ),
    );
  }
  Widget c(double w,Color color1,int i)=>Container(
    width: w,
    height: 45,
    decoration: BoxDecoration(
      color: color1,
      borderRadius: BorderRadius.circular(5),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        i==0?Icon(Icons.mail,color: Colors.white,):Icon(Icons.location_on_sharp,color: Colors.white,),
        SizedBox(width: 14,),
        Text(i==0?"Email Driver":"Track Driver",
          style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w900),),
      ],
    ),
  );
  String formatDate(String dateStr) {
    try {
      // Parse the string to DateTime
      DateTime date = DateTime.parse(dateStr);
      // Format as "Month, Year"
      return DateFormat('MMMM, yyyy').format(date);
    } catch (e) {
      return dateStr; // fallback if parsing fails
    }
  }
}
