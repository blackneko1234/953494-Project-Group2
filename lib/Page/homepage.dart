// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, prefer_const_literals_to_create_immutables
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:group2/Page/mappage.dart';
import 'package:group2/model/covid.dart';
import 'package:group2/service/covid_lab_api.dart';
import 'package:group2/Page/searchpage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final CovidLabApi covidLabApi = CovidLabApi();
  late List<Covid> allCovid = [];
  int _currentIndex = 0;

  Future<String?> getAllCovid() async {
    var response = await covidLabApi.fetchCovidLab();
    setState(() {
      List res = json.decode(response.body);
      allCovid = res.map((covid) => Covid.fromJson(covid)).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getAllCovid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Covid Chid Sai"),
        ),
        body: ListView.builder(
          itemCount: allCovid.length,
          itemBuilder: (context, index) {
            final item = allCovid[index];
            return Card(
              child: ExpansionTile(
                title: Text('Country: ${item.items[0]}'),
                subtitle: Text('Cases:'),
                children: [
                  ListTile(
                    title: Text('${item.items[0]}'),
                    subtitle: Text('${item.items[0]}'),
                  ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MapPage()));
              },
              backgroundColor: Color(0xFF48a3e2),
              child: Icon(
                Icons.map,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Jobs()));
              },
              backgroundColor: Color(0xFF48a3e2),
              child: Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          ]
        )
    );
  }
}
