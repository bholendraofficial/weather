import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/forecast_model.dart';
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
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Consumer<WeatherProvider>(
          builder: (context, weatherProvider, child) {
            return Container(
              decoration: getBackgroundGradient("default"),
              child: Stack(
                children: [
                  Builder(
                    builder: (BuildContext context) {
                      if (weatherProvider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if(weatherProvider.errorMessage!=null)
                        {
                          return Center(
                            child: Text(
                              weatherProvider.errorMessage.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }

                      if (weatherProvider.weather == null) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Please try again",
                                style: TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 20),
                              GestureDetector(
                                onTap: () {
                                  // Handle the retry logic here, such as calling the fetchWeather method again
                                  fetchLocation();
                                },
                                child: const CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.deepOrangeAccent,
                                  // Circle color
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
                          decoration: getBackgroundGradient(
                              weatherProvider.weather!.main),
                          child: Column(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: SafeArea(
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                                            weatherProvider.weather!.description
                                                .toUpperCase(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            AppHelper.formatDate(
                                                weatherProvider.weather!.dt),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          LayoutBuilder(
                                            builder: (context, constraints) {
                                              double containerWidth = constraints
                                                      .maxWidth *
                                                  0.23; // 23% of available width
                                              return Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  // Humidity Container
                                                  createWeatherContainer(
                                                    label: 'Humidity',
                                                    value:
                                                        '${weatherProvider.weather!.humidity}%',
                                                    icon: Icons.remove_red_eye,
                                                    containerWidth: containerWidth,
                                                  ),
                                                  const SizedBox(width: 8),

                                                  // Wind Speed Container
                                                  createWeatherContainer(
                                                    label: 'Wind Speed',
                                                    value:
                                                        '${weatherProvider.weather!.windSpeed} m/s',
                                                    icon: Icons.wind_power,
                                                    containerWidth: containerWidth,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  // Pressure Container
                                                  createWeatherContainer(
                                                    label: 'Pressure',
                                                    value:
                                                        '${weatherProvider.weather!.pressure} hPa',
                                                    icon: Icons.compress_outlined,
                                                    containerWidth: containerWidth,
                                                  ),
                                                  const SizedBox(width: 8),

                                                  // Feels Like Container
                                                  createWeatherContainer(
                                                    label: 'Feels Like',
                                                    value:
                                                        '${weatherProvider.weather!.feelsLike}°C',
                                                    icon: Icons.fence_sharp,
                                                    containerWidth: containerWidth,
                                                  ),
                                                ],
                                              );
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "7 day weather forecast",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 120,
                                child: ListView.builder(
                                  itemCount: weatherProvider
                                          .weather
                                          ?.forecastModel
                                          ?.forecastItem
                                          ?.length ??
                                      0,
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    final ForecastItem? forecastItem =
                                        weatherProvider.weather?.forecastModel
                                            ?.forecastItem?[index];

                                    if (forecastItem == null) {
                                      return const SizedBox.shrink();
                                    }

                                    final dt = forecastItem.dt;
                                    final highTemp =
                                        forecastItem.maxTemperature;
                                    final lowTemp = forecastItem.minTemperature;
                                    final condition = forecastItem.description;

                                    return Card(
                                      margin: const EdgeInsets.all(8),
                                      // Adds margin around the card
                                      elevation: 4,
                                      // Adds shadow/elevation to the card
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            12), // Optional: rounds the corners of the card
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        // Adds padding inside the card
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          // Aligns text to the start
                                          children: [
                                            Text(
                                              AppHelper.formatDate(dt),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                // Bold text for the day
                                                fontSize:
                                                    18, // Optional: change text size for the title
                                              ),
                                            ),

                                            Text(
                                              'High: ${highTemp}°C, Low: ${lowTemp}°C',
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              'Condition: $condition',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return Container();
                    },
                  ),
                  SafeArea(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: kToolbarHeight, horizontal: 16),
                        child: SizedBox(
                          height: 50,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                  color: Colors.deepOrangeAccent, width: 2),
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
                                      style:
                                          const TextStyle(color: Colors.black),
                                      decoration: const InputDecoration(
                                        hintText: 'Enter city name',
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
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
                                      // Check if the search field is empty
                                      if (searchController.text.isEmpty) {
                                        // Show validation message in Snackbar
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Please enter a city name'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      } else {
                                        // Proceed with the weather fetching
                                        weatherProvider.setLoading(true);
                                        weatherProvider.getWeatherCity(
                                            searchController.text);
                                      }
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        color: Colors.deepOrangeAccent,
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: Text(
                                          'Search',
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontWeight: FontWeight.bold),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          fetchLocation();
        },
        backgroundColor: Colors.deepOrangeAccent,
        child: Icon(
          Icons.gps_fixed,
          color: Colors.white,
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

  Widget createWeatherContainer({
    required String label,
    required String value,
    required IconData icon,
    required double containerWidth,
  }) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.deepOrangeAccent,
          borderRadius: BorderRadius.all(Radius.circular(16))),
      height: 130,
      width: containerWidth,
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 50, // Fixed height for the icon container
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100)),
              child: Icon(
                icon,
                color: Colors.deepOrangeAccent,
                size: 32, // Set the icon size to adjust the scaling
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          Text(
            value,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class AppHelper {
  static String formatDate(int dt) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(dt * 1000);
    String formattedDate = DateFormat('EEEE, dd MMMM yyyy').format(date);

    return formattedDate;
  }
}
