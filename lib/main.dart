import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:gentle_wake_up/services/audio_handler.dart';
import 'models/alarm.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Background Services
  await AndroidAlarmManager.initialize();
  await AudioPlayerHandler.init();

  runApp(const GentleWakeUpApp());
}

class GentleWakeUpApp extends StatelessWidget {
  const GentleWakeUpApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AlarmProvider(),
      child: MaterialApp(
        title: 'Gentle Wake Up',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
