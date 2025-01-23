import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:translator/translator.dart';
import 'dart:typed_data'; // Импортируем dart:typed_data для Uint8List
import 'god_chat_screen.dart'; // Импортируем файл god_chat_screen.dart
import 'dart:math'; // Импортируем dart:math для генерации случайных чисел

void main() {
  runApp(const NeironusApp());
}

class NeironusApp extends StatelessWidget {
  const NeironusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeironusV1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _promptController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _countController = TextEditingController();
  bool _nologo = false;
  bool _private = false;
  bool _enhance = false;
  bool _safe = false;
  final List<Uint8List> _generatedImages = [];
  bool _isLoading = false;
  final Logger _logger = Logger();
  final GoogleTranslator _translator = GoogleTranslator();

  Future<void> _generateImages() async {
    setState(() {
      _isLoading = true;
      _generatedImages.clear();
    });

    final prompt = _promptController.text;
    final width = int.tryParse(_widthController.text) ?? 512; // Значение по умолчанию
    final height = int.tryParse(_heightController.text) ?? 512; // Значение по умолчанию
    final count = int.tryParse(_countController.text) ?? 1; // Значение по умолчанию

    // Перевод промпта на английский
    final translatedPrompt = await _translator.translate(prompt, to: 'en');

    for (int i = 0; i < count; i++) {
      final seed = Random().nextInt(1000000); // Генерация случайного seed
      final response = await http.get(
        Uri.parse('https://image.pollinations.ai/prompt/$translatedPrompt?width=$width&height=$height&nologo=$_nologo&private=$_private&enhance=$_enhance&safe=$_safe&seed=$seed'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _generatedImages.add(response.bodyBytes);
        });
      } else {
        // Обработка ошибки
        _logger.e('Failed to generate image: ${response.statusCode}');
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Neironus'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _promptController,
              decoration: const InputDecoration(labelText: 'Enter2 your prompt'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _widthController,
              decoration: const InputDecoration(labelText: 'Width'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _heightController,
              decoration: const InputDecoration(labelText: 'Height'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _countController,
              decoration: const InputDecoration(labelText: 'Number of Images'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('No Logo'),
              value: _nologo,
              onChanged: (value) {
                setState(() {
                  _nologo = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Private'),
              value: _private,
              onChanged: (value) {
                setState(() {
                  _private = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Enhance'),
              value: _enhance,
              onChanged: (value) {
                setState(() {
                  _enhance = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Safe'),
              value: _safe,
              onChanged: (value) {
                setState(() {
                  _safe = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _generateImages,
              child: const Text('Generate Images'),
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_generatedImages.isNotEmpty)
              Column(
                children: _generatedImages.map((image) {
                  return Column(
                    children: [
                      Image.memory(image),
                      const SizedBox(height: 16), // Промежуток между изображениями
                    ],
                  );
                }).toList(),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GodChatScreen()),
                );
              },
              child: const Text('Chat with God'),
            ),
          ],
        ),
      ),
    );
  }
}
