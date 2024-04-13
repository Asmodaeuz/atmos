import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:atmos/models/place_model.dart';

import '../models/weather_model.dart';

class WeatherService {
  static const baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  static const geocodeUrl = 'https://api.openweathermap.org/geo/1.0/reverse';
  static const searchURL = 'https://geocoding-api.open-meteo.com/v1/search';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http
        .get(Uri.parse('$baseUrl?q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          "There was an issue while retrieving the weather data. Try again later");
    }
  }

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    final response = await http.get(Uri.parse(
        '$geocodeUrl?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey'));
    List<dynamic> data = jsonDecode(response.body);

    String? city = data[0]['name'];

    return city ?? "";
  }

  Future<List<Place>> searchLocation(String place) async {
    final response = await http.get(Uri.parse('$searchURL?name=$place'));
    final Map<String, dynamic> fullResponse = Map.from(jsonDecode(response.body));
    fullResponse.remove("generationtime_ms");
    List<Place> data = (fullResponse['results'] as List)
        .map((json) => Place.fromJson(json as Map<String, dynamic>))
        .toList();
    return data;
  }
}
