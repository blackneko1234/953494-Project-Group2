import 'dart:async';
import 'package:http/http.dart' as http;

class CovidLabApi {
  Future<http.Response> fetchCovidLab() async {
    return await http
        .get(Uri.https("covid-lab-data.pages.dev", "/latest.json"));
    print(http.get(Uri.https("covid-lab-data.pages.dev", "/latest.json")));
  }
  
}
