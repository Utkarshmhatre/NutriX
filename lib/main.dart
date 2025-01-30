import 'package:flutter/material.dart';
import 'package:food_distribution_network/splash_screen.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Food Distribution Network',
          theme: ThemeData.light().copyWith(
            primaryColor: Colors.black,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
                elevation: 5,
                shadowColor: Colors.black.withOpacity(0.5),
              ),
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              elevation: 8,
              splashColor: Colors.grey.withOpacity(0.3),
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            primaryColor: Colors.white,
            scaffoldBackgroundColor: Colors.black,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                elevation: 5,
                shadowColor: Colors.white.withOpacity(0.5),
              ),
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 8,
              splashColor: Colors.grey.withOpacity(0.3),
            ),
          ),
          themeMode: themeProvider.themeMode,
          home: SplashScreen(),
        );
      },
    );
  }
}
