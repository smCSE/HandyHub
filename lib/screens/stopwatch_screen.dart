import 'package:flutter/material.dart';
import 'dart:async';

class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({super.key});

  @override
  _StopwatchScreenState createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  final List<String> _lapTimes = [];
  int _lapCounter = 1;

  void _startStopwatch() {
    if (!_stopwatch.isRunning) {
      _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
        setState(() {});
      });
      _stopwatch.start();
    }
  }

  void _stopStopwatch() {
    _stopwatch.stop();
    _timer?.cancel();
  }

  void _resetStopwatch() {
    _stopwatch.reset();
    setState(() {
      _lapTimes.clear();
      _lapCounter = 1;
    });
  }

  void _recordLap() {
    if (_stopwatch.isRunning) {
      String lapTime =
          '${_stopwatch.elapsed.inMinutes.toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inMilliseconds % 1000).toString().padLeft(3, '0')}';

      setState(() {
        if (_lapCounter <= 4) {
          _lapTimes.add('Lap $_lapCounter: $lapTime');
          _lapCounter++;
        }
        if (_lapCounter > 4) {
          _stopStopwatch();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Stopwatch')),
        backgroundColor: Color(0xFFA5B68D), // Title background color
        elevation: 0,
      ),
      body: Container(
        color: Color(0xFFADB2D4), // Body background color
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Stopwatch Time Display with Milliseconds
                Text(
                  '${_stopwatch.elapsed.inMinutes.toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inMilliseconds % 1000).toString().padLeft(3, '0')}',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                // Control Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildButton('Start', _startStopwatch, Colors.blue),
                    SizedBox(width: 10),
                    _buildButton('Stop', _stopStopwatch, Colors.red),
                    SizedBox(width: 10),
                    _buildButton('Reset', _resetStopwatch, Colors.grey),
                  ],
                ),
                SizedBox(height: 20),
                // Lap Button
                _buildButton('Lap', _recordLap, Colors.green),
                SizedBox(height: 20),
                // Lap Times List
                Expanded(
                  child: ListView.builder(
                    itemCount: _lapTimes.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          _lapTimes[index],
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper function to build buttons with stylish design
  ElevatedButton _buildButton(
      String text, VoidCallback onPressed, Color color) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
        shadowColor: Colors.black.withOpacity(0.4),
        textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      child: Text(text),
    );
  }
}
