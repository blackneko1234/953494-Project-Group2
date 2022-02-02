class Covid {
  final String country;
  final String countryCode;
  final String lat;
  final String lon;
  final String status;
  final String date;
  final int caseid;

  Covid({
    required this.country,
    required this.countryCode,
    required this.lat,
    required this.lon,
    required this.status,
    required this.date,
    required this.caseid,
  });

  factory Covid.fromJson(Map<String, dynamic> json) {
    return Covid(
      country: json["Country"],
      countryCode: json["CountryCode"],
      lat: json["Lat"],
      lon: json["Lon"],
      status: json["Status"],
      date: json["Date"],
      caseid: json["Cases"]
    );
  }
}
