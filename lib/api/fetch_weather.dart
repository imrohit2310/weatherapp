// import 'dart:convert';
// import 'dart:developer';
// import 'package:weatherapp/model/weather_data.dart';
// import 'package:http/http.dart' as http;
// import 'package:weatherapp/model/weather_data_current.dart';
// import 'package:weatherapp/model/weather_data_daily.dart';
// import 'package:weatherapp/model/weather_data_hourly.dart';
// import 'package:weatherapp/utils/api_url.dart';

// class FetchWeatherAPI {
//   WeatherData? weatherData;

//   Future<WeatherData> fetchWeatherByCoordinates(double lat, double lon) async {
//     var response = await http.get(Uri.parse(apiURL(lat, lon)));
//     var jsonString = jsonDecode(response.body);

//     weatherData = WeatherData(
//         WeatherDataCurrent.fromJson(jsonString),
//         WeatherDataHourly.fromJson(jsonString),
//         WeatherDataDaily.fromJson(jsonString));

//     return weatherData!;
//   }

//   Future<WeatherData> fetchWeatherByCity(String city) async {
//     var response = await http.get(Uri.parse(apiURL()));
//     var jsonString = jsonDecode(response.body);

//     weatherData = WeatherData(
//         WeatherDataCurrent.fromJson(jsonString),
//         WeatherDataHourly.fromJson(jsonString),
//         WeatherDataDaily.fromJson(jsonString));
// log("api response-------------${response.body}");
//     return weatherData!;
//   }
// }

import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:weatherapp/model/weather_data.dart';
import 'package:weatherapp/model/weather_data_current.dart';
import 'package:weatherapp/model/weather_data_daily.dart';
import 'package:weatherapp/model/weather_data_hourly.dart';
import 'package:weatherapp/utils/api_url.dart';

class FetchWeatherAPI {
  WeatherData? weatherData;

  Future<WeatherData> fetchWeatherByCoordinates(double lat, double lon) async {
    var response = await http.get(Uri.parse(apiURL(lat, lon)));
    var jsonString = jsonDecode(response.body);

    weatherData = WeatherData(
        WeatherDataCurrent.fromJson(jsonString),
        WeatherDataHourly.fromJson(jsonString),
        WeatherDataDaily.fromJson(jsonString));

    return weatherData!;
  }
}
