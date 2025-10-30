// lib/main.dart
import 'package:flutter/material.dart';

import 'my_weather_model.dart';
import 'rest_api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'CIS 3334 Weather App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<ForecastItem>> futureWeatherForecasts;

  // Bonus Step 6: image map for main conditions -> asset image
  final Map<String, String> _imageMap = const {
    "Clear": 'graphics/sun.png',
    "Clouds": 'graphics/cloud.png',
    "Rain": 'graphics/rain.png',
    "Snow": 'graphics/snow.png',
    "Thunderstorm": 'graphics/thunder.png',
    "Drizzle": 'graphics/drizzle.png',
    "Mist": 'graphics/fog.png',
    "Fog": 'graphics/fog.png',
    "Haze": 'graphics/fog.png',
    "Smoke": 'graphics/fog.png',
    "Dust": 'graphics/fog.png',
    "Squall": 'graphics/wind.png',
    "Tornado": 'graphics/wind.png',
  };

  @override
  void initState() {
    super.initState();
    // Step 3: kick off the download of 8×3h = next 24 hours
    futureWeatherForecasts = fetchDuluthForecast(count: 8);
  }

  Widget weatherImage(String weatherMain) {
    final assetPath = _imageMap[weatherMain] ?? 'graphics/sun.png';
    return Image(image: AssetImage(assetPath), width: 48, height: 48);
  }

  String _formatTime(DateTime dt) {
    // Show local time (assumes dt is UTC if parsed that way)
    final local = dt.toLocal();
    final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final ampm = local.hour >= 12 ? 'PM' : 'AM';
    return '$hour:'
        '${local.minute.toString().padLeft(2, '0')} $ampm';
  }

  Widget weatherTile(ForecastItem item) {
    final title =
        '${item.weatherMain} • ${item.weatherDescription[0].toUpperCase()}${item.weatherDescription.substring(1)}';
    final subtitle =
        'At ${_formatTime(item.dateTime)} — ${item.temp.toStringAsFixed(0)}°F '
        '(H:${item.tempMax.toStringAsFixed(0)}°  L:${item.tempMin.toStringAsFixed(0)}°)  '
        'Wind ${item.windSpeed.toStringAsFixed(0)} mph';

    return ListTile(
      leading: weatherImage(item.weatherMain),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<ForecastItem>>(
        future: futureWeatherForecasts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Optional: progress while waiting
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            // Fail-safe: show nothing per your spec, or show an error
            // return Container();
            return Center(
              child: Text(
                'Could not load weather.\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }
          final data = snapshot.data;
          if (data == null || data.isEmpty) {
            // Per instructions
            return Container();
          }

          return ListView.builder(
            itemCount: data.length, // Step 4: use number of forecasts
            itemBuilder: (BuildContext context, int index) {
              final item = data[index];
              return Card(
                child: weatherTile(item),
              );
            },
          );
        },
      ),
    );
  }
}
