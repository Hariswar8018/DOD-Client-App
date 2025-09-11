import 'dart:async';

import 'package:dod/login/locationpermission.dart';
import 'package:dod/login/onboarding.dart';
import 'package:dod/main/navigation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DOD',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void initState(){
    if(widget.title.isNotEmpty){
      Timer(Duration(seconds: 3),(){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>Onboarding()));
      });
    }else{
      Timer(Duration(seconds: 3),(){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>LocationPermission()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(height: 110,),
          Spacer(),
          Center(child: Image.asset("assets/logo_full.jpg",width: MediaQuery.of(context).size.width,)),
          Spacer(),
          Image.asset("assets/security.png",height: 30,),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text("Trusted by",style: TextStyle(color: Colors.white,fontSize: 17),),
          ),
          Text("70,000+ Car Owners",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w800),),
          SizedBox(height: 50,),
        ],
      ),
    );
  }
}
