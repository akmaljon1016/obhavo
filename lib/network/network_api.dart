import 'package:dio/dio.dart';
import 'package:obhavo/models/weather.dart';

class NetworkApi {
  Future<Weather> getWeather(String city) async {
    Dio dio = Dio();
    var response = await dio.get(
        "https://api.weatherapi.com/v1/forecast.json?key=acb4a4de25aa41b784651422200510&q=$city&days=3");
    return Weather.fromJson(response.data);
  }
}
