import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const FloatingMediaApp());
}

class FloatingMediaApp extends StatelessWidget {
  const FloatingMediaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Floating Media',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
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
  File? _selectedFile;
  VideoPlayerController? _controller;
  bool _isVideo = false;
  bool _loopVideo = true;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp4', 'mov', 'jpg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final isVideo = file.path.endsWith('.mp4') || file.path.endsWith('.mov');

      setState(() {
        _selectedFile = file;
        _isVideo = isVideo;
      });

      if (isVideo) {
        _controller?.dispose();
        _controller = VideoPlayerController.file(file)
          ..setLooping(_loopVideo)
          ..initialize().then((_) {
            setState(() {});
            _controller?.play();
          });
      }
    }
  }

  Widget _buildMediaPreview() {
    if (_selectedFile == null) {
      return const Center(
        child: Text(
          'No Signal :(',
          style: TextStyle(color: Colors.white54, fontSize: 20),
        ),
      );
    }

    if (_isVideo && _controller != null && _controller!.value.isInitialized) {
      return AspectRatio(
        aspectRatio: _controller!.value.aspectRatio,
        child: VideoPlayer(_controller!),
      );
    }

    // obrázek
    return Image.file(_selectedFile!, fit: BoxFit.contain);
  }

  void _togglePlayPause() {
    if (_controller == null) return;
    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
      } else {
        _controller!.play();
      }
    });
  }

  void _stopPlayback() {
    if (_controller != null) {
      _controller!.pause();
      _controller!.seekTo(Duration.zero);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Floating Media'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.2), // ✅ opraveno (místo withOpacity)
                  border: Border.all(color: Colors.white24),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _buildMediaPreview(),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.upload_file),
                label: const Text('Vybrat soubor'),
              ),
              ElevatedButton.icon(
                onPressed: _togglePlayPause,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Přehrát / Pauza'),
              ),
              ElevatedButton.icon(
                onPressed: _stopPlayback,
                icon: const Icon(Icons.stop),
                label: const Text('Stop'),
              ),
            ],
          ),
          if (_isVideo)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: _loopVideo,
                  onChanged: (val) {
                    setState(() {
                      _loopVideo = val ?? true;
                      _controller?.setLooping(_loopVideo);
                    });
                  },
                ),
                const Text('Přehrávat ve smyčce'),
              ],
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
