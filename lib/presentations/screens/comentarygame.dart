
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart' as permision;
import 'package:record/record.dart';
import 'package:video_player/video_player.dart';


class CommentaryGameApp extends StatelessWidget {
  const CommentaryGameApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CommentaryGameScreen(),
    );
  }
}

class CommentaryGameScreen extends StatefulWidget {
  const CommentaryGameScreen({super.key});
  @override
  CommentaryGameScreenState createState() => CommentaryGameScreenState();
}

class CommentaryGameScreenState extends State<CommentaryGameScreen> {
  VideoPlayerController? _videoController;
  late AudioRecorder _audioRecorder;
  String? _audioPath;
  bool _isRecording = false;
  bool _isVideoInitialized = false;

  @override
  void initState() { super.initState();
    _initializeVideo();
    _initializeAudio();
  }

  void _initializeVideo() async {
    _videoController = VideoPlayerController.networkUrl(
        Uri.parse(
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4'));
    try {
      await _videoController?.setLooping(true);
      await _videoController?.initialize();
      setState(() {
        _isVideoInitialized = true;
      });
     await _videoController?.play();
    } catch (error) {
      _showSnackBar("Video initialization error: $error");
    }
  }

  Future<void> _initializeAudio() async {
    _audioRecorder = AudioRecorder();
    final permision.PermissionStatus micStatus = await permision.Permission.microphone.request();
    if (micStatus.isGranted) {
      _showSnackBar("Microphone permission granted");
    } else if (micStatus.isDenied || micStatus.isRestricted || micStatus.isLimited) {
        _showSnackBar("Microphone permission not granted");
    } else if (micStatus.isPermanentlyDenied) {
      _showSnackBar("Microphone permission permanently denied");
    }
  }

  Future<void> _startRecording() async {
    if (_videoController?.value.isInitialized == true) {
      await _videoController?.pause();
      try {
        final directory = await getTemporaryDirectory();
        final audioFileName = 'commentary.wav';
        final audioPathTemp = path.join(directory.path, audioFileName);
        _audioPath = audioPathTemp;
        await _audioRecorder.startRecorder(toFile: _audioPath);
        setState(() {
          _isRecording = true;
        });
      } catch (e) {
        _showSnackBar('Error starting recording: $e');
      }
    } else {
      _showSnackBar("Video is not initialized");
    }
  }

  Future<void> _stopRecording() async {
    if (_isRecording) {
      if (await _audioRecorder.isRecording()) {
        try {
          await _audioRecorder.stop();
          setState(() {
            _isRecording = false;
          });
        } catch (e) {
          _showSnackBar('Error stopping recording: $e');
        }
      } else {
        setState(() {
          _isRecording = false;
        });
      }
    }
  }

  Future<void> _playCommentary() async {
    if (_audioPath != null && !await _audioRecorder.isRecording()) {
      try {
        await _audioRecorder.playFromFile(file: _audioPath!);
      } catch (e) {
        _showSnackBar("Error playing commentary");
      }
    }
  }

  void _togglePlayPause() {
    if (_videoController != null && _videoController!.value.isInitialized) {
      _videoController!.value.isPlaying ? _videoController?.pause() : _videoController?.play();
      setState(() {});
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    if (_audioRecorder.isRecordingSync) {
      _audioRecorder.dispose();
    } else {
      _audioRecorder.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Athlete Commentary Game'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isVideoInitialized &&
                _videoController != null &&
                _videoController!.value.isInitialized)
              GestureDetector(
                onTap: _togglePlayPause,
                child: AspectRatio(
                  aspectRatio: _videoController!.value.aspectRatio,
                  child: VideoPlayer(_videoController!),
              ),
             const SizedBox(height: 20),
             if (_isRecording)
              ElevatedButton.icon(
                  onPressed: _stopRecording,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  icon: const Icon(Icons.stop, size: 24),
                  label: const Text("Stop Commentary"),
                ) else  ElevatedButton.icon(
                      onPressed: _startRecording,
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      icon: const Icon(Icons.mic, size: 24),
                      label: const Text("Start Commentary"))
            ),
             const SizedBox(height: 20),
             if (_audioPath != null)
              ElevatedButton.icon(
                  onPressed: _playCommentary,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  icon: const Icon(Icons.play_arrow, size: 24),
                  label: const Text("Play Commentary"),
                ),

            ],
          ],
        ),
      ),
    );
  }
  }
}

