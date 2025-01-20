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
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperature: json['main']['temp'].toDouble(),
      feelsLike: json['main']['feels_like'].toDouble(),
      minTemperature: json['main']['temp_min'].toDouble(),
      maxTemperature: json['main']['temp_max'].toDouble(),
      description: json['weather'][0]['description'],
      main: json['weather'][0]['main'],
      icon: "http://openweathermap.org/img/w/${json['weather'][0]['icon']}.png",
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      windDeg: json['wind']['deg'],
      windGust: json['wind']['gust'].toDouble(),
      country: json['sys']['country'],
      cityName: json['name'],
      lat: json['coord']['lat'].toDouble(),
      lon: json['coord']['lon'].toDouble(),
      visibility: json['visibility'].toDouble(),
      pressure: json['main']['pressure'],
      seaLevel: json['main']['sea_level'],
      grndLevel: json['main']['grnd_level'],
      clouds: json['clouds']['all'],
      sunrise: json['sys']['sunrise'],
      sunset: json['sys']['sunset'],
      dt: json['dt'],
      timezone: json['timezone'],
      id: json['id'],
      cod: json['cod'],
    );
  }
}
