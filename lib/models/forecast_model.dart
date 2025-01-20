class ForecastModel {
  int? id;
  String? name;
  final double lat;
  final double lon;
  final int population;
  final int timezone;
  final int sunrise;
  final int sunset;
  List<ForecastItem>? forecastItem;

  ForecastModel({
    this.id,
    this.name,
    required this.lat,
    required this.lon,
    this.population = 0,
    this.timezone = 19800,
    this.sunrise = 0,
    this.sunset = 0,
    this.forecastItem,
  });

  ForecastModel.fromJson(Map<String, dynamic> json)
      : id = json['city']['id'],
        name = json['city']['name'],
        lat =  json['city']['coord']['lat'],
        lon = json['city']['coord']['lon'],
        population = json['city']['population'] ?? 0,
        timezone = json['city']['timezone'] ?? 0,
        sunrise = json['city']['sunrise'] ?? 0,
        sunset = json['city']['sunset'] ?? 0,
        forecastItem = (json['list'] as List?)
            ?.map((item) => ForecastItem.fromJson(item))
            .toList();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['lat'] = lat;
    data['lon'] = lon;
    data['population'] = population;
    data['timezone'] = timezone;
    data['sunrise'] = sunrise;
    data['sunset'] = sunset;
    if (forecastItem != null) {
      data['forecastItem'] = forecastItem!.map((item) => item.toJson()).toList();
    }
    return data;
  }
}

class ForecastItem {
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

  ForecastItem({
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

  ForecastItem.fromJson(Map<String, dynamic> json)
      : temperature = json['main']['temp']?.toDouble() ?? 0.0,
        feelsLike = json['main']['feels_like']?.toDouble() ?? 0.0,
        minTemperature = json['main']['temp_min']?.toDouble() ?? 0.0,
        maxTemperature = json['main']['temp_max']?.toDouble() ?? 0.0,
        description = json['weather'][0]['description'] ?? '',
        main = json['weather'][0]['main'] ?? '',
        icon = json['weather'][0]['icon'] ?? '',
        humidity = json['main']['humidity'] ?? 0,
        windSpeed = json['wind']['speed']?.toDouble() ?? 0.0,
        windDeg = json['wind']['deg'] ?? 0,
        windGust = json['wind']['gust']?.toDouble() ?? 0.0,
        country = json['sys']['country'] ?? '',
        cityName = json['name'] ?? '',
        visibility = json['visibility']?.toDouble() ?? 0.0,
        pressure = json['main']['pressure'] ?? 0,
        seaLevel = json['main']['sea_level'] ?? 0,
        grndLevel = json['main']['grnd_level'] ?? 0,
        clouds = json['clouds']['all'] ?? 0,
        sunrise = json['sys']['sunrise'] ?? 0,
        sunset = json['sys']['sunset'] ?? 0,
        dt = json['dt'] ?? 0,
        timezone = json['timezone'] ?? 0,
        id = json['id'] ?? 0,
        cod = json['cod'] ?? 0;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['main'] = {
      'temp': temperature,
      'feels_like': feelsLike,
      'temp_min': minTemperature,
      'temp_max': maxTemperature,
      'humidity': humidity,
      'pressure': pressure,
      'sea_level': seaLevel,
      'grnd_level': grndLevel,
    };
    data['weather'] = [
      {'description': description, 'main': main, 'icon': icon}
    ];
    data['wind'] = {
      'speed': windSpeed,
      'deg': windDeg,
      'gust': windGust,
    };
    data['sys'] = {'country': country, 'sunrise': sunrise, 'sunset': sunset};
    data['name'] = cityName;
    data['visibility'] = visibility;
    data['clouds'] = {'all': clouds};
    data['dt'] = dt;
    data['timezone'] = timezone;
    data['id'] = id;
    data['cod'] = cod;
    return data;
  }
}
