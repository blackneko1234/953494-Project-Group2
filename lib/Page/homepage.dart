// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, invalid_use_of_protected_member
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:group2/service/covid_lab_api.dart';
import 'package:permission_handler/permission_handler.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _debouncer = Debouncer();
  late List<dynamic> itemList = [];
  late List<dynamic> uitemList = [];
  late Map<String, dynamic> res = {};
  late final CovidLabApi covidLabApi = CovidLabApi();

  Future<List> getAllCovid() async {
    var response = await covidLabApi.fetchCovidLab();
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }
    res = json.decode(utf8.decode(response.bodyBytes.toList()));
    itemList = res["items"];
    return itemList;
  }

  @override
  void initState() {
    super.initState();
    getAllCovid().then((subjectFromServer) {
      setState(() {
        uitemList = subjectFromServer;
        itemList = uitemList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    try {
      /* return ListView.builder(
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
      ); */
      return Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(15),
            child: TextField(
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ),
                ),
                suffixIcon: InkWell(
                  child: Icon(Icons.search),
                ),
                contentPadding: EdgeInsets.all(15.0),
                hintText: 'Search ',
              ),
              onChanged: (string) {
                _debouncer.run(() {
                  setState(() {
                    itemList = uitemList
                        .where(
                          (u) => (u["n"].toLowerCase().contains(
                                string.toLowerCase(),
                              )),
                        )
                        .toList();
                  });
                });
              },
            ),
          ),
          Expanded(
              child: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            padding: EdgeInsets.all(5),
            itemCount: itemList.length,
            itemBuilder: (context, index) {
              var detail = itemList[index]["rm"];
              return Card(
                child: ExpansionTile(
                  title: Text('${itemList[index]["n"]}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
          ))
        ],
      );
    } catch (e) {
      return Center(child: CircularProgressIndicator());
    }
  }
}

class Debouncer {
  int? milliseconds;
  VoidCallback? action;
  Timer? timer;

  run(VoidCallback action) {
    if (null != timer) {
      timer!.cancel();
    }
    timer = Timer(
      Duration(milliseconds: Duration.millisecondsPerSecond),
      action,
    );
  }
}
