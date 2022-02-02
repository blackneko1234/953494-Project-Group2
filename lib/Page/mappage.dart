// ignore_for_file: unused_import, prefer_final_fields, unused_field, prefer_const_constructors, unnecessary_new, unnecessary_null_comparison, unused_local_variable, avoid_print, prefer_typing_uninitialized_variables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();
  late LatLng currentLatLng;

  @override
  void initState() {
    super.initState();
    Geolocator.getCurrentPosition().then((currLocation) {
      setState(() {
        currentLatLng =
            new LatLng(currLocation.latitude, currLocation.longitude);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("COVID-CHID-SAI"),
      ),
      body: currentLatLng == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: currentLatLng,
                zoom: 15,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              myLocationEnabled: true,
            ),
    );
  }
}
