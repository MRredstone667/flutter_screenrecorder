import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PiP Video Viewer',
      theme: ThemeData.dark(useMaterial3: true),
      home: const MediaPlayerPage(),
    );
  }
}

class MediaPlayerPage extends StatefulWidget {
  const MediaPlayerPage({super.key});

  @override
  State<MediaPlayerPage> createState() => _MediaPlayerPageState();
}

class _MediaPlayerPageState extends State<MediaPlayerPage> {
  File? _selectedFile;
  VideoPlayerController? _controller;
  bool _isVideo = false;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.media,
    );

    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;
      final extension = path.split('.').last.toLowerCase();

      setState(() {
        _selectedFile = File(path);
        _isVideo = ['mp4', 'mov', 'avi', 'mkv'].contains(extension);
      });

      if (_isVideo) {
        _controller?.dispose();
        _controller = VideoPlayerController.file(_selectedFile!)
          ..initialize().then((_) {
            _controller!.setLooping(true);
            setState(() {});
          });
      }
    }
  }

  void _togglePlayPause() {
    if (_controller != null && _controller!.value.isInitialized) {
      setState(() {
        _controller!.value.isPlaying
            ? _controller!.pause()
            : _controller!.play();
      });
    }
  }

  void _clearMedia() {
    _controller?.dispose();
    setState(() {
      _selectedFile = null;
      _controller = null;
      _isVideo = false;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PiP Video Viewer')),
      body: Center(
        child: _selectedFile == null
            ? const Text(
                "No signal :(",
                style: TextStyle(fontSize: 24, color: Colors.grey),
              )
            : _isVideo
                ? _controller != null && _controller!.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: VideoPlayer(_controller!),
                      )
                    : const CircularProgressIndicator()
                : Image.file(_selectedFile!, fit: BoxFit.contain),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: _pickFile,
              icon: const Icon(Icons.upload_file),
              label: const Text("Nahrát"),
            ),
            ElevatedButton.icon(
              onPressed: _isVideo ? _togglePlayPause : null,
              icon: Icon(
                _controller != null && _controller!.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow,
              ),
              label: const Text("Přehrát"),
            ),
            ElevatedButton.icon(
              onPressed: _clearMedia,
              icon: const Icon(Icons.delete_forever),
              label: const Text("Vymazat"),
            ),
          ],
        ),
      ),
    );
  }
}
