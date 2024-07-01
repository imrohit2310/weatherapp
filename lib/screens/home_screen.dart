import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

import '../controller/global_controller.dart';
import '../utils/custom_colors.dart';
import '../widgets/comfort_level.dart';
import '../widgets/current_weather_widget.dart';
import '../widgets/daily_data_forecast.dart';
import '../widgets/header_widget.dart';
import '../widgets/hourly_data_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalController globalController =
      Get.put(GlobalController(), permanent: true);

 void _searchCity() {
  String city = globalController.searchController.text.trim();
  if (city.isNotEmpty) {
    globalController.fetchWeatherByCity(city);
  }
}
  getAddress(lat, lon) async {
    List<Placemark> placemark = await placemarkFromCoordinates(lat, lon);
    Placemark place = placemark[0];
    globalController.cityName.value = place.locality!;
  }

@override
  void initState() {
        getAddress(globalController.getLatitude(), globalController.getLongitude());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather APP'),
      ),
      body: SafeArea(
        child: Obx(() {
          if (globalController.checkLoading().isTrue) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/icons/clouds.png",
                    height: 200,
                    width: 200,
                  ),
                  const CircularProgressIndicator(),
                ],
              ),
            );
          } else {
            return Center(
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      onChanged: globalController.onSearchFieldChange,
                      controller: globalController.searchController,
                      decoration: InputDecoration(
                        labelText: 'Enter City Name',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: _searchCity,
                        ),
                      ),
                      onSubmitted: (value) => _searchCity(),
                    ),
                  ),
               Obx(()=>    HeaderWidget(city: globalController.cityName.value,)),
                  const SizedBox(height: 20),
                  CurrentWeatherWidget(
                    weatherDataCurrent:
                        globalController.weatherData.value.getCurrentWeather(),
                  ),
                  const SizedBox(height: 20),
                  HourlyDataWidget(
                    weatherDataHourly:
                        globalController.weatherData.value.getHourlyWeather(),
                  ),
                  DailyDataForecast(
                    weatherDataDaily:
                        globalController.weatherData.value.getDailyWeather(),
                  ),
                  Container(
                    height: 1,
                    color: CustomColors.dividerLine,
                  ),
                  const SizedBox(height: 10),
                  ComfortLevel(
                    weatherDataCurrent:
                        globalController.weatherData.value.getCurrentWeather(),
                  ),
                ],
              ),
            );
          }
        }),
      ),
    );
  }
}
