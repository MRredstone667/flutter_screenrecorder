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
      home: const MultitaskingHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MultitaskingHome extends StatefulWidget {
  const MultitaskingHome({super.key});

  @override
  State<MultitaskingHome> createState() => _MultitaskingHomeState();
}

class _MultitaskingHomeState extends State<MultitaskingHome> {
  static const platform = MethodChannel('com.multitasking/broadcast');
  String status = "No Signal :(";

  Future<void> _start() async {
    try {
      await platform.invokeMethod('startBroadcast');
      setState(() => status = "Broadcasting...");
    } catch (e) {
      setState(() => status = "Error: $e");
    }
  }

  Future<void> _stop() async {
    try {
      await platform.invokeMethod('stopBroadcast');
      setState(() => status = "No Signal :(");
    } catch (e) {
      setState(() => status = "Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AspectRatio(
            aspectRatio: MediaQuery.of(context).size.aspectRatio,
            child: Container(
              color: Colors.grey[900],
              alignment: Alignment.center,
              child: Text(
                status,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _start,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text("START"),
              ),
              ElevatedButton(
                onPressed: _stop,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("STOP"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
