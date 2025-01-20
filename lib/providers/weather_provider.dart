import 'package:flutter/foundation.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherService weatherService;
  Weather? _weather;

  String? errorMessage;  // To store error messages

  WeatherProvider({required this.weatherService});

  Weather? get weather => _weather;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> getWeather(double latitude, double longitude) async {
    _isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      _weather = await weatherService.getWeather(latitude, longitude);
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getWeatherCity(String city) async {
    _isLoading = true;
    errorMessage = '';  // Clear previous error messages
    notifyListeners();

    try {
      _weather = await weatherService.getWeatherCity(city);
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
