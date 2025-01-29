import 'dart:ui';

import 'package:flutter/material.dart';
import 'distribution_screen.dart';
import 'inventory_screen.dart';
import 'consumer_screen.dart';
import 'settings_screen.dart';
import 'esg_details_screen.dart';
import 'ai_chatbot_screen.dart';
import 'warehouse_management_screen.dart';

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
    const WarehouseManagementScreen(),
    const SettingsScreen(),
  ];

  final List<String> _labels = [
    'ESG',
    'Distribution',
    'Inventory',
    'Consumer',
    'AI Chat',
    'Warehouses',
    'Settings'
  ];

  @override
  Widget build(BuildContext context) {
    // Check current theme brightness (light or dark mode)
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: isDarkMode
                ? Color.fromARGB(
                    255, 29, 36, 51) // Dark mode: Dark blue background
                : Color.fromARGB(255, 108, 0, 128)
                    .withOpacity(0.9), // Light mode: Purple with opacity
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: 6.0, sigmaY: 6.0), // Apply blur for glass effect
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              type: BottomNavigationBarType.fixed,
              backgroundColor:
                  Colors.transparent, // Transparent to show glass effect
              selectedItemColor: Colors.white, // White for the selected item
              unselectedItemColor: Colors.white
                  .withOpacity(0.7), // Slight opacity for unselected items
              items: List.generate(_labels.length, (index) {
                return BottomNavigationBarItem(
                  icon: index == _currentIndex
                      ? Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white, // White bg for active icon
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _getIconForIndex(index),
                            color: isDarkMode
                                ? Color.fromARGB(
                                    255, 110, 3, 129) // Dark mode purple
                                : Colors.purple, // Light mode purple
                          ),
                        )
                      : Icon(
                          _getIconForIndex(index),
                          color: Colors.white.withOpacity(
                              0.7), // Slight opacity for unselected items
                        ),
                  label: index == _currentIndex
                      ? _labels[index]
                      : '', // Show full label only when selected
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.eco;
      case 1:
        return Icons.map;
      case 2:
        return Icons.inventory_2;
      case 3:
        return Icons.people;
      case 4:
        return Icons.chat;
      case 5:
        return Icons.warehouse;
      case 6:
        return Icons.settings;
      default:
        return Icons.home;
    }
  }
}

class _ConsumerScreenState extends State<ConsumerScreen> {
  late Future<void> _fetchDataFuture;

  @override
  void initState() {
    super.initState();
    _fetchDataFuture = _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      await Future.delayed(Duration(seconds: 2)); // Simulate network delay
      if (mounted) {
        setState(() {});
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Consumer Screen')),
      body: FutureBuilder<void>(
        future: _fetchDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(child: Text('Data Loaded'));
          }
        },
      ),
    );
  }
}
