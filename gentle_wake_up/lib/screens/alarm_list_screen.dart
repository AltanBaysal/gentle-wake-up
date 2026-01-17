import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/alarm.dart';
import '../theme/app_theme.dart';
import '../widgets/alarm_card.dart';
import 'edit_alarm_screen.dart';

class AlarmListScreen extends StatelessWidget {
  const AlarmListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.charcoalBg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 8),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Gentle Wake Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Your upcoming alarms',
                        style: TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Alarm List
            Expanded(
              child: Consumer<AlarmProvider>(
                builder: (context, alarmProvider, child) {
                  final alarms = alarmProvider.alarms;
                  if (alarms.isEmpty) {
                    return const Center(
                      child: Text(
                        'No alarms yet',
                        style: TextStyle(color: AppTheme.textSubtle),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    itemCount: alarms.length,
                    itemBuilder: (context, index) {
                      final alarm = alarms[index];
                      return AlarmCard(
                        alarm: alarm,
                        onToggle: (value) {
                          alarmProvider.toggleAlarm(alarm.id, value);
                        },
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EditAlarmScreen(alarm: alarm),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const EditAlarmScreen(),
            ),
          );
        },
        backgroundColor: AppTheme.oliveFab,
        child: const Icon(Icons.add, color: Color(0xFFE5E7EB), size: 32),
      ),
    );
  }
}
