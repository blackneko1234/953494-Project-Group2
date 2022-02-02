import 'dart:async';
import 'package:http/http.dart' as http;

class CovidApi {

  // get all albums data
  Future<http.Response> fetchCovid() {
    return http.get(Uri.https("api.covid19api.com","/dayone/country/thailand/status/confirmed"));
  }
}