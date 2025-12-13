import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

const channel = MethodChannel('com.yourapp.pip');

class HomePage extends StatelessWidget {
  // výběr videa
  Future<void> pickVideo() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result != null) {
      final path = result.files.single.path!;
      await channel.invokeMethod('playVideoInPiP', {'path': path});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Vyber video a pusť do PiP')),
      floatingActionButton: FloatingActionButton(
        onPressed: pickVideo,
        child: Icon(Icons.picture_in_picture),
      ),
    );
  }
}
