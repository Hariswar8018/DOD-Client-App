import 'package:dod/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class Refer extends StatelessWidget {
  const Refer({super.key});

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
        title: Text("Refer & Earn",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/refer.webp",width: w,),
            SizedBox(height: 13,),
            Text("Earn Rewards with DOD !"
              ,style: TextStyle(fontWeight: FontWeight.w900,fontSize: 22),textAlign: TextAlign.center,),
            SizedBox(height: 5,),
            Text("Share the convenience of Driver on Demand with your friends and earn exciting rewards! When your friend registers using your referral link or code, you’ll receive exclusive coins in your wallet. These coins can be redeemed for discounts on your next drive bookings."
              ,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 11),textAlign: TextAlign.center,)
            ,
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("  Steps for Earning :"
                  ,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),textAlign: TextAlign.center,),
              ],
            ), SizedBox(height: 4,),
            list(Icon(Icons.share), "Share your unique referral code or link with friends"),
            list(Icon(Icons.logout_outlined), "Once your friend registers, you’ll receive coins"),
            list(Icon(Icons.local_offer), "Use your coins to get discounts on future drives"),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("  My Reward Code :"
                  ,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),textAlign: TextAlign.center,),
              ],
            ),SizedBox(height: 4,),
            InkWell(
              onTap: (){
                Clipboard.setData(ClipboardData(text: "${FirebaseAuth.instance.currentUser!.uid}"));
                    Send.message(context, "Copied to Clipboard", true);
              },
              child: Container(
                width: w-15,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(child: Text("${FirebaseAuth.instance.currentUser!.uid}  | 📋 ",style: TextStyle(
                  fontWeight: FontWeight.w900,color: Colors.grey.shade800,fontSize: 14
                ),)),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
      persistentFooterButtons: [
        InkWell(
          onTap: (){
            SharePlus.instance.share(
                ShareParams(text: 'Now Schedule Drivers for your Trip with ease. Download our App now, and enjoy one way trips, outstation, and even daily drivers. \nDownload Now : https://play.google.com/store/apps/details?id=com.starwish.dod')
            );
          },
          child: Container(
            width: w-10,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(6)
            ),
            child: Center(child: Text("Invite Friends",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),)),
          ),
        ),
      ],
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
