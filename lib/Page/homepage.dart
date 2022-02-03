// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:group2/service/covid_lab_api.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<dynamic> itemList = [];
  late Map<String, dynamic> res = {};
  late final CovidLabApi covidLabApi = CovidLabApi();

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
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemList.length,
      itemBuilder: (context, index) {
        var detail = itemList[index]["rm"];
        return Card(
          child: ExpansionTile(
            title: Text('${itemList[index]["n"]}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            subtitle: Text('Province: ${itemList[index]["p"]}'),
            children: [
              detail == ""
                  ? ListTile(
                      title: Text('Tel: ${itemList[index]["mob"]}'),
                      subtitle: Text(
                          '${itemList[index]["adr"]}\nDetails: ไม่พบข้อมูลในส่วนนี้ '),
                    )
                  : ListTile(
                      title: Text('Tel: ${itemList[index]["mob"]}'),
                      subtitle: Text(
                          '${itemList[index]["adr"]}\nDetails: ${itemList[index]["rm"]}'),
                    ),
            ],
          ),
        );
      },
    );
  }
}
