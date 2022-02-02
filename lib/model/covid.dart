class Items {
  final String name;
  final String address;
  final double lat;
  final double lon;
  final String province;
  final String mobile;

  Items({
    required this.name,
    required this.address,
    required this.lat,
    required this.lon,
    required this.province,
    required this.mobile,
  });

  factory Items.fromJson(Map<String, dynamic> json) {
    return Items(
      name: json["n"],
      address: json["adr"],
      lat: json["lat"],
      lon: json["lng"],
      province: json["p"],
      mobile: json["mob"],
    );
  }
}

class Covid {
  final int limit;
  final int offset;
  final int nitems;
  final List<Items> items;

  Covid(
      {required this.limit,
      required this.offset,
      required this.nitems,
      required this.items});
  factory Covid.fromJson(Map<String, dynamic> json) {
    var list = json['items'] as List;
    List<Items> itemlist = list.map((e) => Items.fromJson(e)).toList();
    return Covid(
        limit: json['limit'],
        offset: json['offset'],
        nitems: json['nitems'],
        items: itemlist);
  }
}
