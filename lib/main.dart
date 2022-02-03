// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, unused_field, prefer_final_fields, non_constant_identifier_names

import 'Page/mappage.dart';
import 'Page/homepage.dart';
import 'package:flutter/material.dart';

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
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final tabs = [MyHomePage(), MapPage()];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal.shade400,
          title: Text("COVID CHID-SAI Lab Finder"),
          leading: Image.asset("assets/logo.png"),
        ),
        body: tabs[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          items: [
            BottomNav("Home", Icon(Icons.home)),
            BottomNav("Map", Icon(Icons.map)),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.teal.shade400,
          unselectedItemColor: Colors.white,
          onTap: _onItemTapped,
        ));
  }
}

BottomNavigationBarItem BottomNav(String label, Icon icon) {
  return BottomNavigationBarItem(
    icon: icon,
    label: label,
    backgroundColor: Colors.black,
  );
}
