import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/alarm.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_time_picker.dart';

class EditAlarmScreen extends StatefulWidget {
  final Alarm? alarm;

  const EditAlarmScreen({Key? key, this.alarm}) : super(key: key);

  @override
  _EditAlarmScreenState createState() => _EditAlarmScreenState();
}

class _EditAlarmScreenState extends State<EditAlarmScreen> {
  late DateTime _selectedTime;
  late TextEditingController _labelController;
  late bool _snoozeEnabled;
  final int _snoozeDuration = 5; // Static as per requirements
  final bool _repeat = false; // Static as per requirements

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedTime = widget.alarm?.time ?? DateTime(now.year, now.month, now.day, now.hour + 1, 0);
    _labelController = TextEditingController(text: widget.alarm?.label ?? 'Alarm');
    _snoozeEnabled = widget.alarm?.snoozeEnabled ?? true;
  }

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: AppTheme.textMid),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Text(
                    'Edit Alarm',
                    style: TextStyle(
                      color: AppTheme.textHighlight,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.check, color: AppTheme.primary),
                    onPressed: _saveAlarm,
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  const SizedBox(height: 20),
                  // Time Picker
                  CustomTimePicker(
                    initialTime: _selectedTime,
                    onTimeChanged: (time) {
                      setState(() {
                        _selectedTime = time;
                      });
                    },
                  ),

                  const SizedBox(height: 30),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        // Label Input
                        _buildSettingItem(
                          title: 'Label',
                          child: Container(
                            width: 150,
                            child: TextField(
                              controller: _labelController,
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                color: AppTheme.textHighlight,
                                fontSize: 16,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Alarm',
                                hintStyle: TextStyle(color: AppTheme.textDim),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Repeat (Display Only)
                        _buildSettingItem(
                          title: 'Repeat',
                          child: Text(
                            'Never', // Static
                            style: TextStyle(
                              color: AppTheme.textMid,
                              fontSize: 16,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Snooze Toggle
                        _buildSettingItem(
                          title: 'Snooze',
                          child: Switch(
                            value: _snoozeEnabled,
                            onChanged: (val) {
                              setState(() {
                                _snoozeEnabled = val;
                              });
                            },
                            activeColor: AppTheme.primary,
                            inactiveTrackColor: AppTheme.surfaceDark,
                          ),
                        ),

                        if (_snoozeEnabled) ...[
                          const SizedBox(height: 16),
                          // Snooze Duration (Display Only)
                           _buildSettingItem(
                            title: 'Snooze Duration',
                            child: Text(
                              '$_snoozeDuration min', // Static
                              style: TextStyle(
                                color: AppTheme.textMid,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Sound Selection (Mock UI)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Select Sound',
                              style: TextStyle(
                                color: AppTheme.textHighlight,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text('See all', style: TextStyle(color: AppTheme.primary)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildSoundOption('Morning Birds', 'Nature Sounds • Calm', true),
                        const SizedBox(height: 12),
                        _buildSoundOption('Ocean Waves', 'Water • Sleep', false),
                        const SizedBox(height: 12),
                        _buildSoundOption('Rainy Mood', 'Ambience • Focus', false),
                      ],
                    ),
                  ),

                   const SizedBox(height: 40),
                ],
              ),
            ),

            // Bottom Action Button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _saveAlarm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                      child: const Text(
                        'Save Alarm',
                        style: TextStyle(
                          color: AppTheme.textHighlight,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  if (widget.alarm != null) ...[
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _deleteAlarm,
                      child: const Text(
                        'Delete Alarm',
                        style: TextStyle(
                          color: AppTheme.textDim,
                          fontSize: 14,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.textHighlight,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildSoundOption(String title, String subtitle, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: isSelected
            ? Border.all(color: AppTheme.primary.withOpacity(0.5))
            : Border.all(color: Colors.transparent),
        boxShadow: [
           BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(12),
              // Placeholder for image
              gradient: LinearGradient(
                colors: [Colors.grey[800]!, Colors.grey[900]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Icon(
                isSelected ? Icons.pause : Icons.play_arrow,
                color: AppTheme.textHighlight,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? AppTheme.textHighlight : AppTheme.textMid,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppTheme.textDim,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          if (isSelected)
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppTheme.primary,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  void _saveAlarm() {
    final newAlarm = widget.alarm?.copyWith(
      time: _selectedTime,
      label: _labelController.text,
      snoozeEnabled: _snoozeEnabled,
    ) ?? Alarm(
      time: _selectedTime,
      label: _labelController.text,
      isEnabled: true,
      snoozeEnabled: _snoozeEnabled,
    );

    final provider = Provider.of<AlarmProvider>(context, listen: false);

    if (widget.alarm != null) {
      provider.updateAlarm(newAlarm);
    } else {
      provider.addAlarm(newAlarm);
    }

    Navigator.of(context).pop();
  }

  void _deleteAlarm() {
    if (widget.alarm != null) {
      Provider.of<AlarmProvider>(context, listen: false).deleteAlarm(widget.alarm!.id);
    }
    Navigator.of(context).pop();
  }
}
