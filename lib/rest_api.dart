

import 'package:http/http.dart' as http;
import 'my_weather_model.dart';

const String _apiKey = '5aa6c40803fbb300fe98c6728bdafce7';
const String _baseUrl = 'https://api.openweathermap.org/data/2.5/forecast';

Future<List<ForecastItem>> fetchDuluthForecast({int count = 8}) async {
  final uri = Uri.parse(
      '$_baseUrl?q=duluth&units=imperial&cnt=$count&appid=$_apiKey');

  final resp = await http.get(uri);
  if (resp.statusCode != 200) {
    throw Exception('Failed to fetch weather: HTTP ${resp.statusCode}');
  }

  final forecast = weatherForecastFromJson(resp.body);
  return forecast.items;
}

/// Optionally, fetch by lat/lon
Future<List<ForecastItem>> fetchForecastByLatLon({
  required double lat,
  required double lon,
  int count = 8,
}) async {
  final uri = Uri.parse(
      '$_baseUrl?lat=$lat&lon=$lon&units=imperial&cnt=$count&appid=$_apiKey');

  final resp = await http.get(uri);
  if (resp.statusCode != 200) {
    throw Exception('Failed to fetch weather: HTTP ${resp.statusCode}');
  }

  final forecast = weatherForecastFromJson(resp.body);
  return forecast.items;
}
