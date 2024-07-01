import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:weatherapp/api/api_key.dart';
import 'package:weatherapp/api/fetch_weather.dart';
import 'package:weatherapp/model/weather_data.dart';
import 'package:weatherapp/utils/enums.dart';

class GlobalController extends GetxController {
  final RxBool _isLoading = true.obs;
  final RxDouble _latitude = 0.0.obs;
  final RxDouble _longitude = 0.0.obs;
  final RxInt _currentIndex = 0.obs;
  RxList<AutocompletePrediction> predictions = <AutocompletePrediction>[].obs;
  final Rx<TemperatureUnit> _temperatureUnit = TemperatureUnit.celsius.obs;
  final weatherData = WeatherData().obs;
  final cityName = ''.obs;
  final searchController = TextEditingController();

  WeatherData getData() {
    return weatherData.value;
  }

  @override
  void onInit() {
    super.onInit();
    getLocation();
  }

  Future<void> getLocation() async {
  bool isServiceEnabled;
  LocationPermission locationPermission;

  isServiceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!isServiceEnabled) {
    return Future.error("Location not enabled");
  }

  locationPermission = await Geolocator.checkPermission();

  if (locationPermission == LocationPermission.deniedForever) {
    return Future.error("Location permission is denied forever");
  } else if (locationPermission == LocationPermission.denied) {
    locationPermission = await Geolocator.requestPermission();
    if (locationPermission == LocationPermission.denied) {
      return Future.error("Location permission is denied");
    }
  }

  await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
      .then((value) async {
    _latitude.value = value.latitude;
    _longitude.value = value.longitude;

  
    weatherData.value = await FetchWeatherAPI()
        .fetchWeatherByCoordinates(_latitude.value, _longitude.value);
    
  
    List<Placemark> placemarks = await placemarkFromCoordinates(_latitude.value, _longitude.value);
    if (placemarks.isNotEmpty) {
      cityName.value = placemarks.first.locality ?? 'Unknown';
    }

    _isLoading.value = false;
  });
}


  Future<void> fetchWeatherByCity(String city) async {
    _isLoading.value = true;
    try {
      final places = FlutterGooglePlacesSdk(placesKey);
      final resp = await places.findAutocompletePredictions(city);
      if (resp.predictions.isNotEmpty) {
        final placeId = resp.predictions.first.placeId;
        final placeDetails = await places.fetchPlace(
          placeId,
          fields: [PlaceField.Location], 
        );

        final location = placeDetails.place?.latLng;
        if (location != null) {
          weatherData.value = await FetchWeatherAPI()
              .fetchWeatherByCoordinates(location.lat, location.lng);
          cityName.value =
              city; 
        }
            }
    } catch (e) {
      print("Error fetching weather data: $e");
    }
    _isLoading.value = false;
  }

  Future<void> onSearchFieldChange(String value) async {
    if (value.isNotEmpty) {
      final places = FlutterGooglePlacesSdk(apiKey);
      final resp = await places.findAutocompletePredictions(value);
      predictions.value = resp.predictions;
    }
  }

  RxBool checkLoading() {
    return _isLoading;
  }

  double getLatitude() {
    return _latitude.value;
  }

  double getLongitude() {
    return _longitude.value;
  }

  RxInt getIndex() {
    return _currentIndex;
  }

  double convertCelsiusToFahrenheit(double celsius) {
    return (celsius * 9 / 5) + 32;
  }

  void toggleTemperatureUnit() {
    if (_temperatureUnit.value == TemperatureUnit.celsius) {
      _temperatureUnit.value = TemperatureUnit.fahrenheit;
    } else {
      _temperatureUnit.value = TemperatureUnit.celsius;
    }
  }

  TemperatureUnit getTemperatureUnit() {
    return _temperatureUnit.value;
  }
}
