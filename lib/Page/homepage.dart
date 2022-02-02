import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:group2/model/covid.dart';
import 'package:group2/service/covid_api.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final CovidApi covidApi = CovidApi();
  late List<Covid> allCovid = [];

  Future<String?> getAllCovid() async {
    var response = await covidApi.fetchCovid();
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
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: allCovid.length,
        itemBuilder: (context,index){
          final item = allCovid[index];
          return Card(
            child: ListTile(
              subtitle: Text('${item.caseid}'),
              title: Text('${item.country}'),
            ),
          );
        },
      ),
    );
  }
}
