
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DriverMapWidget extends StatefulWidget {
  final String driverId;
  final LatLng initialCameraPosition;

  const DriverMapWidget({
    Key? key,
    required this.driverId,
    required this.initialCameraPosition ,
  }) : super(key: key);

  @override
  State<DriverMapWidget> createState() => _DriverMapWidgetState();
}

class _DriverMapWidgetState extends State<DriverMapWidget> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Location _location = Location();

  GoogleMapController? _mapController;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _driverSub;
  StreamSubscription<LocationData>? _locationSub;

  Marker? _driverMarker;
  Marker? _userMarker;

  bool _permissionGranted = false;
  bool _serviceEnabled = false;

  static const String _driverMarkerId = 'driver';
  static const String _userMarkerId = 'user';

  @override
  void initState() {
    super.initState();
    _initLocationPermissionsAndListen();
    _listenToDriverLocation();
  }

  // Note: We DO NOT upload the user's location anywhere. We only read it locally.
  Future<void> _initLocationPermissionsAndListen() async {
    // Check service enabled
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    // Check permission
    PermissionStatus permission = await _location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await _location.requestPermission();
    }

    _permissionGranted = permission == PermissionStatus.granted ||
        permission == PermissionStatus.grantedLimited;

    if (!_permissionGranted) return;

    // Get initial location once
    try {
      final loc = await _location.getLocation();
      _updateUserMarker(loc);
      _animateToIfControllerReady(LatLng(loc.latitude!, loc.longitude!));
    } catch (e) {
    }

    // Subscribe to location changes (local only)
    _locationSub = _location.onLocationChanged.listen((LocationData newLoc) {
      _updateUserMarker(newLoc);
    });
  }

  void _updateUserMarker(LocationData loc) {
    if (loc.latitude == null || loc.longitude == null) return;
    final latLng = LatLng(loc.latitude!, loc.longitude!);

    final newMarker = Marker(
      markerId: const MarkerId(_userMarkerId),
      position: latLng,
      infoWindow: const InfoWindow(title: 'You'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );

    setState(() {
      _userMarker = newMarker;
    });
  }


  void _listenToDriverLocation() {
    final docRef = _firestore.collection('drivers').doc(widget.driverId);

    _driverSub = docRef
        .snapshots()
        .listen((DocumentSnapshot<Map<String, dynamic>> snap) {
      if (!snap.exists) {
        setState(() {
          _driverMarker = null;
        });
        return;
      }

      final data = snap.data();
      if (data == null) return;

      final lat = (data['lat'] as num?)?.toDouble();
      final lng = (data['lng'] as num?)?.toDouble();
      final bearing = (data['bearing'] as num?)?.toDouble();

      if (lat == null || lng == null) return;

      final pos = LatLng(lat, lng);

      final newDriverMarker = Marker(
        markerId: const MarkerId(_driverMarkerId),
        position: pos,
        rotation:  0.0,
        anchor: const Offset(0.5, 0.5),
        infoWindow: InfoWindow(title: 'Driver (${widget.driverId})'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );

      setState(() {
        _driverMarker = newDriverMarker;
      });

      // Optional: animate camera to driver when changed (comment out if undesired)
      _animateToIfControllerReady(pos);
    }, onError: (err) {
      // handle listener error: maybe log or show a snackbar
      debugPrint('Driver location listener error: $err');
    });
  }

  Future<void> _animateToIfControllerReady(LatLng pos) async {
    if (_mapController != null) {
      try {
        await _mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: pos, zoom: 15.0),
          ),
        );
      } catch (_) {
        // ignore animation errors
      }
    }
  }

  @override
  void dispose() {
    _driverSub?.cancel();
    _locationSub?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  Set<Marker> _buildMarkers() {
    final markers = <Marker>{};
    if (_userMarker != null) markers.add(_userMarker!);
    if (_driverMarker != null) markers.add(_driverMarker!);
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: widget.initialCameraPosition,
          zoom: 5.0,
        ),
        onMapCreated: (controller) {
          _mapController = controller;
        },
        markers: _buildMarkers(),
        myLocationEnabled: _permissionGranted, // shows the blue dot if permission given
        myLocationButtonEnabled: true,
        compassEnabled: true,
        zoomControlsEnabled: false,
      ),
    );
  }
}
