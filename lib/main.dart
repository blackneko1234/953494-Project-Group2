// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:group2/Page/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'COVID CHID-SAI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      home: MyHomePage(),
    );
  }
}
