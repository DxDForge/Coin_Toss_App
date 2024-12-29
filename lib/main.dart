import 'package:coin_toss/controllers/coin_slection_state_controller.dart';
import 'package:coin_toss/controllers/math_game_controller.dart';
import 'package:coin_toss/views/Screens/coin_selection_page.dart';
import 'package:coin_toss/views/Screens/homepage.dart';
import 'package:coin_toss/views/Screens/math_game_page.dart';
import 'package:coin_toss/views/Screens/quiz_page.dart';
import 'package:coin_toss/views/Screens/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coin_toss/services/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SettingsService().init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CoinStateController()),
        ChangeNotifierProvider(create: (_) => MathGameController()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      title: 'Coin Toss Game',
      initialRoute: '/',
      routes: {
        '/': (context) => const CoinFlipHomePage(),
        '/settings': (context) => SettingsPage(),
        '/coinSelection': (context) => const CoinSelectionPage(),
        '/quiz': (context) => QuizPage(),
        '/mathGame': (context) => const MathGameView(),
      },
    );
  }
}