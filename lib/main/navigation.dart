import 'package:dod/api.dart';
import 'package:dod/global.dart';
import 'package:dod/return_functions/location.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_widget/google_maps_widget.dart';


class Navigation extends StatefulWidget {
   Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  final mapsWidgetController = GlobalKey<GoogleMapsWidgetState>();


  void initState(){

  }

  late double mylat=40.484000837597925,mylong=-3.369978368282318;


  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            width: w,height: h,
            child: Column(
              children: [
                Container(
                  width: w,
                  height: 90,
                  color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        InkWell(
                            onTap: (){

                            },
                            child: Text("Hire Drivers",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w800,color: Colors.white),)),
                        Spacer(),
                        Text("41 MINS AWAY",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w800,color: Colors.white),)
                      ],
                    ),
                  ),
                ),
                Container(
                  width: w,
                  height: 460,
                  color: Global.grey,
                  child: Stack(
                    children: [
                      Container(
                        width: w,
                        height: 220,
                        child:  GoogleMapsWidget(
                            apiKey: Api.googlemap,
                            key: mapsWidgetController,
                            sourceLatLng: LatLng(
                              40.484000837597925,
                              -3.369978368282318,
                            ),
                            destinationLatLng: LatLng(
                              40.48017307700204,
                              -1.3618026599287987,
                            ),
                            updatePolylinesOnDriverLocUpdate: true,
                            onPolylineUpdate: (_) {
                              print("Polyline updated");
                            },
                            // mock stream
                            totalTimeCallback: (time) => print(time),
                            totalDistanceCallback: (distance) => print(distance),
                          ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 210.0),
                        child: Column(
                          children: [
                            Center(
                              child: Container(
                                width: w-20,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(3)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    a(w,Icon(Icons.arrow_right_alt,size: 30,),"One Way",0),
                                    a(w,Icon(
                                      CupertinoIcons.arrow_2_squarepath,size: 30,
                                    ),"Round Trip",1),
                                    a(w,Icon(
                                      CupertinoIcons.bus,size: 30,
                                    ),"Outstation",2),
                                    a(w,Icon(Icons.calendar_month,size: 30),"Daily",3),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10,),
                            Center(
                              child: Container(
                                width: w - 20,
                                height: 140,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(height: 7),
                                    Container(
                                      width: w - 40,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        color: Global.grey,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(width: 15),
                                          Icon(Icons.search),
                                          SizedBox(width: 15),
                                          Expanded(
                                            child: TextFormField(
                                              controller: controller,
                                              decoration: InputDecoration(
                                                hintText: i==1?"Where from ?":"Where to ?",
                                                hintStyle: TextStyle(fontWeight: FontWeight.w700,color: Colors.grey),
                                                border: InputBorder.none, // removes underline
                                                contentPadding: EdgeInsets.symmetric(vertical: 10),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 15),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Row(
                                      children: [
                                        SizedBox(width: 15),
                                        Icon(Icons.location_searching_sharp, color: Colors.green),
                                        SizedBox(width: 10),
                                        Text("My Location : ", style: TextStyle(color: Colors.green)),
                                        Text(
                                          mylocation.length > 27 ? mylocation.substring(0, 27) + '...' : mylocation,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 3),
                                    Row(
                                      children: [
                                        SizedBox(width: 15),
                                        Icon(Icons.history, color: Colors.grey),
                                        SizedBox(width: 10),
                                        Text("Chennai, India", style: TextStyle(color: Colors.grey)),
                                      ],
                                    ),
                                    SizedBox(height: 3),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 75.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: w-40,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Global.grey,
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child: InkWell(
                    onTap: () async {
                      String s =await Navigator.push(context, MaterialPageRoute(builder: (_)=>Location()));
                      if(s!=null){
                        setState(() {
                          mylocation=s;
                        });
                      }
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 15),
                        Icon(Icons.location_on),
                        SizedBox(width: 15),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              String s =await Navigator.push(context, MaterialPageRoute(builder: (_)=>Location()));
                              if(s!=null){
                                setState(() {
                                  mylocation=s;
                                });
                              }
                            },
                            child: TextFormField(
                              controller: controller,
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: mylocation,
                                border: InputBorder.none, // removes underline
                                contentPadding: EdgeInsets.symmetric(vertical: 10),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  String mylocation="";

  TextEditingController controller=TextEditingController();

  Widget a(double w,Widget icon,String str,int u)=>InkWell(
    onTap: (){
      setState(() {
        i=u;
      });
    },
    child: Container(
      width: w/4-10,
      height: 80,
      child: Column(
        children: [
          Spacer(),
          SizedBox(height: 3,),
          icon,
          SizedBox(height: 3,),
          Text(str,style: TextStyle(fontWeight: i==u?FontWeight.w400:FontWeight.w300,color:i==u?Colors.black: Colors.grey),),
          Spacer(),
          Container(
            width: w/4-10,
            height: 4,
            decoration: BoxDecoration(
                color: i==u?Colors.green:Colors.white,
                borderRadius: BorderRadius.circular(10)
            ),
          )
        ],
      ),
    ),
  );

  int i = 0;
}
