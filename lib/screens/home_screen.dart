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
  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child:  Consumer<WeatherProvider>(
          builder: (context, weatherProvider, child) {
            return Container(
              decoration: getBackgroundGradient("default"),
              child: Stack(
                children: [
                  Builder(builder: (BuildContext context) {
                    if (weatherProvider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (weatherProvider.weather == null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Please try again",style: TextStyle(color: Colors.white),),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: () {
                                // Handle the retry logic here, such as calling the fetchWeather method again
                                fetchLocation();
                              },
                              child: const CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.deepOrangeAccent, // Circle color
                                child: Icon(
                                  Icons.refresh, // Refresh icon
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }


                    if (weatherProvider.weather != null) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        decoration:
                        getBackgroundGradient(weatherProvider.weather!.main),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.network(
                                weatherProvider.weather!.icon,
                                width: 50,
                                height: 50,
                              ),
                              Text(
                                "${weatherProvider.weather!.cityName} (${weatherProvider.weather!.country})",
                                style: const TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '${weatherProvider.weather!.temperature}°C',
                                style: const TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                weatherProvider.weather!.description.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Humidity: ${weatherProvider.weather!.humidity}%',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Wind Speed: ${weatherProvider.weather!.windSpeed} m/s',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Pressure: ${weatherProvider.weather!.pressure} hPa',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Feels Like: ${weatherProvider.weather!.feelsLike}°C',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return Container();
                  },),
                  SafeArea(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: kToolbarHeight,horizontal: 16),
                        child: SizedBox(
                          height: 50,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: Colors.deepOrangeAccent, width: 2),
                              color: Colors.white70,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: searchController,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(color: Colors.black),
                                      decoration: const InputDecoration(
                                        hintText: 'Enter city name',
                                        hintStyle: TextStyle(color: Colors.grey),
                                        fillColor: Colors.white70,
                                        filled: true,
                                        border: InputBorder.none,
                                      ),
                                      keyboardType: TextInputType.streetAddress,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        color: Colors.deepOrangeAccent,
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                                        child: Text(
                                          'Search',
                                          style: TextStyle(color: Colors.white70,fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );


          },
        ),
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

  BoxDecoration getBackgroundGradient(String main) {
    switch (main.toLowerCase()) {
      case 'clear':
        return const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ); // Clear sky gradient
      case 'clouds':
        return BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade300, Colors.grey.shade500],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ); // Cloudy weather gradient
      case 'rain':
        return const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey, Colors.indigo],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ); // Rainy weather gradient
      case 'storm':
        return BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.grey.shade800],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ); // Stormy weather gradient
      case 'snow':
        return BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ); // Snowy weather gradient
      default:
        return const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlue, Colors.blueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ); // Default background gradient
    }
  }
}
