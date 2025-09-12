import 'package:dod/api.dart';
import 'package:dod/global.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_widget/google_maps_widget.dart';
import 'package:place_picker_google/place_picker_google.dart';

class Position extends StatelessWidget {
  const Position({super.key});

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
      body: PlacePicker(
        apiKey: Api.googlemap,
        onPlacePicked: (LocationResult result) {
          debugPrint("Place picked: ${result.formattedAddress}");
        },
        initialLocation: LatLng(
          29.378586,
          47.990341,
        ),
        searchInputConfig: const SearchInputConfig(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          autofocus: false,
          textDirection: TextDirection.ltr,
        ),
        searchInputDecorationConfig: const SearchInputDecorationConfig(
          hintText: "Search for a building, street or ...",
        ),
      ),
    );
  }
}
