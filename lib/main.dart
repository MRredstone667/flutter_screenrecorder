import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MultitaskingApp());
}

class MultitaskingApp extends StatelessWidget {
  const MultitaskingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multitasking',
      theme: ThemeData.dark(),
      home: const BroadcastScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BroadcastScreen extends StatefulWidget {
  const BroadcastScreen({super.key});

  @override
  State<BroadcastScreen> createState() => _BroadcastScreenState();
}

class _BroadcastScreenState extends State<BroadcastScreen> {
  static const platform = MethodChannel('com.example.flutterAppAndrejs/broadcast');
  bool _isBroadcasting = false;

  Future<void> _startBroadcast() async {
    try {
      await platform.invokeMethod('startBroadcast');
      setState(() => _isBroadcasting = true);
    } on PlatformException catch (e) {
      debugPrint("Failed to start broadcast: ${e.message}");
    }
  }

  Future<void> _stopBroadcast() async {
    try {
      await platform.invokeMethod('stopBroadcast');
      setState(() => _isBroadcasting = false);
    } on PlatformException catch (e) {
      debugPrint("Failed to stop broadcast: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multitasking Live Broadcast'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Live preview square
          Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blueAccent, width: 3),
              color: Colors.black,
            ),
            child: const LivePreviewWidget(),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: _isBroadcasting ? _stopBroadcast : _startBroadcast,
            icon: Icon(_isBroadcasting ? Icons.stop : Icons.play_arrow),
            label: Text(_isBroadcasting ? "Stop Broadcast" : "Start Broadcast"),
            style: ElevatedButton.styleFrom(
              backgroundColor: _isBroadcasting ? Colors.red : Colors.green,
              minimumSize: const Size(180, 50),
            ),
          ),
        ],
      ),
    );
  }
}

class LivePreviewWidget extends StatelessWidget {
  const LivePreviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulovaný náhled (černý čtverec s textem)
    return const Center(
      child: Text(
        "🎥 Live Preview",
        style: TextStyle(color: Colors.white70, fontSize: 18),
      ),
    );
  }
}
