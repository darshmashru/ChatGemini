library globals;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

String PALM_API_KEY = "";
String USER_NAME_GLOBAL = "";

double global_temperature = 0.0;

// final globalTemperatureProvider = StateProvider<double>((ref) => 0.0);

Future<void> saveUserName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('userName', USER_NAME_GLOBAL);
}

Future<void> loadUserName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  USER_NAME_GLOBAL = prefs.getString('userName') ?? '';
}