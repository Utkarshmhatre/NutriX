import 'package:flutter/material.dart';
import 'distribution_screen.dart';
import 'inventory_screen.dart';
import 'consumer_screen.dart';
import 'settings_screen.dart';
import 'esg_details_screen.dart';
import 'ai_chatbot_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ESGDetailsScreen(),
    const DistributionScreen(),
    const InventoryScreen(),
    const ConsumerScreen(),
    const AIChatbotScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Theme.of(context).primaryColor.withOpacity(0.5),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.eco),
              label: 'ESG',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Distribution',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2),
              label: 'Inventory',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Consumer',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'AI Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
