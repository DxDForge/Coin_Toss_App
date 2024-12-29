import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:coin_toss/services/settings_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _settings = SettingsService();
  late bool _soundEnabled;
  late bool _vibrationEnabled;
  late bool _showConfetti;
  late double _flipDuration;
  late String _theme;

  @override
  void initState() {
    super.initState();
    _soundEnabled = _settings.soundEnabled;
    _vibrationEnabled = _settings.vibrationEnabled;
    _showConfetti = _settings.showConfetti;
    _flipDuration = _settings.flipDuration;
    _theme = _settings.theme;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.orbitron(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF16213E), Color(0xFF0F3460)],
          ),
        ),
        child: ListView(
          children: [
            _buildSettingsSection(
              'Animation',
              [
                SwitchListTile(
                  title: const Text('Show Confetti'),
                  subtitle: const Text('Display celebration effects'),
                  value: _showConfetti,
                  onChanged: (bool value) async {
                    await _settings.setShowConfetti(value);
                    setState(() => _showConfetti = value);
                  },
                  secondary: const Icon(Icons.celebration, color: Colors.white),
                ),
                ListTile(
                  title: const Text('Flip Duration'),
                  subtitle: Slider(
                    value: _flipDuration,
                    min: 0.5,
                    max: 3.0,
                    divisions: 5,
                    label: '${_flipDuration.toStringAsFixed(1)}s',
                    onChanged: (double value) async {
                      await _settings.setFlipDuration(value);
                      setState(() => _flipDuration = value);
                    },
                  ),
                  leading: const Icon(Icons.timer, color: Colors.white),
                ),
              ],
            ),
            _buildSettingsSection(
              'Feedback',
              [
                SwitchListTile(
                  title: const Text('Sound Effects'),
                  subtitle: const Text('Play sounds during coin flips'),
                  value: _soundEnabled,
                  onChanged: (bool value) async {
                    await _settings.setSoundEnabled(value);
                    setState(() => _soundEnabled = value);
                  },
                  secondary: const Icon(Icons.volume_up, color: Colors.white),
                ),
                SwitchListTile(
                  title: const Text('Vibration'),
                  subtitle: const Text('Vibrate on coin flips'),
                  value: _vibrationEnabled,
                  onChanged: (bool value) async {
                    await _settings.setVibrationEnabled(value);
                    setState(() => _vibrationEnabled = value);
                  },
                  secondary: const Icon(Icons.vibration, color: Colors.white),
                ),
              ],
            ),
            _buildSettingsSection(
              'Appearance',
              [
                ListTile(
                  title: const Text('Theme'),
                  subtitle: DropdownButton<String>(
                    value: _theme,
                    dropdownColor: const Color(0xFF16213E),
                    isExpanded: true,
                    onChanged: (String? newValue) async {
                      if (newValue != null) {
                        await _settings.setTheme(newValue);
                        setState(() => _theme = newValue);
                      }
                    },
                    items: const [
                      DropdownMenuItem(
                        value: 'dynamic',
                        child: Text('Dynamic'),
                      ),
                      DropdownMenuItem(
                        value: 'light',
                        child: Text('Light'),
                      ),
                      DropdownMenuItem(
                        value: 'dark',
                        child: Text('Dark'),
                      ),
                    ],
                  ),
                  leading: const Icon(Icons.palette, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...children.map((child) => Theme(
              data: Theme.of(context).copyWith(
                listTileTheme: const ListTileThemeData(
                  textColor: Colors.white,
                  iconColor: Colors.white,
                ),
              ),
              child: child,
            )),
        const Divider(color: Colors.white24),
      ],
    );
  }
}
