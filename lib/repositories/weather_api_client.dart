import 'dart:convert';

import 'package:flutter_weather/models/models.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

//Data Provider: The data provider's responsibility is to provide raw data. The data provider should be generic and versatile.

class WeatherApiClient {
  // creating a constant for our base URL
  static const baseUrl = 'https://www.metaweather.com';
  // instantiating our http client
  final http.Client httpClient;

//  creating our Constructor and 
// requiring that we inject an instance of httpClient
  WeatherApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  // making a simple HTTP request and then decoding the response as a list
  Future <int> getLocationId(String city) async {
      final locationUrl = '$baseUrl/api/location/search/?query=$city';

      final locationResponse = await this.httpClient.get(locationUrl);
      if (locationResponse.statusCode != 200) {
        throw Exception('error getting locationId for city');
      }

      final locationJson = jsonDecode(locationResponse.body) as List;
      return (locationJson.first)['woeid'];
  }

  Future<Weather> fetchWeather(int locationId) async {
    final weatherUrl = '$baseUrl/api/location/$locationId';
    final weatherResponse = await this.httpClient.get(weatherUrl);

    if (weatherResponse.statusCode != 200) {
      throw Exception('error getting weather for location');
    }

    final weatherJson = jsonDecode(weatherResponse.body);
    return Weather.fromJson(weatherJson);
  }
}