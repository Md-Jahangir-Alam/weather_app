import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/forcast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  Future<Map<String, dynamic>> fetchWeatherData() async {
    final apiKey = "2af17ca8db3843d38c0120631231308";
    final apiUrl =
        "http://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=Dhaka&days=1&aqi=no&alerts=no";

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body); // Use json.decode here
    } else {
      throw Exception('Failed to load weather data');
    }
  }



  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context , child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Weather App',
          home: Scaffold(
            appBar: AppBar(title: Text("Weather App"),),
            body: SafeArea(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/background.jpg"), fit: BoxFit.cover
                      )
                    ),
                  ),
                  Positioned(
                      child: FutureBuilder<Map<String, dynamic>>(
                          future: fetchWeatherData(),
                          builder: (context, snapshot){
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else{
                              final weatherData = snapshot.data;
                              return Column(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 250.h,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            '${weatherData?['location']['name']}',
                                            style: TextStyle(fontSize: 30, color: Colors.white),
                                          ),
                                          Text(
                                            '${weatherData?['location']['localtime']}',
                                            style: TextStyle(fontSize: 30, color: Colors.white),
                                          ),
                                          SizedBox(height: 20.h,),
                                          Padding(
                                            padding: const EdgeInsets.all(18.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  '${weatherData?['current']['temp_c']}°C',
                                                  style: TextStyle(fontSize: 30, color: Colors.white),
                                                ),
                                                Text(
                                                  '${weatherData?['current']['temp_f']}°F',
                                                  style: TextStyle(fontSize: 30, color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 20.h,),
                                          Text(
                                            '${weatherData?['current']['condition']['text']}',
                                            style: TextStyle(fontSize: 30, color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    )
                                  ),
                                  Expanded(child: WeatherScreen())
                                ],
                              );
                            }
                          }
                      )
                  )
                ],
              )
            ),
          ),
        );
      },
    );
  }
}

