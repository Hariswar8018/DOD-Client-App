





import 'package:dod/global.dart';
import 'package:dod/second/book.dart';
import 'package:dod/second/book_daily.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as df;
import 'package:map_location_picker/map_location_picker.dart' as dk;
import 'package:shared_preferences/shared_preferences.dart';
import '../main/googlemap.dart';
import '../return_functions/position.dart' ;



class Location extends StatefulWidget {
   Location({super.key});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  List<String> filteredPlaces = [];

  @override
  void initState() {
    super.initState();
    controller.addListener(_onSearchChanged);
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
        title: Text("Choose Your Location",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
      ),
      body: Column(
        children: [
          SizedBox(height: 15),
          Center(
            child: Container(
              width: w - 10,
              height: 45,
              decoration: BoxDecoration(
                color: Global.grey,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  SizedBox(width: 15),
                  Icon(Icons.location_on),
                  SizedBox(width: 15),
                  Expanded(
                    child: TextFormField(
                      controller: controller,
                      onChanged: (String str){
                        _onSearchChanged();
                      },
                      onSaved: (value){
                        _onSearchChanged();
                      },
                      decoration: InputDecoration(
                        hintText: "Enter 4 letters to start searching",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: filteredPlaces.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredPlaces[index]),
                  onTap: () async {
                    double lat = await latitute(filteredPlaces[index]);
                    double lon = await longitude(filteredPlaces[index]);
                    Global.mylocation=filteredPlaces[index];
                    setState(() {
                      Global.mylocation=filteredPlaces[index];
                      Global.mylat = lat;
                      Global.mylong = lon;
                    });
                    Global.mylocation=filteredPlaces[index];
                    Navigator.pop(context,filteredPlaces[index]);
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
              dk.GeocodingResult? result = await Navigator.push(
                  context, MaterialPageRoute(builder: (_) => Position()));
              if (result == null) {
                return;
              }
              setState(() async {
                Global.mylocation=result.formattedAddress!;
                Global.mylat = await latitute(result.formattedAddress.toString());
              });
              Navigator.pop(context,result.formattedAddress!);
            }catch(e){
              Send.message(context, "$e", false);
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

  Future<double> latitute(String str) async {
    List<df.Location> locations = await df.locationFromAddress(str);
    return locations.first.latitude;
  }
  Future<double> longitude(String str) async {
    List<df.Location> locations = await df.locationFromAddress(str);
    return locations.first.longitude;
  }




  TextEditingController controller=TextEditingController();
}
