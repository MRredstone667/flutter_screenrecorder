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
      home: RecorderPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RecorderPage extends StatefulWidget {
  @override
  State<RecorderPage> createState() => _RecorderPageState();
}

class _RecorderPageState extends State<RecorderPage> {
  static const platform = MethodChannel('com.example.flutterAppAndrejs/native');
  String status = 'Ready';

  Future<void> startRecording() async {
    final res = await platform.invokeMethod('startRecording');
    setState(() => status = res);
  }

  Future<void> stopRecording() async {
    final res = await platform.invokeMethod('stopRecording');
    setState(() => status = res);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(status, style: const TextStyle(color: Colors.white, fontSize: 20)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: startRecording,
              child: const Text("Start Recording"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: stopRecording,
              child: const Text("Stop Recording"),
            ),
          ],
        ),
      ),
    );
  }
}
