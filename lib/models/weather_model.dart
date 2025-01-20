class Weather {
  final double temperature;
  final double feelsLike;
  final double minTemperature;
  final double maxTemperature;
  final String description;
  final String icon;
  final int humidity;
  final double windSpeed;
  final String country;
  final String cityName;
  final double lat;
  final double lon;
  final double visibility;
  final int pressure;
  final int sunrise;
  final int sunset;

  Weather({
    required this.temperature,
    required this.feelsLike,
    required this.minTemperature,
    required this.maxTemperature,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.country,
    required this.cityName,
    required this.lat,
    required this.lon,
    required this.visibility,
    required this.pressure,
    required this.sunrise,
    required this.sunset,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperature: json['main']['temp'].toDouble(),
      feelsLike: json['main']['feels_like'].toDouble(),
      minTemperature: json['main']['temp_min'].toDouble(),
      maxTemperature: json['main']['temp_max'].toDouble(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      country: json['sys']['country'],
      cityName: json['name'],
      lat: json['coord']['lat'].toDouble(),
      lon: json['coord']['lon'].toDouble(),
      visibility: json['visibility'].toDouble(),
      pressure: json['main']['pressure'],
      sunrise: json['sys']['sunrise'],
      sunset: json['sys']['sunset'],
    );
  }
}
