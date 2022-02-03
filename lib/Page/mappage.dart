// ignore_for_file: unused_import, prefer_final_fields, unused_field, prefer_const_constructors, unnecessary_new, unnecessary_null_comparison, unused_local_variable, avoid_print, prefer_typing_uninitialized_variables, prefer_collection_literals, use_key_in_widget_constructors, invalid_use_of_protected_member

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:group2/main.dart';
import 'package:group2/service/covid_lab_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapPage extends StatefulWidget {
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
  late bool destination;
  Future<String?> getAllCovid() async {
    var response = await covidLabApi.fetchCovidLab();
    var status = await Permission.location.status;
    if (!status.isGranted) {
      destination = false;
    } else {
      destination = true;
    }
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
  }

  @override
  Widget build(BuildContext context) {
    try {
      return destination == true
          ? GoogleMap(
              markers: getmarkers(),
              initialCameraPosition: CameraPosition(
                target: currentLatLng,
                zoom: 15,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              myLocationEnabled: true,
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Please allow location to use the map",
                    style: TextStyle(fontSize: 20),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.blue,
                    ),
                    onPressed: () async {
                      await Permission.location.request();
                      if (await Permission.location.request().isGranted) {
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (context) => MainPage()));
                      }
                    },
                    child: Text('Click here to allow location',
                        style: TextStyle(fontSize: 15)),
                  )
                ],
              ),
            );
    } catch (e) {
      return Center(child: CircularProgressIndicator());
    }
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
                snippet: '${itemList[index]["adr"]}'),
            icon: BitmapDescriptor.defaultMarker,
          ));
        }
      }
    });
    return markers;
  }
}
