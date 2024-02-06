import 'package:flutter_riverpod/flutter_riverpod.dart';

final temperatureProvider = StateProvider<double>((ref) {
  return 0.7; // Default value for temperature
});

final topKProvider = StateProvider<double>((ref) {
  return 40; // Default value for topK
});

final topPProvider = StateProvider<double>((ref) {
  return 0.95; // Default value for topP
});
