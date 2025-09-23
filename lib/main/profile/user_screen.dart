import 'package:dod/api.dart';
import 'package:dod/global.dart';
import 'package:dod/main.dart';
import 'package:dod/main/profile/update_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class User_Profile extends StatelessWidget {
   User_Profile({super.key});
  final dio = Dio();
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Global.grey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        centerTitle: true,
        title: Text("PROFILE",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),),
        actions: [
          TextButton(onPressed: (){
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>MyHomePage(title: "")));
          }, child: Text("SIGN OUT",style: TextStyle(color: Colors.red,fontWeight: FontWeight.w800),)),
          SizedBox(width: 10,)
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                        onTap: (){
                            Navigator.push(context,MaterialPageRoute(builder: (_)=>Update(email: "", name: "",
                                isemail: false)));
                        },
                        child: Text("Ayusman Samasi",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 17),)),
                    SizedBox(height: 10,),
                    Text("Member Since : Sept 2025",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400),)
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
          Text("   Your Details",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),),
          ListTile(
            onTap: (){
              Navigator.push(context,MaterialPageRoute(builder: (_)=>Update(email: "", name: "",
                  isemail: true)));
            },
            leading: Icon(Icons.mail,color: Colors.grey,),
            title: Text("hariswarsamasi@gmail.com"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Divider(),
          ),
          ListTile(
            leading: Icon(Icons.call,color: Colors.grey,),
            title: Text(strreturn()),
          ),

        ],
      ),
    );
  }
   String strreturn(){
     try{
       String phone = FirebaseAuth.instance.currentUser!.phoneNumber??"+911111111111";
       return phone.substring(0,2)+"-"+phone.substring(2,-1);
     }catch(e){
       return "+91-1111111111";
     }
   }
}
