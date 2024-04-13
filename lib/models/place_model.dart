class Place {
  final String name;
  final String countryCode;
  final double latitude;
  final double longitude;

  Place({
    required this.name,
    required this.countryCode,
    required this.latitude,
    required this.longitude,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      name: json['name'],
      countryCode: json['country_code'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
