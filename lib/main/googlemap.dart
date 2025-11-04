import 'package:flutter/material.dart';

import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:dod/api.dart';
import 'package:dod/global.dart';
import 'package:dod/main/googlemap.dart';
import 'package:dod/main/second/offers.dart';
import 'package:dod/main/second/refer.dart';
import 'package:dod/return_functions/location.dart';
import 'package:dod/second/one_way.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' show Placemark, placemarkFromCoordinates;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_widget/google_maps_widget.dart';
import 'package:location/location.dart' as lk;
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login/bloc/login/view.dart';
import '../model/booking_response.dart';
import '../model/ordermodel.dart' show OrderModel;
import '../second/book_daily.dart' show Daily;
import '../second/pages/my_bookings.dart';

class GoogleMap3 extends StatefulWidget {
  const GoogleMap3({super.key});

  @override
  State<GoogleMap3> createState() => _GoogleMapState();
}

class _GoogleMapState extends State<GoogleMap3> {
  late Future<LatLng> _futureLocation;

  @override
  void initState() {
    super.initState();
    _futureLocation = getCurrentLocation();
  }

  static Future<LatLng> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception("Location permission denied");
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception("Location permission permanently denied");
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks.first;

      String mynew =
          "${place.subLocality ?? ''}, ${place.street ?? ''}, ${place.subAdministrativeArea ?? ''}, "
          "${place.locality ?? ''}, ${place.postalCode ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}";

      Global.mylocation = mynew;
      Global.mylat = position.latitude;
      Global.mylong = position.longitude;

      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      print("Error getting location: $e");
      throw Exception("Failed to fetch location");
    }
  }


  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Container(
      width: w,
      height: 220,
      child: FutureBuilder<LatLng>(
        future: _futureLocation,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.grey.shade100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.network(width: w/3,"https://logos-world.net/wp-content/uploads/2022/01/Google-Maps-Logo.png"),
                  Text("Loading Google Map.... Please Wait"),
                ],
              ),
            );
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Container(
              color: Colors.grey.shade100,
              child: const Center(child: Text("Location not available")),
            );
          }
          final LatLng location = snapshot.data!;
          return GoogleMapsWidget(
            apiKey: Api.googlemap,
            key: mapsWidgetController,
            sourceLatLng: location,
            destinationLatLng: location,
            totalTimeCallback: (time) => print(time),
              defaultCameraZoom: 4.0,
            totalDistanceCallback: (distance) => print(distance),
          );
        },
      ),
    );
  }
  final mapsWidgetController = GlobalKey<GoogleMapsWidgetState>();

}
