import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class MultilingualDopingBlog extends StatefulWidget {
  const MultilingualDopingBlog({super.key});

  @override
  State<MultilingualDopingBlog> createState() => _MultilingualDopingBlogState();
}

class _MultilingualDopingBlogState extends State<MultilingualDopingBlog> {
  static const String _apiKey = 'AIzaSyBYNdVzAC6412yfRCH-Huxr5Vuqjm6UV90';
  late GenerativeModel _model;

  final Map<String, String> _englishContent = {
    'title': 'Doping in Indian Sports',
    'content': '''
Doping is a serious problem in Indian sports. Many athletes use banned substances to improve performance.

Common doping substances:
- Anabolic steroids
- Stimulants
- Diuretics

Health risks include:
• Heart problems
• Liver damage
• Mental health issues

We must promote clean sports in India.
'''
  };

  Map<String, String> _currentContent = {};
  bool _isLoading = false;
  String _selectedLanguage = 'English';

  final List<String> _supportedLanguages = [
    'English',
    'Hindi',
    'Tamil',
    'Telugu',
    'Bengali'
  ];

  @override
  void initState() {
    super.initState();
    _currentContent = Map.from(_englishContent);
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.3,
      ),
    );
  }

  Future<void> _handleLanguageChange(String language) async {
    if (language == 'English') {
      setState(() {
        _currentContent = Map.from(_englishContent);
        _selectedLanguage = language;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final content = await _translateContent(language, _englishContent['content']!);
      setState(() {
        _currentContent = {
          'title': 'Loading...', 
          'content': content,
        };
        _selectedLanguage = language;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<String> _translateContent(String language, String text) async {
    try {
      final prompt = '''
Translate the following sports medicine content to $language.
Maintain the exact same formatting with bullet points and structure.
Do not add any additional commentary or notes.

Text to translate:
$text
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text ?? 'Translation failed';
    } catch (e) {
      throw Exception('API Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentContent['title'] ?? 'Doping Blog'),
        centerTitle: true,
        actions: [
          _buildLanguageDropdown(),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _currentContent['title'] ?? '',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _currentContent['content'] ?? '',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                          fontSize: 16,
                        ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildLanguageDropdown() {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: DropdownButton<String>(
        value: _selectedLanguage,
        icon: _isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.translate),
        items: _supportedLanguages.map((String language) {
          return DropdownMenuItem<String>(
            value: language,
            child: Text(language),
          );
        }).toList(),
        onChanged: _isLoading ? null : (value) => _handleLanguageChange(value!),
      ),
    );
  }
}