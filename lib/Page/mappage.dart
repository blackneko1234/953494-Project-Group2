// ignore_for_file: unused_import, prefer_final_fields, unused_field, prefer_const_constructors, unnecessary_new, unnecessary_null_comparison, unused_local_variable, avoid_print, prefer_typing_uninitialized_variables, prefer_collection_literals

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:group2/service/covid_lab_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();
  late final CovidLabApi covidLabApi = CovidLabApi();
  final Set<Marker> markers = new Set();
  late Map<String, dynamic> res = {};
  late List<dynamic> itemList = [];
  static late LatLng currentLatLng;

  Future<String?> getAllCovid() async {
    var response = await covidLabApi.fetchCovidLab();
    setState(() {
      res = json.decode(utf8.decode(response.bodyBytes.toList()));
      itemList = res["items"];
    });
  }

  @override
  void initState() {
    super.initState();
    getAllCovid();
    Geolocator.getCurrentPosition().then((currLocation) {
      setState(() {
        currentLatLng =
            new LatLng(currLocation.latitude, currLocation.longitude);
      });
    });
    getmarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("COVID-CHID-SAI Nearby lab"),
      ),
      body: currentLatLng == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              markers: getmarkers(),
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

  Set<Marker> getmarkers() {
    setState(() {
      for (int index = 0; index < itemList.length; index++) {
        if (itemList[index]["lat"] is double &&
            itemList[index]["lng"] is double) {
          markers.add(Marker(
            markerId: MarkerId(currentLatLng.toString() + index.toString()),
            position: LatLng(itemList[index]["lat"], itemList[index]["lng"]),
            infoWindow: InfoWindow(
              title: '${itemList[index]["n"]}',
            ),
            icon: BitmapDescriptor.defaultMarker,
          ));
        }
      }
    });
    return markers;
  }
}
