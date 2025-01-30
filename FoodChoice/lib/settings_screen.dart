import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = false;
  bool _isMusicEnabled = false;
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(
          'https://youtu.be/miPYq1uIKmY?list=PLOv3-AK0iiMZgTkJkehDyxwj3-R5L5Nep')!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        loop: true, // Loop the music if needed
        hideThumbnail: true,
      ),
    );
  }

  _loadNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? false;
    });
  }

  _saveNotificationSettings(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', value);
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller when the screen is closed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: Provider.of<ThemeProvider>(context).themeMode ==
                  ThemeMode.dark,
              onChanged: (bool value) {
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme();
              },
            ),
          ),
          ListTile(
            title: const Text('Notifications'),
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  _notificationsEnabled = value;
                });
                _saveNotificationSettings(value);
              },
            ),
          ),
          ListTile(
            title: const Text('Background Music'),
            trailing: Switch(
              value: _isMusicEnabled,
              onChanged: (bool value) {
                setState(() {
                  _isMusicEnabled = value;
                  if (_isMusicEnabled) {
                    _controller.play();
                  } else {
                    _controller.pause();
                  }
                });
              },
            ),
          ),
          ListTile(
            title: const Text('About'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutPage()),
              );
            },
          ),
          // Add the YouTube player with AspectRatio to hide the video
          if (_isMusicEnabled)
            AspectRatio(
              aspectRatio: 16 / 9,
              child: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: false,
                onReady: () {
                  // Optionally, handle actions when the video is ready to play
                },
              ),
            ),
        ],
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Food Distribution Network',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(
              'Version 1.0.0',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            Text(
              'This app is designed to optimize food distribution networks, manage inventory, and engage consumers in sustainable food practices.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Text(
              'Features:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            _buildFeatureItem(context, 'Route Optimization'),
            _buildFeatureItem(context, 'Inventory Management'),
            _buildFeatureItem(context, 'Consumer Engagement'),
            _buildFeatureItem(context, 'Sustainability Tips'),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, String feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green),
          const SizedBox(width: 8),
          Text(feature, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
