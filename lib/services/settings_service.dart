import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool get soundEnabled => _prefs.getBool('soundEnabled') ?? true;
  bool get vibrationEnabled => _prefs.getBool('vibrationEnabled') ?? true;
  bool get showConfetti => _prefs.getBool('showConfetti') ?? true;
  double get flipDuration => _prefs.getDouble('flipDuration') ?? 1.5;
  String get theme => _prefs.getString('theme') ?? 'dynamic';

  Future<void> setSoundEnabled(bool value) async {
    await _prefs.setBool('soundEnabled', value);
  }

  Future<void> setVibrationEnabled(bool value) async {
    await _prefs.setBool('vibrationEnabled', value);
  }

  Future<void> setShowConfetti(bool value) async {
    await _prefs.setBool('showConfetti', value);
  }

  Future<void> setFlipDuration(double value) async {
    await _prefs.setDouble('flipDuration', value);
  }

  Future<void> setTheme(String value) async {
    await _prefs.setString('theme', value);
  }
}
