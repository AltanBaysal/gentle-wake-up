import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/alarm.dart';
import 'theme/app_theme.dart';
import 'screens/alarm_list_screen.dart';

void main() {
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
        home: const AlarmListScreen(),
      ),
    );
  }
}
