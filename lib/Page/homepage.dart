// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, prefer_const_literals_to_create_immutables
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:group2/Page/mappage.dart';
import 'package:group2/service/covid_lab_api.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final CovidLabApi covidLabApi = CovidLabApi();
  late Map<String, dynamic> res = {};
  late List<dynamic> itemList = [];
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
    return Scaffold(
        appBar: AppBar(
          title: Text("COVID CHID-SAI"),
        ),
        body: Column(
          children: [
            /* Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
              child: TextField(
                style: TextStyle(fontSize: 14.0, height: 0.5),
                onChanged: (value) {},
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ), */
            Expanded(
              child: ListView.builder(
                itemCount: itemList.length,
                itemBuilder: (context, index) {
                  var detail = itemList[index]["rm"];
                  return Card(
                    child: ExpansionTile(
                      title: Text('${itemList[index]["n"]}'),
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
              ),
            )
          ],
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
