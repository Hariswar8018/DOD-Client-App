import 'package:dod/api.dart';
import 'package:dod/global.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_widget/google_maps_widget.dart';
import 'package:place_picker_google/place_picker_google.dart';
import 'package:map_location_picker/map_location_picker.dart';

class Position extends StatefulWidget {
   Position({super.key});

  @override
  State<Position> createState() => _PositionState();
}

class _PositionState extends State<Position> {
  LatLng? _pickedLocation;

  String _formattedAddress = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        centerTitle: true,
        title: Text("Select Location",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
      ),
      body: MapLocationPicker(
        key: Key(Api.googlemap),
        searchConfig: SearchConfig(
          apiKey: "",

        ),
        geoCodingConfig: GeoCodingConfig(apiKey: Api.googlemap,),
        config: MapLocationPickerConfig(
          initialPosition: LatLng(Global.mylat, Global.mylong),
        ),
      ),
      persistentFooterButtons: [],
    );
  }
}
