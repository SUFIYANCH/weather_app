import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/model/forcast_model.dart';

class ApiService {
  final Dio dio = Dio();
  Future<ForecastModel?> getforecast({required String query}) async {
    try {
      Response response = await dio.get(
          'http://api.weatherapi.com/v1/forecast.json?key=14d9c1b117a246cc87572922232106&q=$query&days=7');
      log(response.statusCode.toString());
      log(response.data.toString());
      if (response.statusCode == 200) {
        String jsonResponse = json.encode(response.data);
        return forecastModelFromJson(jsonResponse);
      } else if (response.statusCode! >= 400) {}
    } on DioException catch (e) {
      log(e.toString());
      return ForecastModel(
          error: Error(message: e.response!.data["error"]["message"]));
    }
    return null;
  }
}

final apiProvider = Provider<ApiService>((ref) {
  return ApiService();
});
