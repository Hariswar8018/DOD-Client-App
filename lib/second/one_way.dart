


import 'package:dod/global.dart';
import 'package:dod/second/book.dart';
import 'package:dod/second/book_daily.dart';
import 'package:dod/second/shedule_book_confirm.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:map_location_picker/map_location_picker.dart' as dk;
import 'package:shared_preferences/shared_preferences.dart';
import '../return_functions/position.dart' ;
import 'package:dod/return_functions/location.dart' as jh;

class One_Way extends StatefulWidget {
  const One_Way({super.key,required this.dateTime,required this.i});

  final DateTime dateTime;final int i ;
  @override
  State<One_Way> createState() => _One_WayState();
}

class _One_WayState extends State<One_Way> {

  bool on=false;
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
          title: Text(widget.i==0?"One Way":(widget.i==1?"Round Trip":(widget.i==2?"OutStation":"Daily Drivers")),style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
        ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          on?LinearProgressIndicator():SizedBox(),
          SizedBox(height: 10,),
          Center(
            child: Card(
              color: Colors.white,
              child: Container(
                width: w-20,
                height: 150,
                child: Row(
                  children: [
                    SizedBox(width: 20,),
                    Container(
                      width: 10,
                      height: 110,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.green,
                            radius: 6,
                          ),
                          Container(
                            width: 2,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(5)
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.red,
                            radius: 6,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 15,),
                    Container(
                      width: w-15-20-20-20,
                      height: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap:() async {
                              String s = await Navigator.push(context, MaterialPageRoute(builder: (_)=>jh.Location()));
                              setState(() {
                                str=s;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text("$str",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 14),),
                            ),
                          ),
                          SizedBox(height: 14,),
                          Container(
                            width: w-15-20-20-20-15,
                            height: 2,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(15)
                            ),
                          ),
                          SizedBox(height: 2,),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: TextFormField(
                              controller: controller,
                              style: TextStyle(fontWeight: FontWeight.w700,fontSize: 14),
                              decoration: InputDecoration(
                                hintText: "Type atleast 4 letter to Search",
                                border: InputBorder.none,   // Removes the border
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                contentPadding: EdgeInsets.zero, // Optional: removes extra padding
                              ),
                            ),
                          )

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
          Expanded(
            child: ListView.builder(
              itemCount: filteredPlaces.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredPlaces[index]),
                  onTap: () async {
                    setState(() {
                      on=true;
                    });
                    try {
                      controller.text = filteredPlaces[index];
                      sets(filteredPlaces[index]);
                      double lat1 = await latitute(str);
                      double lom1 = await longitude(str);
                      double lat2 = await latitute(controller.text);
                      double lon2 = await longitude(controller.text);
                      if(widget.i==3){
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>Daily_Driver(pickup: str, drop: controller.text,)));
                      }else{
                        Navigator.push(context, MaterialPageRoute(builder: (_) =>
                            Book_OneWay(str: str,
                              str2: controller.text,
                              lat1: lat1,
                              lon1: lom1,
                              lat2: lat2,
                              lon2: lon2,
                              dateTime:widget.dateTime, type: widget.i==0?"One Way":(widget.i==1?"Round Trip":(widget.i==2?"OutStation":"Daily Drivers")),
                            )));
                      }
                      setState(() {
                        on=false;
                      });
                    }catch(e){
                      setState(() {
                        on=false;
                      });
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
      persistentFooterButtons: [
        InkWell(
          onTap: () async {
            try {
              dk.GeocodingResult? result  = await Navigator.push(context,MaterialPageRoute(builder: (_)=>Position()));
              if( result == null ){
                return ;
              }
              setState(() {
                on=true;
                controller.text=result.formattedAddress??"";
              });
              double lat1 = await latitute(str);
              double lom1 = await longitude(str);
              double lat2 = result.geometry!.location.lat;
              double lon2 = result.geometry!.location.lng;

              if(widget.i==3){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>Daily_Driver(pickup: str, drop: result.formattedAddress??"",)));
              }else{
                Navigator.push(context, MaterialPageRoute(builder: (_) =>
                    Book_OneWay(str: str,
                      str2: result.formattedAddress??"",
                      lat1: lat1,
                      lon1: lom1,
                      lat2: lat2,
                      lon2: lon2,
                      dateTime:widget.dateTime, type: widget.i==0?"One Way":(widget.i==1?"Round Trip":(widget.i==2?"OutStation":"Daily Drivers")),
                    )));                      }
              setState(() {
                on=false;
              });
            }catch(e){
              setState(() {
                on=false;
              });
            }
          },
          child: Container(
            width: w-10,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_location,color: Colors.green,),
                SizedBox(width: 7,),
                Text("Locate on the Map",style: TextStyle(fontWeight: FontWeight.w800,color: Colors.white),)
              ],
            ),
          ),
        )
      ],
    );
  }

  Future<void> sets(String str) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("History",str)??"NA";
  }

  Future<double> latitute(String str) async {
    List<Location> locations = await locationFromAddress(str);
    return locations.first.latitude;
  }
  Future<double> longitude(String str) async {
    List<Location> locations = await locationFromAddress(str);
    return locations.first.longitude;
  }

  String str = Global.mylocation!;

  List<String> filteredPlaces = [];

  @override
  void initState() {
    super.initState();
    controller.addListener(_onSearchChanged);
    str= Global.mylocation;
  }

  void _onSearchChanged() {
    String query = controller.text.toLowerCase();
    if (query.length >= 1) {
      setState(() {
        filteredPlaces = Global.places
            .where((place) => place.toLowerCase().contains(query))
            .toList();
      });
    } else {
      setState(() {
        filteredPlaces.clear();
      });
    }
  }
  TextEditingController controller=TextEditingController();
}
