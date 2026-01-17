import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

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
}

class AlarmProvider extends ChangeNotifier {
  List<Alarm> _alarms = [];

  List<Alarm> get alarms => List.unmodifiable(_alarms);

  AlarmProvider() {
    // Add some dummy data for initial visualization
    _addDummyData();
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

  void addAlarm(Alarm alarm) {
    _alarms.add(alarm);
    _sortAlarms();
    notifyListeners();
  }

  void updateAlarm(Alarm updatedAlarm) {
    final index = _alarms.indexWhere((a) => a.id == updatedAlarm.id);
    if (index != -1) {
      _alarms[index] = updatedAlarm;
      _sortAlarms();
      notifyListeners();
    }
  }

  void deleteAlarm(String id) {
    _alarms.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  void toggleAlarm(String id, bool value) {
    final index = _alarms.indexWhere((a) => a.id == id);
    if (index != -1) {
      _alarms[index] = _alarms[index].copyWith(isEnabled: value);
      notifyListeners();
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
