import 'dart:async';
import 'package:http/http.dart' as http;

class CovidApi {

  Future<http.Response> fetchCovid() {
    return http.get(Uri.https("covid19.ddc.moph.go.th","/api/Cases/today-cases-by-provinces"));
  }
}