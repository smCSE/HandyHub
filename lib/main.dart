import 'package:flutter/material.dart';
import 'package:handy_hub/screens/weather_screen.dart';
import 'package:handy_hub/screens/stopwatch_screen.dart';
import 'package:handy_hub/screens/water_timer_screen.dart';
import 'package:handy_hub/screens/translator_screen.dart';
import 'package:handy_hub/screens/PdfScannerScreen.dart'; // Replaced Compass with PDF Scanner

void main() {
  runApp(const MultiServiceApp());
}

class MultiServiceApp extends StatefulWidget {
  const MultiServiceApp({super.key});

  @override
  _MultiServiceAppState createState() => _MultiServiceAppState();
}

class _MultiServiceAppState extends State<MultiServiceApp> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    WeatherScreen(),
    StopwatchScreen(),
    WaterTimerScreen(),
    TranslatorScreen(),
    PdfScannerScreen(), // Replaced Compass with PDF Scanner
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.cloud), label: 'Weather'),
            BottomNavigationBarItem(
                icon: Icon(Icons.timer), label: 'Stopwatch'),
            BottomNavigationBarItem(
                icon: Icon(Icons.local_drink), label: 'Water'),
            BottomNavigationBarItem(
                icon: Icon(Icons.translate), label: 'Translate'),
            BottomNavigationBarItem(
                icon: Icon(Icons.picture_as_pdf),
                label: 'Scanner'), // Updated icon & label
          ],
        ),
      ),
    );
  }
}
