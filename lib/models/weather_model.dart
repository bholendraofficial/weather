import 'forecast_model.dart';

class Weather {
  final double temperature;
  final double feelsLike;
  final double minTemperature;
  final double maxTemperature;
  final String description;
  final String main;
  final String icon;
  final int humidity;
  final double windSpeed;
  final int windDeg;
  final double windGust;
  final String country;
  final String cityName;
  final double lat;
  final double lon;
  final double visibility;
  final int pressure;
  final int seaLevel;
  final int grndLevel;
  final int clouds;
  final int sunrise;
  final int sunset;
  final int dt;
  final int timezone;
  final int id;
  final int cod;

  // Forecast-related fields
  ForecastModel? forecastModel;

  Weather({
    required this.temperature,
    required this.feelsLike,
    required this.minTemperature,
    required this.maxTemperature,
    required this.description,
    required this.main,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.windDeg,
    required this.windGust,
    required this.country,
    required this.cityName,
    required this.lat,
    required this.lon,
    required this.visibility,
    required this.pressure,
    required this.seaLevel,
    required this.grndLevel,
    required this.clouds,
    required this.sunrise,
    required this.sunset,
    required this.dt,
    required this.timezone,
    required this.id,
    required this.cod,
    this.forecastModel, // Adding forecast list as a field
  });

  factory Weather.fromJson(Map<String, dynamic> json, {ForecastModel? forecastModel}) {

    double safeDouble(dynamic value) {
      return value != null ? value.toDouble() : 0.0; // Default to 0.0 if null
    }

    return Weather(
      temperature: safeDouble(json['main']['temp']),
      feelsLike: safeDouble(json['main']['feels_like']),
      minTemperature: safeDouble(json['main']['temp_min']),
      maxTemperature: safeDouble(json['main']['temp_max']),
      description: json['weather'][0]['description'] ?? '',
      main: json['weather'][0]['main'] ?? '',
      icon: "http://openweathermap.org/img/w/${json['weather'][0]['icon']}.png",
      humidity: json['main']['humidity'] ?? 0,
      windSpeed: safeDouble(json['wind']['speed']),
      windDeg: json['wind']['deg'] ?? 0,
      windGust: safeDouble(json['wind']['gust']),
      country: json['sys']['country'] ?? '',
      cityName: json['name'] ?? '',
      lat: safeDouble(json['coord']['lat']),
      lon: safeDouble(json['coord']['lon']),
      visibility: safeDouble(json['visibility']),
      pressure: json['main']['pressure'] ?? 0,
      seaLevel: json['main']['sea_level'] ?? 0,
      grndLevel: json['main']['grnd_level'] ?? 0,
      clouds: json['clouds']['all'] ?? 0,
      sunrise: json['sys']['sunrise'] ?? 0,
      sunset: json['sys']['sunset'] ?? 0,
      dt: json['dt'] ?? 0,
      timezone: json['timezone'] ?? 0,
      id: json['id'] ?? 0,
      cod: json['cod'] ?? 0,
      forecastModel: forecastModel,  // Including forecast list in the Weather object
    );
  }
}
