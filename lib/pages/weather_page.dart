import 'package:atmos/controllers/auth_controller.dart';
import 'package:atmos/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:atmos/pages/notfound_page.dart';
import 'package:atmos/services/weather_service.dart';

import '../models/place_model.dart';
import '../models/weather_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  WeatherStatePage createState() => WeatherStatePage();
}

class WeatherStatePage extends State<WeatherPage> {
  final _weatherService = WeatherService('e6d9a94a6de8760c20e990b02a34dc9d');
  final GlobalKey<FormState> _searchLocation = GlobalKey<FormState>();
  Weather? _weather;
  List<Place>? _list;
  bool _isFormVisible = false;
  bool _hasError = false;

  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      throw Exception(
          'There was an issue while retrieving the weather data. Try again later: $e');
    }
  }

  void _fetchWeatherForLocation(String location) async {
    try {
      final weather = await _weatherService.getWeather(location);
      setState(() {
        _weather = weather;
        _isFormVisible = false; // Hide the form after selecting a location
        _list = null; // Clear the list of places
        _hasError = false;
      });
    } catch (e) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const NotFoundPage(
            errorMessage: 'Error fetching weather',
          ),
        ),
      );
    }
  }

  void _fetchSearchLocation(String location) async {
    try {
      final List<Place> list = await _weatherService.searchLocation(location);
      setState(() {
        _list = list;
        _isFormVisible = true; // Show the form after searching for a location
        _hasError = false;
      });
    } catch (e) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const NotFoundPage(errorMessage: 'Error fetching Locations')),
      );
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    switch (mainCondition?.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloudy_icon.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain_icon.json';
      case 'thunderstorm':
        return 'assets/thunder_icon.json';
      case 'clear':
        return 'assets/clear_icon.json';
      default:
        return 'assets/rain_icon.json';
    }
  }

  LinearGradient getBackground(String? mainCondition) {
    if (mainCondition == null) {
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color.fromARGB(255, 98, 212, 247).withOpacity(0.8),
          const Color.fromARGB(255, 98, 212, 247).withOpacity(0.8),
        ],
      );
    }
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color.fromARGB(255, 59, 121, 139).withOpacity(0.9),
            const Color.fromARGB(255, 75, 92, 97).withOpacity(0.7),
          ],
        );
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color.fromARGB(255, 25, 119, 143).withOpacity(0.5),
            const Color.fromARGB(255, 44, 56, 59).withOpacity(0.5),
          ],
        );
      case 'thunderstorm':
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color.fromARGB(255, 98, 212, 247).withOpacity(0.8),
            const Color.fromARGB(255, 182, 138, 18).withOpacity(0.8),
          ],
        );
      case 'clear':
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color.fromARGB(255, 236, 195, 12).withOpacity(0.8),
            const Color.fromARGB(255, 236, 195, 12).withOpacity(0.3),
            const Color.fromARGB(255, 104, 239, 248).withOpacity(0.3),
          ],
        );
      default:
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color.fromARGB(255, 236, 195, 12).withOpacity(0.8),
            const Color.fromARGB(255, 236, 195, 12).withOpacity(0.3),
            const Color.fromARGB(255, 104, 239, 248).withOpacity(0.3),
          ],
        );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: _hasError
                  ? getBackground("error")
                  : getBackground(_weather?.mainCondition),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _weather?.cityName ?? 'Loading...',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _weather?.mainCondition != null
                      ? SizedBox(
                          child: Lottie.asset(
                            getWeatherAnimation(_weather?.mainCondition),
                          ),
                        )
                      : Lottie.asset(
                          'assets/loading.json',
                          height: 100,
                          width: 300,
                        ),
                  Text(
                    '${_weather?.temperature.round()}°C',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _weather?.mainCondition ?? '',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 15,
            left: 20,
            child: FloatingActionButton(
              heroTag: 'sign_out',
              onPressed: () async {
                await AuthController.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              backgroundColor: const Color.fromARGB(108, 168, 255, 255),
              elevation: 1,
              child: const Icon(
                Icons.logout,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          Positioned.fill(
            child: Visibility(
              visible: _isFormVisible,
              child: Container(
                color: Colors.white.withOpacity(0.8),
                padding: const EdgeInsets.only(top: 50),
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 70),
                  itemCount: _list?.length ?? 0,
                  itemBuilder: (context, index) {
                    final place = _list![index];
                    return ListTile(
                      title: Text(place.name),
                      subtitle: Text(place.countryCode),
                      onTap: () {
                        _fetchWeatherForLocation(place.name);
                      },
                    );
                  },
                ),
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: _isFormVisible ? 1.0 : 0.0,
              child: Form(
                key: _searchLocation,
                child: TextFormField(
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black87),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusColor: Colors.white30,
                    hintText: 'Search another location',
                    hintStyle: const TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    contentPadding: const EdgeInsets.only(left: 15, bottom: 5),
                  ),
                  onFieldSubmitted: (value) {
                    _fetchSearchLocation(value);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(108, 168, 255, 255),
        elevation: 1,
        heroTag: 'search_locations',
        onPressed: () {
          setState(() {
            _isFormVisible = !_isFormVisible;
          });
        },
        splashColor: const Color.fromARGB(108, 168, 255, 255),
        child: const Icon(
          Icons.search,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
