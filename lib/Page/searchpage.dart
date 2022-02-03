// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_const_constructors
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:group2/service/covid_lab_api.dart';

class SearchPage extends StatefulWidget {
  SearchPage() : super();

  @override
  SearchPageState createState() => SearchPageState();
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

class SearchPageState extends State<SearchPage> {
  final _debouncer = Debouncer();

  List<Subject> ulist = [];
  List<Subject> userLists = [];
  //API call for All Subject List
  late List<Subject> itemList = [];
  late Map<String, dynamic> res = {};
  late final CovidLabApi covidLabApi = CovidLabApi();

  Future<String?> getAllCovid() async {
    var response = await covidLabApi.fetchCovidLab();
    setState(() {
      res = json.decode(utf8.decode(response.bodyBytes.toList()));
      itemList = res["items"];
    });
  }
  
  Future<List<Subject>> getAllulistList() async {
    try {
        return itemList;
    } catch (e) {
        throw Exception(e.toString());
    }
  }

  // static List<Subject> parseAgents(String responseBody) {
  //   final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  //   return parsed.map<Subject>((json) => Subject.fromJson(json)).toList();
  // }

  @override
  void initState() {
    super.initState();
    getAllCovid();
    getAllulistList().then((subjectFromServer) {
      setState(() {
        ulist = subjectFromServer;
        userLists = ulist;
      });
    });
  }

  //Main Widget
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        //Search Bar to List of typed Subject
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
                  userLists = ulist
                      .where(
                        (u) => (u.text.toLowerCase().contains(
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
            itemCount: userLists.length,
            itemBuilder: (BuildContext context, int index) {
              var detail = userLists[index].rm;
              return Card(
                child: ExpansionTile(
                  title: Text(
                    userLists[index].n,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                  ),
                  subtitle: Text('Province: ${userLists[index].p}'),
                  children: [
                    detail == ""
                    ? ListTile(
                        title: Text('Tel: ${userLists[index].mob}'),
                        subtitle: Text(
                          '${userLists[index].adr}\nDetails: ไม่พบข้อมูลในส่วนนี้ '),
                      )
                    : ListTile(
                        title: Text('Tel: ${userLists[index].mob}'),
                        subtitle: Text(
                          '${userLists[index].adr}\nDetails: ${userLists[index].rm}'),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

//Declare Subject class for json data or parameters of json string/data
//Class For Subject
class Subject {
  var rm;
  var n;
  var p;
  var mob;
  var adr;

  Subject({
    required this.rm,
    required this.n,
    required this.p,
    required this.mob,
    required this.adr,
  });

  factory Subject.fromJson(Map<dynamic, dynamic> json) {
    return Subject(
      rm: json['rm'],
      n: json['n'],
      p: json['p'],
      mob: json['mob'],
      adr: json['adr'],
    );
  }
}
