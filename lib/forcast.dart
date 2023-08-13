import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatelessWidget {
  Future<Map<String, dynamic>> fetchHourlyForecast() async {
    final apiKey = "2af17ca8db3843d38c0120631231308"; // Replace with your WeatherAPI key
    final apiUrl =
        "http://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=Dhaka&days=1&aqi=no&alerts=no";

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load hourly forecast data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchHourlyForecast(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final hourlyForecastData = snapshot.data;
            final List<dynamic> hourlyForecast =
            hourlyForecastData?['forecast']['forecastday'][0]['hour'];

            return ListView.builder(
              itemCount: hourlyForecast.length,
              itemBuilder: (context, index) {
                final hourData = hourlyForecast[index];
                final hour = hourData['time'];
                final tempC = hourData['temp_c'];
                return ListTile(
                  title: Text('Hour: $hour'),
                  subtitle: Text('Temperature: $tempC°C'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
