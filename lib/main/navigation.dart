import 'package:dio/dio.dart';
import 'package:dod/global.dart';
import 'package:dod/login/bloc/login/cubit.dart';
import 'package:dod/login/bloc/login/state.dart';
import 'package:dod/login/bloc/login/view.dart';
import 'package:dod/main/drivers.dart';
import 'package:dod/main/home.dart';
import 'package:dod/main/profile.dart';
import 'package:dod/model/usermodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shimmer/shimmer.dart';

import '../api.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {

  int currentTab=0;
  final Set screens ={
    Home(),
    Profile(),
  };
  
  void initState(){
    v();
  }
  
  v() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    print("Latitude: ${position.latitude}, Longitude: ${position.longitude}");
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    Placemark place = placemarks.first;
    String mynew = "${place.subLocality}, ${place.street}, ${place.subAdministrativeArea}, ${place.locality}, ${place.postalCode}, ${place.administrativeArea},${place.country}";
    setState(() {
      Global.mylocation=mynew;
      Global.mylat=position.latitude;
      Global.mylong=position.longitude;
    });

  }


  final PageStorageBucket bucket = PageStorageBucket();

  dynamic selected ;

  var heart = false;
  PageController controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  Widget currentScreen = Home();
  @override
  Widget build(BuildContext context){
    return BlocConsumer<AuthCubit,AuthState>(
        listener: (context,state) async {
          if(state is AuthFailure){
            setState(() {
              iserror=true;
              errortitle="Something Went Wrong !";
              errormessage="Please Logout and try again. If issue persist, Call Us \n ${state.error}";
            });
            Send.message(context, "${state.error}", false);
          }
          if(state is AuthSuccess){
            Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high,
            );

            print("Latitude: ${position.latitude}, Longitude: ${position.longitude}");
            List<Placemark> placemarks = await placemarkFromCoordinates(
              position.latitude,
              position.longitude,
            );

            Placemark place = placemarks.first;
            String mynew = "${place.subLocality}, ${place.street}, ${place.subAdministrativeArea}, ${place.locality}, ${place.postalCode}, ${place.administrativeArea},${place.country}";
            setState(() {
              Global.mylocation=mynew;
              Global.mylat=position.latitude;
              Global.mylong=position.longitude;
            });
            print("Token => ${state.userData.name}");
            setState(() {
              UserModel.user=state.userData;
            });
          }
        }, builder: ( context,  state) {
          if(state is AuthLoading){
            return LoadingScaffold();
          }
          return iserror? error(): WillPopScope(
              onWillPop: () async {
                // Show the alert dialog and wait for a result
                bool exit = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Exit App'),
                      content: Text('Are you sure you want to exit?'),
                      actions: [
                        ElevatedButton(
                          child: Text('No'),
                          onPressed: () {
                            // Return false to prevent the app from exiting
                            Navigator.of(context).pop(false);
                          },
                        ),
                        ElevatedButton(
                          child: Text('Yes'),
                          onPressed: () async {
                            // Return true to allow the app to exit
                            Navigator.of(context).pop(true);
                          },
                        ),
                      ],
                    );
                  },
                );

                // Return the result to handle the back button press
                return exit ?? false;
              },
              child: Scaffold(
                backgroundColor: Colors.white,
                body: PageStorage(
                  child: currentScreen,
                  bucket: bucket,
                ),
                bottomNavigationBar: BottomAppBar(
                  shape: CircularNotchedRectangle(),
                  notchMargin: 4, color: Colors.white, surfaceTintColor: Colors.white,
                  shadowColor:  Colors.white,
                  child: Container(
                    height: 20, color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MaterialButton(
                            minWidth: 25, onPressed: (){
                          setState(() {
                            currentScreen = Home();
                            currentTab = 0;
                          });
                        },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  CupertinoIcons.home,
                                  color: currentTab == 0? Colors.black : Colors.grey, size: 23,
                                ),
                                Text("Home", style: TextStyle(color: currentTab == 0?  Colors.black :Colors.grey, fontSize: 12))
                              ],
                            )
                        ),
                        MaterialButton(
                            minWidth: 25, onPressed: (){
                          setState(() {
                            currentScreen = Drivers();
                            currentTab = 3;
                          });
                        },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.two_wheeler,
                                  color: currentTab == 3? Colors.black:Colors.grey, size: 23,
                                ),
                                Text("Drivers", style: TextStyle(color: currentTab == 3? Colors.black:Colors.grey, fontSize: 12))
                              ],
                            )
                        ),
                        MaterialButton(
                            minWidth: 25, onPressed: (){
                          setState(() {
                            currentScreen = Profile();
                            currentTab = 4;
                          });
                        },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  CupertinoIcons.person,
                                  color: currentTab == 4? Colors.black:Colors.grey, size: 23,
                                ),
                                Text("User", style: TextStyle(color: currentTab == 4? Colors.black:Colors.grey, fontSize: 12))
                              ],
                            )
                        ),
                      ],
                    ),
                  ),
                ),
              ));
          },
    );
  }
  String errortitle="";
  String errormessage="";
  bool iserror = false;
  Widget error(){
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Color(0xff25252D),
      automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Image.network(width: 90,"https://www.shutterstock.com/image-vector/sad-red-car-cartoon-character-600nw-1969290883.jpg")),
          Center(child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(errortitle,style: TextStyle(fontSize: 19,fontWeight: FontWeight.w800),),
          )),
          Center(child: Text(errormessage))
        ],
      ),
    );
  }
}
class LoadingScaffold extends StatelessWidget {
   LoadingScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff25252D),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          children: [
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width-15,
                height: 290,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10,),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width-15,
                height: 110,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fake thumbnail
                  Container(
                    width: 80,
                    height: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 12),
                  // Fake text blocks
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 16, width: double.infinity, color: Colors.white),
                        const SizedBox(height: 8),
                        Container(height: 16, width: 150, color: Colors.white),
                        const SizedBox(height: 8),
                        Container(height: 16, width: 30, color: Colors.white),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fake thumbnail
                  Container(
                    width: 80,
                    height: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 12),
                  // Fake text blocks
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 16, width: double.infinity, color: Colors.white),
                        const SizedBox(height: 8),
                        Container(height: 16, width: 150, color: Colors.white),
                        const SizedBox(height: 8),
                        Container(height: 16, width: 30, color: Colors.white),
                      ],
                    ),
                  )
                ],
              ),
            ),


          ],
        )
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 4, color: Colors.white, surfaceTintColor: Colors.white,
        shadowColor:  Colors.white,
        child: Container(
          height: 20, color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                  minWidth: 25, onPressed: (){
                  currentTab = 0;
              },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.home,
                        color: currentTab == 0? Colors.black : Colors.grey, size: 23,
                      ),
                      Text("Home", style: TextStyle(color: currentTab == 0?  Colors.black :Colors.grey, fontSize: 12))
                    ],
                  )
              ),
              MaterialButton(
                  minWidth: 25, onPressed: (){

                  currentTab = 3;

              },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.two_wheeler,
                        color: currentTab == 3? Colors.black:Colors.grey, size: 23,
                      ),
                      Text("Drivers", style: TextStyle(color: currentTab == 3? Colors.black:Colors.grey, fontSize: 12))
                    ],
                  )
              ),
              MaterialButton(
                  minWidth: 25, onPressed: (){

                  currentTab = 4;
              },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.person,
                        color: currentTab == 4? Colors.black:Colors.grey, size: 23,
                      ),
                      Text("User", style: TextStyle(color: currentTab == 4? Colors.black:Colors.grey, fontSize: 12))
                    ],
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
  int currentTab = 0;
}
