import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:convert';

class GodChatScreen extends StatefulWidget {
  const GodChatScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GodChatScreenState createState() => _GodChatScreenState();
}

class _GodChatScreenState extends State<GodChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  final Logger _logger = Logger();

  Future<void> _sendMessage() async {
    setState(() {
      _isLoading = true;
    });

    final message = _messageController.text;
    try {
      final response = await http.post(
        Uri.parse('https://text.pollinations.ai/'), // URL API для чата с богом
        body: jsonEncode({
          'messages': [
            {'role': 'system', 'content': 'You are a helpful assistant.'},
            {'role': 'user', 'content': message}
          ],
          'model': 'openai',
          'jsonMode': true,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _logger.d('API Response: $data'); // Логирование ответа API

        String godResponse;
        if (data is String) {
          godResponse = data;
        } else if (data is Map<String, dynamic>) {
          godResponse = jsonEncode(data);
        } else {
          godResponse = 'No response';
        }

        setState(() {
          _messages.add({'role': 'user', 'content': message});
          _messages.add({'role': 'god', 'content': godResponse});
        });
        _messageController.clear();
      } else {
        // Обработка ошибки
        _logger.e('Failed to send message: ${response.statusCode}');
        _logger.e('Response body: ${response.body}');
        setState(() {
          _messages.add({'role': 'error', 'content': 'Failed to send message'});
        });
      }
    } catch (e) {
      _logger.e('Exception: $e');
      setState(() {
        _isLoading = false;
        _messages.add({'role': 'error', 'content': 'Exception occurred'});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Чат с БОГОМ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isUserMessage = message['role'] == 'user';
                  final isErrorMessage = message['role'] == 'error';

                  return Align(
                    alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: isUserMessage ? Colors.lightBlueAccent : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        message['content']!,
                        style: TextStyle(
                          color: isErrorMessage ? Colors.red : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(labelText: 'Введите сообщение'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _sendMessage,
              child: _isLoading ? const CircularProgressIndicator() : const Text('Отправить'),
            ),
          ],
        ),
      ),
    );
  }
}
