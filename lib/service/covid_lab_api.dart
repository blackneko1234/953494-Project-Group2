import 'dart:async';
import 'package:http/http.dart' as http;

class CovidLabApi {
  Future<http.Response> fetchCovidLab() {
    return http.get(Uri.https("covid-lab-data.pages.dev", "/latest.json"));
  }
}
