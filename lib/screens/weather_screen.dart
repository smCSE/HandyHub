import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // Import the intl package

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String apiKey = '442048514ca83783d1e0e1b4353dff66';
  String city = 'Dhaka'; // Default city
  dynamic weatherData;
  final TextEditingController _controller = TextEditingController();
  String cityTime = ''; // To store the city's time

  Future<void> fetchWeather(String cityName) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric'));
    if (response.statusCode == 200) {
      setState(() {
        weatherData = jsonDecode(response.body);
        int timezoneOffset =
            weatherData['timezone']; // Timezone offset in seconds
        DateTime currentCityTime =
            DateTime.now().toUtc().add(Duration(seconds: timezoneOffset));
        cityTime = DateFormat('yyyy-MM-dd – hh:mm a')
            .format(currentCityTime); // 12-hour format with AM/PM
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeather(city); // Fetch weather for the default city initially
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Weather App')),
        backgroundColor: Color(0xFFA5B68D), // Custom color for the title
        elevation: 0,
      ),
      body: weatherData == null
          ? Center(child: CircularProgressIndicator())
          : Container(
              color: Color(0xFFADB2D4), // Set the body background color
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Search bar inside the card
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              labelText: 'Search City',
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    BorderSide(color: Colors.blueAccent),
                              ),
                            ),
                            onSubmitted: (value) {
                              if (value.isNotEmpty) {
                                fetchWeather(value);
                              }
                            },
                          ),
                        ),
                        // Current City Time
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Time in ${weatherData['name']}: $cityTime", // Display city time with AM/PM
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        // Weather Information
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Location: ${weatherData['name']}",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Temp: ${weatherData['main']['temp']}°C',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Weather: ${weatherData['weather'][0]['description']}',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Humidity: ${weatherData['main']['humidity']}%',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Wind Speed: ${weatherData['wind']['speed']} m/s',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
