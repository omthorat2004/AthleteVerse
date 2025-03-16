import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class CommentaryGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CommentaryGameScreen(),
    );
  }
}

class CommentaryGameScreen extends StatefulWidget {
  @override
  _CommentaryGameScreenState createState() => _CommentaryGameScreenState();
}

class _CommentaryGameScreenState extends State<CommentaryGameScreen> {
  late VideoPlayerController _videoController;
  FlutterSoundRecorder? _audioRecorder;
  FlutterSoundPlayer? _audioPlayer;
  bool _isRecording = false;
  bool _isVideoInitialized = false;
  String? _audioPath;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    _initializeAudio();
  }

  void _initializeVideo() async {
    _videoController = VideoPlayerController.network(
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
    )..addListener(() => setState(() {}))
     ..setLooping(true)
     ..initialize().then((_) {
        setState(() {
          _isVideoInitialized = true;
        });
        _videoController.play();
     }).catchError((error) {
        print("Video initialization error: $error");
     });
  }

  Future<void> _initializeAudio() async {
    _audioRecorder = FlutterSoundRecorder();
    _audioPlayer = FlutterSoundPlayer();
    await Permission.microphone.request();
    await Permission.storage.request();
    await _audioRecorder!.openRecorder();
    await _audioPlayer!.openPlayer();
  }

  Future<void> _startRecording() async {
    Directory tempDir = await getTemporaryDirectory();
    String path = '${tempDir.path}/commentary.wav';
    await _audioRecorder!.startRecorder(toFile: path);
    setState(() {
      _isRecording = true;
      _audioPath = path;
    });
  }

  Future<void> _stopRecording() async {
    await _audioRecorder!.stopRecorder();
    setState(() {
      _isRecording = false;
    });
  }

  Future<void> _playCommentary() async {
    if (_audioPath != null) {
      await _audioPlayer!.startPlayer(fromURI: _audioPath!);
    }
  }

  void _uploadCommentary() {
    if (_audioPath != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Uploading Commentary... (Backend Integration Pending)")),
      );
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    _audioRecorder?.closeRecorder();
    _audioPlayer?.closePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Athlete Commentary Game'),
        backgroundColor: Colors.green
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _isVideoInitialized
                ? AspectRatio(
                    aspectRatio: _videoController.value.aspectRatio,
                    child: VideoPlayer(_videoController),
                  )
                : Container(
                    height: 300,
                    child: Center(child: CircularProgressIndicator()),
                  ),
            SizedBox(height: 20),
            _isRecording
                ? ElevatedButton(
                    onPressed: _stopRecording,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Text("⏹️ Stop Commentary"),
                  )
                : ElevatedButton(
                    onPressed: _startRecording,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: Text("🎙️ Start Commentary"),
                  ),
            if (_audioPath != null) ...[
              SizedBox(height: 20),
              Text("🎧 Your Commentary", style: TextStyle(color: Colors.white, fontSize: 16)),
              IconButton(
                icon: Icon(Icons.play_arrow, color: Colors.white, size: 40),
                onPressed: _playCommentary,
              ),
              ElevatedButton(
                onPressed: _uploadCommentary,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: Text("📤 Upload Commentary"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
