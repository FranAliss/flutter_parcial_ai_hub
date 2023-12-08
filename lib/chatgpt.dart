import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Examen',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: MainMenu(),
    );
  }
}

// final String apiKey = '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';
// final String apiKey = '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';
class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<String> _chatMessages = [];

  final String apiKey = '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';
  void _addMessage(String message) {
    setState(() {
      _chatMessages.add(message);
    });
  }

  void _sendMessage(String text) async {
    String apiUrl = 'https://api.openai.com/v1/engines/davinci/completions';
    Map<String, String> headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> body = {
      'prompt': text,
      'max_tokens': 100,
    };

    try {
      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        String answer = utf8.decode(
            data['choices'][0]['text'].toString().trim().runes.toList());
        _addMessage('Pregunta: $text');
        _addMessage('Respuesta: $answer');
      } else {
        _addMessage(
            'Error en la solicitud. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      _addMessage('Error al realizar la solicitud: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phrase Finisher Console')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.black,
              child: ListView.builder(
                itemCount: _chatMessages.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      _chatMessages[index],
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Introduce el prompt',
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: () {
                    String text = _textController.text.trim();
                    if (text.isNotEmpty) {
                      _sendMessage(text);
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

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Menu'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(height: 20), // Add space on top
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatScreen()),
                  );
                },
                child: const Text('Random Phrase Finisher'),
              ),
            ),
          ),
          const SizedBox(height: 20), // Add space between buttons
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewScreen()),
                  );
                },
                child: const Text('Chat GPT 3.5 (low size answers)'),
              ),
            ),
          ),
          SizedBox(height: 20), // Add space on bottom
        ],
      ),
    );
  }
}

class NewScreen extends StatefulWidget {
  @override
  _NewScreenState createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<String> _newScreenMessages = [];
  final String apiKey = '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';
  void _addMessage(String message) {
    setState(() {
      _newScreenMessages.add(message);
    });
  }

  void _sendMessage(String text) async {
    String apiUrl = 'https://api.openai.com/v1/completions';
    Map<String, String> headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> body = {
      'model': 'gpt-3.5-turbo-instruct',
      'prompt': text,
    };

    try {
      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        String answer = utf8.decode(
            data['choices'][0]['text'].toString().trim().runes.toList());
        _addMessage('Pregunta: $text');
        _addMessage('Respuesta: $answer');
      } else {
        _addMessage(
            'Error en la solicitud. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      _addMessage('Error al realizar la solicitud: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat GPT 3.5')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.black,
              child: ListView.builder(
                itemCount: _newScreenMessages.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      _newScreenMessages[index],
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Introduce el prompt',
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: () {
                    String text = _textController.text.trim();
                    if (text.isNotEmpty) {
                      _sendMessage(text);
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
