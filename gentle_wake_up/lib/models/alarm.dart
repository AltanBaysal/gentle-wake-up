import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gentle_wake_up/services/alarm_scheduler.dart';

class Alarm {
  final String id;
  DateTime time;
  bool isEnabled;
  String label;
  bool repeat; // Simplified repeat logic as requested
  String sound;
  bool snoozeEnabled;
  int snoozeDuration; // in minutes

  Alarm({
    String? id,
    required this.time,
    this.isEnabled = true,
    this.label = 'Alarm',
    this.repeat = false,
    this.sound = 'Default',
    this.snoozeEnabled = true,
    this.snoozeDuration = 5,
  }) : id = id ?? const Uuid().v4();

  // Create a copy with some fields updated
  Alarm copyWith({
    DateTime? time,
    bool? isEnabled,
    String? label,
    bool? repeat,
    String? sound,
    bool? snoozeEnabled,
    int? snoozeDuration,
  }) {
    return Alarm(
      id: this.id,
      time: time ?? this.time,
      isEnabled: isEnabled ?? this.isEnabled,
      label: label ?? this.label,
      repeat: repeat ?? this.repeat,
      sound: sound ?? this.sound,
      snoozeEnabled: snoozeEnabled ?? this.snoozeEnabled,
      snoozeDuration: snoozeDuration ?? this.snoozeDuration,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'time': time.toIso8601String(),
      'isEnabled': isEnabled,
      'label': label,
      'repeat': repeat,
      'sound': sound,
      'snoozeEnabled': snoozeEnabled,
      'snoozeDuration': snoozeDuration,
    };
  }

  factory Alarm.fromJson(Map<String, dynamic> json) {
    return Alarm(
      id: json['id'],
      time: DateTime.parse(json['time']),
      isEnabled: json['isEnabled'],
      label: json['label'],
      repeat: json['repeat'],
      sound: json['sound'],
      snoozeEnabled: json['snoozeEnabled'],
      snoozeDuration: json['snoozeDuration'],
    );
  }
}

class AlarmProvider extends ChangeNotifier {
  List<Alarm> _alarms = [];
  static const String _storageKey = 'alarms';

  List<Alarm> get alarms => List.unmodifiable(_alarms);

  AlarmProvider() {
    _loadAlarms();
  }

  Future<void> _loadAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final String? alarmsJson = prefs.getString(_storageKey);

    if (alarmsJson != null) {
      final List<dynamic> decodedList = jsonDecode(alarmsJson);
      _alarms = decodedList.map((item) => Alarm.fromJson(item)).toList();
    } else {
      // Add some dummy data for initial visualization if empty
      _addDummyData();
      _saveAlarms();
    }
    _sortAlarms();
    notifyListeners();
  }

  Future<void> _saveAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedList = jsonEncode(_alarms.map((a) => a.toJson()).toList());
    await prefs.setString(_storageKey, encodedList);
  }

  void _addDummyData() {
    final now = DateTime.now();
    _alarms.addAll([
      Alarm(
        time: DateTime(now.year, now.month, now.day, 7, 0),
        label: 'Forest Rain',
        isEnabled: true,
      ),
      Alarm(
        time: DateTime(now.year, now.month, now.day, 8, 30),
        label: 'Ocean Waves',
        isEnabled: true,
      ),
       Alarm(
        time: DateTime(now.year, now.month, now.day, 9, 0),
        label: 'Birds Chirping',
        isEnabled: false,
      ),
    ]);
  }

  Future<void> addAlarm(Alarm alarm) async {
    _alarms.add(alarm);
    _sortAlarms();
    notifyListeners();
    await _saveAlarms();

    if (alarm.isEnabled) {
      await AlarmScheduler.scheduleAlarm(alarm);
    }
  }

  Future<void> updateAlarm(Alarm updatedAlarm) async {
    final index = _alarms.indexWhere((a) => a.id == updatedAlarm.id);
    if (index != -1) {
      // Cancel previous schedule if it existed
      await AlarmScheduler.cancelAlarm(_alarms[index]);

      _alarms[index] = updatedAlarm;
      _sortAlarms();
      notifyListeners();
      await _saveAlarms();

      if (updatedAlarm.isEnabled) {
        await AlarmScheduler.scheduleAlarm(updatedAlarm);
      }
    }
  }

  Future<void> deleteAlarm(String id) async {
    final index = _alarms.indexWhere((a) => a.id == id);
    if (index != -1) {
      await AlarmScheduler.cancelAlarm(_alarms[index]);
      _alarms.removeAt(index);
      notifyListeners();
      await _saveAlarms();
    }
  }

  Future<void> toggleAlarm(String id, bool value) async {
    final index = _alarms.indexWhere((a) => a.id == id);
    if (index != -1) {
      final alarm = _alarms[index];

      if (value) {
        // Turning on
        await AlarmScheduler.scheduleAlarm(alarm);
      } else {
        // Turning off
        await AlarmScheduler.cancelAlarm(alarm);
      }

      _alarms[index] = alarm.copyWith(isEnabled: value);
      notifyListeners();
      await _saveAlarms();
    }
  }

  void _sortAlarms() {
    _alarms.sort((a, b) {
      // Sort by time of day
      final aMinutes = a.time.hour * 60 + a.time.minute;
      final bMinutes = b.time.hour * 60 + b.time.minute;
      return aMinutes.compareTo(bMinutes);
    });
  }
}
