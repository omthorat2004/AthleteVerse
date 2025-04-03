import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:video_player/video_player.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;
  late AnimationController _iconController;
  late VideoPlayerController _videoController;
  IconData _chatIcon = Icons.chat;
  String? _replyingToId;
  String? _replyingToText;
  bool _showIntroVideo = true;
  bool _isVideoInitialized = false;

  static const String _apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=AIzaSyBYNdVzAC6412yfRCH-Huxr5Vuqjm6UV90';

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _videoController = VideoPlayerController.asset("animations.mp4")
      ..initialize().then((_) {
        setState(() {
          _isVideoInitialized = true;
        });
        _videoController.play();
        _videoController.setLooping(true);
        
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _showIntroVideo = false;
              _videoController.pause();
            });
          }
        });
      });
  }

  @override
  void dispose() {
    _iconController.dispose();
    _textController.dispose();
    _videoController.dispose();
    super.dispose();
  }

  void _startReply(String messageId, String messageText) {
    setState(() {
      _replyingToId = messageId;
      _replyingToText = messageText;
      _textController.text = "Replying to: $messageText\n";
      _textController.selection = TextSelection.fromPosition(
        TextPosition(offset: _textController.text.length),
      );
    });
  }

  void _cancelReply() {
    setState(() {
      _replyingToId = null;
      _replyingToText = null;
      _textController.clear();
    });
  }

  Future<void> _sendMessage(String message) async {
    if (message.isEmpty) return;

    final fullMessage = _replyingToId != null 
      ? "Replying to [$_replyingToText]: $message"
      : message;

    setState(() {
      _messages.insert(0, {
        'role': 'user', 
        'message': fullMessage,
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'replyToId': _replyingToId,
        'replyToText': _replyingToText,
      });
      _isLoading = true;
      _chatIcon = Icons.hourglass_top;
      _replyingToId = null;
      _replyingToText = null;
    });

    _iconController.forward();

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": "You are an AI assistant for an Athlete Management App. Provide concise, professional advice on training, nutrition, injury recovery, and performance analytics.\n\nUser: $fullMessage"}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final botMessage = responseData['candidates']?[0]['content']?['parts']?[0]['text'] ?? 'No response';

        setState(() {
          _messages.insert(0, {
            'role': 'bot', 
            'message': botMessage,
            'id': DateTime.now().millisecondsSinceEpoch.toString(),
          });
          _chatIcon = Icons.chat;
        });
      } else {
        throw Exception('Failed to get a response. Status: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _messages.insert(0, {
          'role': 'bot', 
          'message': 'Error: $e',
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
        });
        _chatIcon = Icons.error;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
      _iconController.reverse();
    }
  }

  Widget _buildReplyIndicator(String? replyToText) {
    if (replyToText == null) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.reply, size: 16, color: Colors.grey),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              replyToText,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final inputFieldHeight = 48.0; // Standard height for TextField

    return Scaffold(
      appBar: AppBar(
        title: const Text('GameGuru', style: TextStyle(color: Colors.white)),
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
          if (_showIntroVideo && _isVideoInitialized)
            SizedBox(
              height: 200,
              width: double.infinity,
              child: VideoPlayer(_videoController),
            ),

          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: EdgeInsets.only(
                bottom: inputFieldHeight + 16,
                left: 16,
                right: 16,
                top: 16,
              ),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isLoading && index == 0) {
                  return const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Text('Thinking...',
                          style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey)),
                    ),
                  );
                }
                final message = _messages[index - (_isLoading ? 1 : 0)];
                final isUser = message['role'] == 'user';
                return GestureDetector(
                  onLongPress: () {
                    if (!isUser) {
                      _startReply(message['id'], message['message']);
                    }
                  },
                  child: Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.8,
                      ),
                      child: Column(
                        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          if (message['replyToText'] != null)
                            _buildReplyIndicator(message['replyToText']),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: isUser ? const Color(0xFF2979FF) : Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: isUser
                                ? Text(
                                    message['message'],
                                    style: const TextStyle(color: Colors.white, fontSize: 16),
                                  )
                                : MarkdownBody(
                                    data: message['message'],
                                    styleSheet: MarkdownStyleSheet(
                                      p: const TextStyle(fontSize: 16),
                                      strong: const TextStyle(fontWeight: FontWeight.bold),
                                      blockquote: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                                    ),
                                  ),
                          ),
                          if (!isUser)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: TextButton(
                                onPressed: () => _startReply(message['id'], message['message']),
                                child: const Text(
                                  'Reply',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
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

          if (_replyingToText != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.grey[200],
              child: Row(
                children: [
                  const Icon(Icons.reply, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Replying to: $_replyingToText",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 16),
                    onPressed: _cancelReply,
                  ),
                ],
              ),
            ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!_showIntroVideo && _isVideoInitialized)
                  Container(
                    width: 60,
                    height: inputFieldHeight,
                    margin: const EdgeInsets.only(right: 8),
                    child: ClipRRect(
    borderRadius: BorderRadius.circular(10), 
    child: VideoPlayer(_videoController),
  ),
                  ),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF2979FF)),
                  onPressed: () {
                    final message = _textController.text.trim();
                    if (message.isNotEmpty) {
                      _sendMessage(message);
                      _textController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}