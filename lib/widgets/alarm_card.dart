import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/alarm.dart';
import '../theme/app_theme.dart';

class AlarmCard extends StatelessWidget {
  final Alarm alarm;
  final ValueChanged<bool> onToggle;
  final VoidCallback onTap;

  const AlarmCard({
    Key? key,
    required this.alarm,
    required this.onToggle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: alarm.isEnabled
              ? AppTheme.charcoalCard
              : AppTheme.charcoalCard.withOpacity(0.4),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withOpacity(0.05),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      DateFormat('hh:mm').format(alarm.time),
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: alarm.isEnabled
                            ? AppTheme.textTime
                            : AppTheme.textSubtle,
                        height: 1.0,
                        letterSpacing: -1.0,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('a').format(alarm.time),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: alarm.isEnabled
                            ? AppTheme.textMuted
                            : AppTheme.textSubtle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.alarm, // Placeholder for dynamic icon based on sound
                      size: 20,
                      color: alarm.isEnabled
                          ? AppTheme.mossLight
                          : AppTheme.textSubtle,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      alarm.label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: alarm.isEnabled
                            ? Colors.grey[400]
                            : AppTheme.textSubtle,
                      ),
                    ),
                    if (alarm.isEnabled) ...[
                      const SizedBox(width: 4),
                      Text(
                        '• 30 min fade-in', // Placeholder
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ],
                ),
                if (alarm.isEnabled) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.05),
                      ),
                    ),
                    child: Text(
                      'Starts at ${DateFormat('hh:mm a').format(alarm.time.subtract(const Duration(minutes: 30)))}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            Switch(
              value: alarm.isEnabled,
              onChanged: onToggle,
              activeColor: AppTheme.mossGreen,
              activeTrackColor: AppTheme.mossGreen.withOpacity(0.2), // Adjust as needed
              inactiveThumbColor: Colors.grey[400],
              inactiveTrackColor: AppTheme.toggleOff,
            ),
          ],
        ),
      ),
    );
  }
}
