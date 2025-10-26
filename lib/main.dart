import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReplayKit Start/Stop',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const platform = MethodChannel('com.example.replaykit/broadcast');

  bool _isBroadcasting = false;
  String _status = 'Ready';

  Future<void> _startBroadcast() async {
    setState(() {
      _status = 'Starting...';
    });
    try {
      final result = await platform.invokeMethod('startBroadcast');
      setState(() {
        _isBroadcasting = true;
        _status = result ?? 'Broadcast started';
      });
    } on PlatformException catch (e) {
      setState(() {
        _status = 'Error: ${e.message}';
      });
    }
  }

  Future<void> _stopBroadcast() async {
    setState(() {
      _status = 'Stopping...';
    });
    try {
      final result = await platform.invokeMethod('stopBroadcast');
      setState(() {
        _isBroadcasting = false;
        _status = result ?? 'Broadcast stopped';
      });
    } on PlatformException catch (e) {
      setState(() {
        _status = 'Error: ${e.message}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ReplayKit Start/Stop')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Status: $_status'),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _isBroadcasting ? null : _startBroadcast,
              icon: const Icon(Icons.fiber_manual_record),
              label: const Text('Start recording (share screen)'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _isBroadcasting ? _stopBroadcast : null,
              icon: const Icon(Icons.stop),
              label: const Text('Stop recording'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}