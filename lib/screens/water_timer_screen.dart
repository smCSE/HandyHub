import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

class WaterTimerScreen extends StatefulWidget {
  const WaterTimerScreen({super.key});

  @override
  _WaterTimerScreenState createState() => _WaterTimerScreenState();
}

class _WaterTimerScreenState extends State<WaterTimerScreen> {
  bool _isTimerActive = false;
  int _timerMinutes = 1; // Default time (in minutes)
  int _remainingTime = 0; // Time left for the countdown
  Timer? _timer;
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  // Timer durations in minutes for the dropdown (1 to 10 minutes)
  final List<int> _timeOptions = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  @override
  void initState() {
    super.initState();
    // Initialize the local notification plugin
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _initializeNotifications();
  }

  // Initialize notification plugin
  void _initializeNotifications() async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon'); // Set your app icon here
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin!.initialize(initializationSettings);
  }

  // Show notification after timer finishes
  void _showNotification() async {
    var androidDetails = AndroidNotificationDetails(
      'water_reminder_channel',
      'Water Reminder',
      channelDescription: 'Water reminder notifications',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    var generalNotificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin!.show(
      0,
      'Water Reminder',
      'It\'s time to drink water!',
      generalNotificationDetails,
    );

    // Show dialog to ask user if they want to reset the timer
    _showResetDialog();
  }

  // Show a dialog after notification to ask whether to reset the timer or not
  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Timer Finished'),
          content: Text('Would you like to start the timer again?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _restartTimer();
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _stopTimer();
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  // Restart the timer after the notification
  void _restartTimer() {
    setState(() {
      _remainingTime = _timerMinutes * 60; // Reset the time
    });

    // Restart the timer
    _startTimer();
  }

  // Stop the timer
  void _stopTimer() {
    setState(() {
      _isTimerActive = false;
    });

    _timer?.cancel();
  }

  // Toggle Timer On/Off
  void _toggleTimer() {
    if (_isTimerActive) {
      // If timer is on, cancel the repeated timer
      _timer?.cancel();
    } else {
      // Reset remaining time
      _remainingTime = _timerMinutes * 60;

      // If timer is off, start the countdown
      _startTimer();
    }

    setState(() {
      _isTimerActive = !_isTimerActive;
    });
  }

  // Start the timer
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _showNotification();
          _timer?.cancel();
        }
      });
    });
  }

  // Change timer duration based on dropdown selection
  void _changeTime(int? selectedValue) {
    if (selectedValue != null) {
      setState(() {
        _timerMinutes = selectedValue;
        _remainingTime = _timerMinutes * 60; // Reset remaining time
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Water Reminder')),
        backgroundColor: Color(0xFFA5B68D), // Title background color
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFADB2D4), // Body background color
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Dropdown menu to select timer
                    SizedBox(
                      width: double.infinity,
                      child: DropdownButton<int>(
                        value: _timerMinutes,
                        isExpanded: true,
                        items: _timeOptions.map((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(
                              '$value Minutes',
                              style: TextStyle(fontSize: 18),
                            ),
                          );
                        }).toList(),
                        onChanged: _changeTime,
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        dropdownColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 30),
                    // Timer Display (shows the remaining time)
                    Text(
                      '${(_remainingTime ~/ 60).toString().padLeft(2, '0')}:${(_remainingTime % 60).toString().padLeft(2, '0')}',
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 30),
                    // Toggle Timer Button
                    ElevatedButton(
                      onPressed: _toggleTimer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _isTimerActive ? Colors.redAccent : Colors.green,
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        _isTimerActive ? 'Stop Timer' : 'Start Timer',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Timer Status Text
                    Text(
                      _isTimerActive
                          ? 'Reminder set for every $_timerMinutes minutes.'
                          : 'Timer is off.',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
