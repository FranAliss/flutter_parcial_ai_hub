import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatGPT Console',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: ChatScreen(),
    );
  }
}

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
      // Realizar la solicitud POST a la API de ChatGPT
      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        String answer = data['choices'][0]['text'].toString().trim();
        _addMessage('Pregunta: $text');
        _addMessage('Respuesta: $answer');
      } else {
        _addMessage('Error en la solicitud. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      _addMessage('Error al realizar la solicitud: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ChatGPT Console')),
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
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Introduce tu pregunta',
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.white),
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
