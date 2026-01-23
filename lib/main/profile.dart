import 'package:dod/global.dart';
import 'package:dod/global/contacts.dart';
import 'package:dod/login/bloc/login/view.dart';
import 'package:dod/main/home.dart';
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

import '../main.dart';
import 'coins/mycoins.dart';

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

  Widget c1(double w , Widget c1,String str, String str2){
    return Container(
      width: w/3-10,
      height: 85,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4)
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            c1,
            Text(str,style: TextStyle(fontWeight: FontWeight.w800,fontSize: 10),),
            Spacer(),
            Row(
              children: [
                Spacer(), Text(str2,style: TextStyle(fontWeight: FontWeight.w800,fontSize: 13),)
              ],
            )
          ],
        ),
      ),
    );
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
            SizedBox(height: 70),
            Center(
              child: Container(
                height: 120,width: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade300,
                ),
                child: Center(
                  child: Container(
                    height: 110,width: 110,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                    ),
                    child: Center(child: Text("${UserModel.user.name.substring(0,1)}",
                      style: TextStyle(color: Colors.grey.shade800,fontSize: 37),)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15,),
            Center(child: Text(UserModel.user.name,style: TextStyle(fontWeight: FontWeight.w800,fontSize: 17),)),
            Center(child: Text("${UserModel.user.mobile}")),
            SizedBox(height: 25,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                c1(w, Icon(Icons.directions_car_rounded), "Trip Booked", "${booked}"),
                c1(w, Icon(Icons.directions_car_rounded), "Trip Completed", "${completed}"),
                c1(w, Icon(Icons.wallet_giftcard), "Wallet Coins", "${UserModel.user.coins}"),
              ],
            ),
            SizedBox(height: 13,),
            Container(
              width: w,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("My Profile",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 19),),
                     InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (_)=>User_Profile()));
                        },
                        child: a(Icon(Icons.person,color: Colors.green,),"Edit Profile","Edit your Personal Details")),
                    InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (_)=>
                              MyCoins()));
                        },
                        child: a(Icon(Icons.account_balance_wallet,color: Colors.green,),"My Coins","Check My Total Coins")),
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
                          Contacts.launchweb();
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
            SizedBox(height: 15,),
            Container(
              width: w,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0,vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0), // Rectangle (no rounded edges)
                                ),
                                title: const Text("Log out ?"),
                                content: const Text("You sure to Log out from the App"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false), // Cancel
                                    child: const Text("Cancel"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      Navigator.pop(context, false);

                                      await FirebaseAuth.instance.signOut();
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (_) => MyHomePage(title: "")),
                                      );
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty.resolveWith(
                                            (states) => Colors.red,   // your color here
                                      ),
                                    ),
                                    child: const Text("OK",style: TextStyle(color: Colors.white)),
                                  )
                                ],
                              );
                            },
                          );

                              },
                        child: ListTile(
                          leading: Icon(Icons.login,color: Colors.red,),
                          title: Text("Log Out",style: TextStyle(fontWeight: FontWeight.w900,color: Colors.red),),
                        )
                    ),
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
