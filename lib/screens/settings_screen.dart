import 'package:flutter/material.dart';
import 'package:gentle_wake_up/services/permission_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _permissionService = PermissionService();
  Map<String, bool> _permissions = {
    'exactAlarm': false,
    'notification': false,
    'battery': false,
  };

  @override
  void initState() {
    super.initState();
    _refreshPermissions();
  }

  Future<void> _refreshPermissions() async {
    final perms = await _permissionService.checkPermissions();
    if (mounted) {
      setState(() {
        _permissions = perms;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Required Permissions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.alarm,
              color: _permissions['exactAlarm']! ? Colors.green : Colors.orange,
            ),
            title: const Text('Exact Alarm'),
            subtitle: const Text('Required to wake you up at the precise time.'),
            trailing: _permissions['exactAlarm']!
                ? const Icon(Icons.check, color: Colors.green)
                : OutlinedButton(
                    onPressed: () async {
                      await _permissionService.requestExactAlarmPermission();
                      await _refreshPermissions();
                      // Exact alarm usually requires sending user to settings
                      if (!_permissions['exactAlarm']!) {
                         // wait a bit for user to return? or just let them retry
                         await _permissionService.openSettings();
                      }
                    },
                    child: const Text('Allow'),
                  ),
          ),
          ListTile(
            leading: Icon(
              Icons.notifications,
              color: _permissions['notification']! ? Colors.green : Colors.orange,
            ),
            title: const Text('Notifications'),
            subtitle: const Text('Required to show background music controls.'),
            trailing: _permissions['notification']!
                ? const Icon(Icons.check, color: Colors.green)
                : OutlinedButton(
                    onPressed: () async {
                      await _permissionService.requestNotificationPermission();
                      await _refreshPermissions();
                    },
                    child: const Text('Allow'),
                  ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Optimization',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.battery_alert,
              color: _permissions['battery']! ? Colors.green : Colors.orange,
            ),
            title: const Text('Battery Optimization'),
            subtitle: const Text('Disable to prevent music from stopping unexpectedly.'),
            trailing: _permissions['battery']!
                ? const Icon(Icons.check, color: Colors.green)
                : OutlinedButton(
                    onPressed: () async {
                      await _permissionService.requestBatteryOptimization();
                      await _refreshPermissions();
                    },
                    child: const Text('Disable'),
                  ),
          ),
        ],
      ),
    );
  }
}
