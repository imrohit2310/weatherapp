import 'dart:developer';

import 'package:weatherapp/api/api_key.dart';

String apiURL(var lat, var lon) {
  String url;

  url =
      "https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$lon&appid=$apiKey&units=metric&exclude=minutely";
  log("url------------------>$url");
  return url;
}

// String apiURLByCity(String city) {
//   String url;
//   url =
//       "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric&exclude=minutely";
//   log('url------------------>$url');
//   return url;
// }
