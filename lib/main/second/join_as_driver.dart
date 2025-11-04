import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

class Join extends StatelessWidget {
  const Join({super.key});

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
        title: Text("Join as DOD Driver",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/driver.jpg",width: w-30,),
            SizedBox(height: 13,),
            Text("Join as a Driver with DOD !"
              ,style: TextStyle(fontWeight: FontWeight.w900,fontSize: 22),textAlign: TextAlign.center,),
            SizedBox(height: 5,),
            Text("Become your own boss with Driver on Demand — the smart platform that connects skilled drivers with people who need reliable rides on schedule. Whether you’re looking for full-time opportunities or part-time flexibility, DOD gives you the freedom to earn on your own terms."
              ,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 11),textAlign: TextAlign.center,),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("  Benefits of Joining :"
                  ,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),textAlign: TextAlign.center,),
              ],
            ), SizedBox(height: 4,),
            list(Icon(Icons.access_time_outlined), "Flexible working hours"),
            list(Icon(Icons.payments), "Transparent and timely payments"),
            list(Icon(Icons.verified), "Access to verified customers and scheduled drives"),
            list(Icon(Icons.card_giftcard_sharp), "Rewards, bonuses, and referral opportunities"),
            list(Icon(Icons.support_agent), "24/7 driver support and safety-first policies"),
            Spacer(),
            InkWell(
                onTap: () async {
                  final Uri _url = Uri.parse('https://play.google.com/store/apps/details?id=com.starwish.dod_partner');
                  if (!await launchUrl(_url)) {
                    throw Exception('Could not launch $_url');
                  }
                },
                child: Image.asset("assets/googleplay.png",width: w-70,)),
            Spacer()
          ],
        ),
      ),
    );
  }
  Widget list(Widget c, String str)=>Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Row(
      children: [
        SizedBox(width: 10,),
        c,
        SizedBox(width: 10,),
        Text(str,style: TextStyle(fontSize: 12),),
      ],
    ),
  );
}
