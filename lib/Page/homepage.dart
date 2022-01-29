// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:group2/Page/mappage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("COVID-CHID-SAI"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MapPage()));
          },
          backgroundColor: Color(0xFF48a3e2),
          child: Icon(
            Icons.map,
            color: Colors.white,
          ),
        ));
  }
}
