import 'package:dod/api.dart';
import 'package:dod/global.dart';
import 'package:dod/login/bloc/login/view.dart';
import 'package:dod/main.dart';
import 'package:dod/main/profile/update_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class User_Profile extends StatelessWidget {
   User_Profile({super.key});

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
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40,),
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
          SizedBox(height: 30,),
          Text("   Your Details",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),),
          SizedBox(height: 8),
          ListTile(
            onTap: (){
              Navigator.push(context,MaterialPageRoute(builder: (_)=>Update(email: "", name: "",
                  isemail: false)));
            },
            tileColor: Colors.white,
            leading: Icon(Icons.person,color: Colors.grey,),
            trailing: Icon(Icons.edit,color: Colors.red,size: 15,),
            title: Text(validateEmailString(UserModel.user.name)),
          ),
          ListTile(
            onTap: (){
              Navigator.push(context,MaterialPageRoute(builder: (_)=>Update(email: "", name: "",
                  isemail: true)));
            },
            trailing: Icon(Icons.edit,color: Colors.red,size: 15,),
            leading: Icon(Icons.mail,color: Colors.grey,),
            title: Text(validateEmailString(UserModel.user.email)),
          ),
          ListTile(
            tileColor: Colors.white,
            leading: Icon(Icons.call,color: Colors.grey,),
            title: Text("${UserModel.user.mobile}"),
          ),
          ListTile(
            leading: Icon(Icons.hiking,color: Colors.grey,),
            title: Text("Joined : ${formatDate(UserModel.user.createdAt.substring(0,10))}"),
          ),
          ListTile(
            tileColor: Colors.white,
            leading: Icon(Icons.accessibility_outlined,color: Colors.grey,),
            title: Text("My Customer ID : DOD${UserModel.user.id}"),
          ),
        ],
      ),
    );
  }
   String validateEmailString(String value) {
     if (value.toLowerCase().startsWith("num")) {
       return "No email address provided";
     }
     return value;
   }

   String strreturn(){
     try{
       String phone = FirebaseAuth.instance.currentUser!.phoneNumber??"+911111111111";
       return phone.substring(0,2)+"-"+phone.substring(2,-1);
     }catch(e){
       return "+91-1111111111";
     }
   }
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
