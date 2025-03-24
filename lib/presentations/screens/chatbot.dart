import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({Key? key}) : super(key: key);

  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;
  late AnimationController _sendButtonController;
  late AnimationController _iconController;
  IconData _chatIcon = Icons.chat;

  static const String _geminiApiKey = 'AIzaSyC5_BohoCq2FciyWygsF8taFBlQmBfekH0';
  static const String _geminiApiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  final List<String> _predefinedPrompts = [
    "How can I improve my performance?",
    "What are the best exercises for endurance?",
    "How do I prevent sports injuries?",
    "What should I eat before a competition?",
    "How can I manage stress during competitions?",
  ];

  @override
  void initState() {
    super.initState();
    _sendButtonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _sendButtonController.dispose();
    _iconController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _sendMessage(String message, {List<PlatformFile>? files}) async {
    if (message.isEmpty && (files == null || files.isEmpty)) return;

    setState(() {
      _messages.add({'role': 'user', 'message': message, 'files': files});
      _isLoading = true;
      _chatIcon = Icons.hourglass_top; // Change icon to loading state
    });

    _sendButtonController.forward();
    _iconController.forward();

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_geminiApiUrl?key=$_geminiApiKey'),
      );

      request.fields['contents'] = jsonEncode([
        {
          'parts': [
            {'text': message},
            if (files != null)
              for (var file in files)
                {'file': file.name, 'data': base64Encode(file.bytes!)}
          ]
        }
      ]);

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final botMessage = jsonDecode(responseData)['candidates'][0]['content']['parts'][0]['text'];

        setState(() {
          _messages.add({'role': 'bot', 'message': botMessage});
          _chatIcon = Icons.chat; // Change icon back to chat
        });
      } else {
        throw Exception('Failed to load response: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _messages.add({'role': 'bot', 'message': 'Error: $e'});
        _chatIcon = Icons.error; // Change icon to error state
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
      _sendButtonController.reverse();
      _iconController.reverse();
    }
  }

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'mp3', 'mp4'],
    );

    if (result != null) {
      _sendMessage(_textController.text.trim(), files: result.files);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Athlete Assistant'),
        backgroundColor: const Color(0xFF2979FF),
        elevation: 4,
        centerTitle: true,
        actions: [
          AnimatedBuilder(
            animation: _iconController,
            builder: (context, child) {
              return RotationTransition(
                turns: Tween(begin: 0.0, end: 1.0).animate(_iconController),
                child: Icon(
                  _chatIcon,
                  color: Colors.white,
                ),
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade50, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isUser = message['role'] == 'user';

                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Align(
                      key: ValueKey(message['message']),
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isUser ? const Color(0xFF2979FF) : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (message['files'] != null)
                              for (var file in message['files'])
                                Text(
                                  'File: ${file.name}',
                                  style: TextStyle(
                                    color: isUser ? Colors.white : Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                            Text(
                              message['message'] ?? '',
                              style: TextStyle(
                                color: isUser ? Colors.white : Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(
                color: const Color(0xFF2979FF),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _predefinedPrompts.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ActionChip(
                          label: Text(_predefinedPrompts[index]),
                          backgroundColor: Colors.blue.shade100,
                          onPressed: () {
                            _sendMessage(_predefinedPrompts[index]);
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.attach_file, color: Color(0xFF2979FF)),
                      onPressed: _pickFiles,
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _textController,
                                decoration: const InputDecoration(
                                  hintText: 'Type your message...',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                            ScaleTransition(
                              scale: CurvedAnimation(
                                parent: _sendButtonController,
                                curve: Curves.easeInOut,
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.send, color: Color(0xFF2979FF)),
                                onPressed: () {
                                  final message = _textController.text.trim();
                                  if (message.isNotEmpty) {
                                    _sendMessage(message);
                                    _textController.clear();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}