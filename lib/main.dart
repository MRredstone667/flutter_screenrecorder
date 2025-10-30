import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const FloatingVideoApp());
}

class FloatingVideoApp extends StatelessWidget {
  const FloatingVideoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Floating Media Player',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const FloatingMediaHome(),
    );
  }
}

class FloatingMediaHome extends StatefulWidget {
  const FloatingMediaHome({super.key});

  @override
  State<FloatingMediaHome> createState() => _FloatingMediaHomeState();
}

class _FloatingMediaHomeState extends State<FloatingMediaHome> {
  File? selectedFile;
  VideoPlayerController? videoController;
  bool isVideo = false;
  bool isFloating = false;

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp4', 'mov', 'png', 'jpg', 'jpeg'],
    );

    if (result != null) {
      final file = File(result.files.single.path!);
      final ext = file.path.split('.').last.toLowerCase();

      setState(() {
        selectedFile = file;
        isVideo = ['mp4', 'mov'].contains(ext);
        isFloating = false;
      });

      if (isVideo) {
        videoController?.dispose();
        videoController = VideoPlayerController.file(file)
          ..setLooping(true)
          ..initialize().then((_) {
            setState(() {});
            videoController!.play();
          });
      }
    }
  }

  void toggleFloating() {
    setState(() {
      isFloating = !isFloating;
    });
  }

  @override
  void dispose() {
    videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Floating Media Player'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Center(
            child: selectedFile == null
                ? const Text(
                    'No Signal :(',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w300),
                  )
                : isVideo
                    ? AspectRatio(
                        aspectRatio: videoController!.value.aspectRatio,
                        child: VideoPlayer(videoController!),
                      )
                    : Image.file(selectedFile!),
          ),
          if (isFloating && selectedFile != null)
            Positioned(
              right: 20,
              bottom: 20,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    final pos = Offset(
                      details.globalPosition.dx,
                      details.globalPosition.dy,
                    );
                  });
                },
                child: Container(
                  width: 180,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white30),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: isVideo
                      ? VideoPlayer(videoController!)
                      : Image.file(selectedFile!, fit: BoxFit.cover),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: pickFile,
              icon: const Icon(Icons.upload_file),
              label: const Text('Vybrat soubor'),
            ),
            ElevatedButton.icon(
              onPressed: selectedFile != null ? toggleFloating : null,
              icon: const Icon(Icons.picture_in_picture),
              label: Text(isFloating ? 'Zavřít mini okno' : 'Zobrazit mini okno'),
            ),
            if (isVideo)
              Checkbox(
                value: videoController?.value.isLooping ?? false,
                onChanged: (val) {
                  videoController?.setLooping(val ?? true);
                  setState(() {});
                },
              ),
          ],
        ),
      ),
    );
  }
}
