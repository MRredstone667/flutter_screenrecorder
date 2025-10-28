import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const platform = MethodChannel('com.example.replaykit/broadcast');
  bool isBroadcasting = false;
  String status = "No Signal :(";

  Future<void> startBroadcast() async {
    try {
      final result = await platform.invokeMethod('startRecording');
      setState(() {
        isBroadcasting = true;
        status = "Broadcasting...";
      });
      print(result);
    } on PlatformException catch (e) {
      print("Error: ${e.message}");
    }
  }

  Future<void> stopBroadcast() async {
    try {
      final result = await platform.invokeMethod('stopRecording');
      setState(() {
        isBroadcasting = false;
        status = "No Signal :(";
      });
      print(result);
    } on PlatformException catch (e) {
      print("Error: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: isLandscape ? 16 / 9 : 9 / 16,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        border: Border.all(color: Colors.white30, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          status,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: isBroadcasting ? null : startBroadcast,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size(120, 50),
                      ),
                      child: const Text("START",
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                    ElevatedButton(
                      onPressed: isBroadcasting ? stopBroadcast : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: const Size(120, 50),
                      ),
                      child: const Text("STOP",
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
