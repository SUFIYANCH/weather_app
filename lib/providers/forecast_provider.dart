import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/model/forcast_model.dart';
import 'package:weather_app/services/api_service.dart';

final weatherProvider = FutureProvider<ForecastModel?>((ref) async {
  return await ref.watch(apiProvider).getforecast(
      query: ref.watch(textEditingControllerProvider).text == ''
          ? 'Kozhikode'
          : ref.watch(textEditingControllerProvider).text);
});
final textEditingControllerProvider =
    StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});
