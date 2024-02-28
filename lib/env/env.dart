import 'package:envied/envied.dart';

part 'env.g.dart';

// @Envied(path: '.env')
@Envied()
abstract class Env {
  @EnviedField(varName: "FIREBASE_WEB", obfuscate: true)
  static final String firebaseWeb = _Env.firebaseWeb;
  @EnviedField(varName: "FIREBASE_ANDROID", obfuscate: true)
  static final String firebaseAndroid = _Env.firebaseAndroid;
  @EnviedField(varName: "FIREBASE_IOS", obfuscate: true)
  static final String firebaseIos = _Env.firebaseIos;
  @EnviedField(varName: "FIREBASE_MACOS", obfuscate: true)
  static final String firebaseMacos = _Env.firebaseMacos;
  @EnviedField(varName: "GEMINI_API_KEY", obfuscate: true)
  static final String geminiApiKey= _Env.geminiApiKey;
}