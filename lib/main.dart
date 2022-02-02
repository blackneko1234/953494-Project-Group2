// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'Page/homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'COVID CHID-SAI',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const MyHomePage(title: 'All of Covid-list API'),
    );
  }
}
