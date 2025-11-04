import 'package:dod/global.dart';
import 'package:dod/login/bloc/login/view.dart';
import 'package:dod/main/profile/user_screen.dart';
import 'package:dod/main/second/gethelp.dart';
import 'package:dod/main/second/join_as_driver.dart';
import 'package:dod/main/second/offers.dart';
import 'package:dod/main/second/refer.dart';
import 'package:dod/other/say_no.dart';
import 'package:dod/second/link.dart';
import 'package:dod/second/pages/my_bookings.dart';
import 'package:dod/second/pages/mypayments.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  String strreturn(){
    try{
      String phone = FirebaseAuth.instance.currentUser!.phoneNumber??"+911111111111";
      return phone.substring(0,2)+"-"+phone.substring(2,-1);
    }catch(e){
      return "+91-1111111111";
    }
  }
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Global.grey,
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: w,
              height: 150,
              color: Global.grey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(),
                  Text("    Account",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 28),),
                  SizedBox(height: 16,)
                ],
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>User_Profile()));
              },
              onLongPress: (){
                print(FirebaseAuth.instance.currentUser!.uid);
              },
              child: Container(
                width: w,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Global.grey,
                        child: Text("A",style: TextStyle(color: Colors.grey.shade800,fontSize: 28),),
                      ),
                      SizedBox(width: 15,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(UserModel.user.name,style: TextStyle(fontWeight: FontWeight.w800,fontSize: 17),),
                          Text("${strreturn()}"),
                        ],
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios,color: Colors.black,),
                      SizedBox(width: 10,),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 15,),
            Container(
              width: w,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Orders & Payments",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 19),),
                    InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (_)=>
                              MyBookings()));
                        },
                        child: a(Icon(Icons.payment,color: Colors.green,),"Orders","Track all your Bookings in one place")),
                    InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (_)=>
                              MyPayments()));
                        },
                        child: a(Icon(Icons.account_balance,color: Colors.green,),"Payments","View and Manage Payments")),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15,),
            Container(
              width: w,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Rewards & Settings",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 19),),
                    InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (_)=>Refer()));
                        },
                        child: a(Icon(Icons.send,color: Colors.green,),"Refer & Earn","Invite more than 100 Credit")),
                    InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (_)=>Offers()));
                        },
                        child: a(Icon(Icons.discount,color: Colors.green,),"Offers","View all Coupons")),
                    "kk"=="kk"?SizedBox():a(Icon(Icons.circle_sharp,color: Colors.green,),"DOD Coins","Earn Rewards for your Drivings"),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15,),
            Container(
              width: w,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Support",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 19),),
                    InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (_)=>GetHelp()));
                        },
                        child: a(Icon(Icons.support,color: Colors.green,),"Get Help","Get instant and view FAQs")),
                    InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (_)=>Link(link: "", str: "About Us")));
                        },
                        child: a(Icon(Icons.info,color: Colors.green,),"About Us","Known About us")),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15,),
            Container(
              width: w,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("For Partners",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 19),),
                    InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (_)=>Join()));
                        },
                        child: a(Icon(Icons.handshake,color: Colors.green,),"Join as DOD Driver","Earn with DOD with 0 Investment")),
                  ],
                ),
              ),
            ),
            SizedBox(height: 60,),
            Center(child: Image.asset("assets/as.png",width: w/3,)),
            Center(child: Text("v1.0.0",style: TextStyle(color: Colors.grey.shade500),)),
            SizedBox(height: 60,),
          ],
        ),
      ),
    );
  }
  Widget a(Widget a1,String str,String str2)=>ListTile(
    leading: CircleAvatar(
      backgroundColor: Global.grey,
      child: a1
    ),
    title: Text(str,style: TextStyle(fontWeight: FontWeight.w700),),
    subtitle: Text(str2,style: TextStyle(fontWeight: FontWeight.w300),),
    trailing: Icon(Icons.arrow_forward_ios,color: Colors.grey.shade400,),
  );
}
