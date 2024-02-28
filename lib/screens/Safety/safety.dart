import 'package:ChatGemini/env/env.dart';
import 'package:ChatGemini/providers/parameter_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ChatGemini/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// API Key from Envied .env file
String apiKey = Env.geminiApiKey;

// double _temperature = 0.0;
double _temperature = global_temperature;

// API Key from globals.dart
// String apiKey = PALM_API_KEY;

final _obscureTextNotifier = ValueNotifier<bool>(true);
final TextEditingController _apiTextController = TextEditingController();
final TextEditingController _nameTextController = TextEditingController();

class Safety extends ConsumerStatefulWidget {
  const Safety({super.key});

  @override
  _SafetyState createState() => _SafetyState();
}

class _SafetyState extends ConsumerState<Safety> {
  bool _obscureText = true;

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('temperature', ref.read(temperatureProvider));
    await prefs.setDouble('topK', ref.read(topKProvider));
    await prefs.setDouble('topP', ref.read(topPProvider));
  }

  void signUserOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _initializeParameters();
  }

  void _initializeParameters() async {
    final prefs = await SharedPreferences.getInstance();
    final temperature = prefs.getDouble('temperature') ?? 0.7;
    final topK = prefs.getDouble('topK') ?? 40.0;
    final topP = prefs.getDouble('topP') ?? 0.95;
    ref.read(temperatureProvider.notifier).state = temperature;
    ref.read(topKProvider.notifier).state = topK;
    ref.read(topPProvider.notifier).state = topP;
  }

  void _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      USER_NAME_GLOBAL = prefs.getString('userName') ?? '';
    });
  }

  void _saveName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', USER_NAME_GLOBAL);
  }

  @override
  Widget build(BuildContext context) {
    var temperature = ref.watch(temperatureProvider);
    var topK = ref.watch(topKProvider);
    var topP = ref.watch(topPProvider);

    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Define the primary color and text themes for dark mode
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        primarySwatch: Colors.teal,
        textTheme: TextTheme(
          titleLarge:
              TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        ),
      ),
      home: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Safety",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Divider(
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Temperature",
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      temperature.toStringAsFixed(1),
                      style: GoogleFonts.inter(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      width: 175,
                      child: Slider(
                          value: temperature,
                          min: 0,
                          max: 1,
                          divisions: 10,
                          onChanged: (value) {
                            ref.read(temperatureProvider.notifier).state =
                                value;
                            _saveData();
                          }),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "topK",
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      topK.toStringAsFixed(1),
                      style: GoogleFonts.inter(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      width: 175,
                      child: Slider(
                          value: topK,
                          min: 0,
                          max: 100,
                          divisions: 10,
                          onChanged: (value) {
                            ref.read(topKProvider.notifier).state = value;
                            _saveData();
                          }),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "topP",
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      topP.toStringAsFixed(1),
                      style: GoogleFonts.inter(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      width: 175,
                      child: Slider(
                          value: topP,
                          min: 0,
                          max: 1,
                          divisions: 10,
                          onChanged: (value) {
                            ref.read(topPProvider.notifier).state = value;
                            _saveData();
                          }),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}