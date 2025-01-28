import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: brightness == Brightness.dark,
              onChanged: (_) {
                Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
              },
            ),
          ),
          const ListTile(
            leading: Icon(Icons.info),
            title: Text('App Version'),
            trailing: Text('1.0.0'),
          ),
        ],
      ),
    );
  }
}
