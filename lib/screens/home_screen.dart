import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/location_provider.dart';
import '../providers/weather_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
      ),
      body: Consumer2<LocationProvider, WeatherProvider>(
        builder: (context, locationProvider, weatherProvider, child) {
          if (weatherProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                weatherProvider.weather != null
                    ? Column(
                        children: <Widget>[
                          Text(
                            'Temperature: ${weatherProvider.weather!.temperature}°C',
                            style: const TextStyle(fontSize: 20),
                          ),
                          Text(
                            'Description: ${weatherProvider.weather!.description}',
                            style: const TextStyle(fontSize: 20),
                          ),
                          Image.network(
                            'http://openweathermap.org/img/w/${weatherProvider.weather!.icon}.png',
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              weatherProvider.setLoading(false);
                              // Optionally reset the weather or allow the user to fetch new data
                            },
                            child: const Text('Clear Weather Data'),
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchLocation();
    });
  }

  // Method to fetch the location and weather data
  void fetchLocation() {
    final weatherProvider =
    Provider.of<WeatherProvider>(context, listen: false);
    final locationProvider =
    Provider.of<LocationProvider>(context, listen: false);

    weatherProvider.setLoading(true);
    locationProvider.getCurrentLocation().then((locationData) {
      if (locationData != null &&
          locationData.latitude != null &&
          locationData.longitude != null) {
        weatherProvider.getWeather(
            locationData.latitude!, locationData.longitude!);
      } else {
        weatherProvider.setLoading(false);
      }
    }).catchError((error) {
      weatherProvider.setLoading(false);
      print('An error occurred: $error');
    });
  }
}
