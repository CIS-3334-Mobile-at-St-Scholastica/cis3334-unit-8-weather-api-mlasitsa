
import 'dart:convert';

WeatherForecast weatherForecastFromJson(String str) =>
    WeatherForecast.fromJson(json.decode(str) as Map<String, dynamic>);

class WeatherForecast {
  final City? city;
  final List<ForecastItem> items;

  WeatherForecast({
    required this.city,
    required this.items,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    final listJson = (json['list'] as List<dynamic>? ?? []);
    return WeatherForecast(
      city: json['city'] != null ? City.fromJson(json['city']) : null,
      items: listJson
          .map((e) => ForecastItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class City {
  final String name;
  final String country;

  City({
    required this.name,
    required this.country,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
        name: (json['name'] ?? '') as String,
        country: (json['country'] ?? '') as String,
      );
}

class ForecastItem {
  final DateTime dateTime; // dt or dt_txt
  final double temp;
  final double tempMin;
  final double tempMax;
  final double windSpeed;
  final String weatherMain;        
  final String weatherDescription;
  final String icon;              

  ForecastItem({
    required this.dateTime,
    required this.temp,
    required this.tempMin,
    required this.tempMax,
    required this.windSpeed,
    required this.weatherMain,
    required this.weatherDescription,
    required this.icon,
  });

  factory ForecastItem.fromJson(Map<String, dynamic> json) {
    final main = (json['main'] as Map<String, dynamic>? ?? {});
    final weatherList = (json['weather'] as List<dynamic>? ?? []);
    final weather0 = weatherList.isNotEmpty
        ? weatherList.first as Map<String, dynamic>
        : <String, dynamic>{};

    DateTime parseDateTime(Map<String, dynamic> j) {
      if (j['dt_txt'] != null && j['dt_txt'] is String) {
        return DateTime.tryParse(j['dt_txt'] as String) ??
            DateTime.fromMillisecondsSinceEpoch(((j['dt'] ?? 0) as int) * 1000,
                isUtc: true);
      }
      final dt = (j['dt'] ?? 0) as int;
      return DateTime.fromMillisecondsSinceEpoch(dt * 1000, isUtc: true);
    }

    double toDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    return ForecastItem(
      dateTime: parseDateTime(json),
      temp: toDouble(main['temp']),
      tempMin: toDouble(main['temp_min']),
      tempMax: toDouble(main['temp_max']),
      windSpeed: toDouble((json['wind'] as Map<String, dynamic>? ?? {})['speed']),
      weatherMain: (weather0['main'] ?? '') as String,
      weatherDescription: (weather0['description'] ?? '') as String,
      icon: (weather0['icon'] ?? '') as String,
    );
  }
}
