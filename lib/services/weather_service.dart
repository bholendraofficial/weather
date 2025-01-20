import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/forecast_model.dart';
import '../models/weather_model.dart';

class WeatherService {
  final String apiKey = '42cace599d5bc294baa10496a9d0ee1e';

  Future<Weather> getWeather(double latitude, double longitude) async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Weather weather = Weather.fromJson(json.decode(response.body));
        weather.forecastModel = await getForecastWeather(latitude, longitude);
        return weather;
      } else {
        throw WeatherServiceException(json.decode(response.body)['message']);
      }
    } catch (error) {
      throw WeatherServiceException('Error fetching weather: $error');
    }
  }

  Future<Weather> getWeatherCity(String city) async {
    final url = Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        Weather weather = Weather.fromJson(json.decode(response.body));
        weather.forecastModel = await getForecastWeather(weather.lat, weather.lon);
        return weather;
      } else {
        throw WeatherServiceException(json.decode(response.body)['message']);
      }
    } catch (error) {
      throw WeatherServiceException('Error fetching weather: $error');
    }
  }

  Future<ForecastModel> getForecastWeather(double latitude, double longitude) async {
    final url =
        'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric&cnt=7&exclude=hourly,minutely';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        ForecastModel forecastModel = ForecastModel.fromJson(json.decode(response.body));
        return forecastModel;
      } else {
        throw WeatherServiceException(json.decode(response.body)['message']);
      }
    } catch (error) {
      throw WeatherServiceException('Error fetching forecast data: $error');
    }
  }
}
class WeatherServiceException implements Exception {
  final String message;
  WeatherServiceException(this.message);

  @override
  String toString() {
    return message;
  }
}
