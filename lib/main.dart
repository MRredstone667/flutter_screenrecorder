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
      title: 'Media Viewer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const MediaPlayerScreen(),
    );
  }
}

class MediaPlayerScreen extends StatefulWidget {
  const MediaPlayerScreen({super.key});

  @override
  State<MediaPlayerScreen> createState() => _MediaPlayerScreenState();
}

class _MediaPlayerScreenState extends State<MediaPlayerScreen> {
  File? _selectedFile;
  VideoPlayerController? _controller;
  bool _isVideo = false;
  bool _isInitialized = false;

  Future<void> _pickMedia() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.media);
    if (result == null) return;

    final path = result.files.single.path!;
    final file = File(path);
    final extension = path.split('.').last.toLowerCase();

    setState(() {
      _selectedFile = file;
      _isVideo = ['mp4', 'mov', 'avi', 'mkv'].contains(extension);
      _isInitialized = false;
    });

    if (_isVideo) {
      _controller?.dispose();
      _controller = VideoPlayerController.file(file)
        ..initialize().then((_) {
          _controller!.setLooping(true);
          _controller!.play();
          setState(() {
            _isInitialized = true;
          });
        });
    }
  }

  void _togglePlayPause() {
    if (_controller == null || !_controller!.value.isInitialized) return;
    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
      } else {
        _controller!.play();
      }
    });
  }

  void _clearMedia() {
    _controller?.dispose();
    setState(() {
      _selectedFile = null;
      _controller = null;
      _isVideo = false;
      _isInitialized = false;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Widget _buildMediaView() {
    if (_selectedFile == null) {
      return const Center(
        child: Text(
          "No signal :(",
          style: TextStyle(fontSize: 24, color: Colors.grey),
        ),
      );
    }

    if (_isVideo) {
      if (_controller != null && _isInitialized) {
        return AspectRatio(
          aspectRatio: _controller!.value.aspectRatio,
          child: VideoPlayer(_controller!),
        );
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    } else {
      return Image.file(_selectedFile!, fit: BoxFit.contain);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Media Viewer')),
      body: Container(
        color: Colors.black,
        child: Center(child: _buildMediaView()),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: _pickMedia,
              icon: const Icon(Icons.upload_file),
              label: const Text("Nahrát"),
            ),
            ElevatedButton.icon(
              onPressed: _isVideo && _isInitialized ? _togglePlayPause : null,
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
