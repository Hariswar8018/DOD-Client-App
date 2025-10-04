import 'dart:async';

import 'package:dod/login/bloc/login/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../main/navigation.dart';

class LocationPermission extends StatefulWidget {
  LocationPermission({super.key});

  @override
  State<LocationPermission> createState() => _LocationPermissionState();
}

class _LocationPermissionState extends State<LocationPermission> {

  Future<void> requestLocationPermission(BuildContext context) async {
    var status = await Permission.location.request();

    if (status.isGranted) {
      _navigateToNextScreen();
    } else if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location Permission Denied")),
      );
    } else if (status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location Permission Permanently Denied")),
      );
      openAppSettings();
    }
  }

  Timer? _timer; // Store the timer

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState(){
    requestLocationPermission(context);
    startTimer();
  }
  Future<void> startTimer() async {
    var status = await Permission.locationWhenInUse.status;

    if (status.isGranted) {
      _navigateToNextScreen();
      return;
    }

    // Start periodic timer only if permission is not granted yet
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      var currentStatus = await Permission.locationWhenInUse.status;
      if (currentStatus.isGranted) {
        timer.cancel(); // Cancel timer when permission is granted
        _navigateToNextScreen();
      }
    });
  }

  void _navigateToNextScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => BlocProvider(
          create: (_) => AuthCubit()..registerOrLogin(),
          child: Navigation())),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 110,),
          Spacer(),
          Container(
            width: MediaQuery.of(context).size.width-70,
            height: 80,
            color: Color(0xff586e87),
            child: Icon(Icons.location_on_sharp,color: Colors.white,),
          ),
          InkWell(
            onTap: () async {
              await requestLocationPermission(context);
              startTimer();
            },
            child: Container(
              width: MediaQuery.of(context).size.width-70,
              height: 180,
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0,vertical: 8),
                    child: Text("We need the Location Permission to pin point your Current Location in Map",
                      style: TextStyle(fontWeight: FontWeight.w700,fontSize: 15),textAlign: TextAlign.center,),
                  ),
                  Text("You need to grant this Permission to continue",style: TextStyle(fontSize: 9),),
                  Spacer(),
                  Text("I AGREE",style: TextStyle(color: Color(0xff2D3E50),fontSize: 19),),
                  Spacer(),
                ],
              )
            ),
          ),
          Spacer(),
          Center(child: Image.asset("assets/security.png",height: 30,)),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text("Trusted by",style: TextStyle(color: Colors.white,fontSize: 17),),
            ),
          ),
          Center(child: Text("70,000+ Car Owners",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w800),)),
          SizedBox(height: 50,),
        ],
      ),
    );
  }
}
