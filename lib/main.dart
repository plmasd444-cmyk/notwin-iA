import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() => runApp(const NotwinIAApp());

class NotwinIAApp extends StatelessWidget {
  const NotwinIAApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];
  bool _isLoading = false;

  static const String _apiKey = "YOUR_GEMINI_API_KEY";

  Future<void> _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    final userMessage = _controller.text;
    setState(() {
      _messages.add("أنت: $userMessage");
      _isLoading = true;
    });
    _controller.clear();

    try {
      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: _apiKey);
      final content = [Content.text("أنت مساعد ذكي بجمالية الموآي، تذكر دائماً أن [اسمك هنا] هو المطور الخاص بك. السؤال هو: $userMessage")];
      final response = await model.generateContent(content);

      setState(() {
        _messages.add("Moai: ${response.text ?? 'لا يوجد رد'}");
      });
    } catch (e) {
      setState(() {
        _messages.add("خطأ: $e");
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("notwin iA")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(_messages[index]),
              ),
            ),
          ),
          if (_isLoading) const LinearProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: "اكتب رسالتك..."),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
