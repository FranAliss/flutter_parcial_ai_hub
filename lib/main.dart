// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final TextEditingController promptController = TextEditingController();
//   String imageUrl = "";
//   String hash = "";
//   int id = 12345;

//   Future<void> makeHttpPostRequest() async {
//     final Uri url =
//         Uri.parse('https://arimagesynthesizer.p.rapidapi.com/generate');

//     final Map<String, String> headers = {
//       'content-type': 'application/x-www-form-urlencoded',
//       'X-RapidAPI-Key': '5ec03aabe4msh46f623ca5b53d24p1b15d3jsn89b6c4f58c9d',
//       'X-RapidAPI-Host': 'arimagesynthesizer.p.rapidapi.com',
//     };

//     final Map<String, String> body = {
//       'prompt': promptController.text,
//       'id': id.toString(),
//       'width': '768',
//       'height': '768',
//       'inferenceSteps': '50',
//       'guidanceScale': '7.5',
//       'img2img_strength': '0.75',
//     };

//     final response = await http.post(url, headers: headers, body: body);

//     if (response.statusCode == 202 || response.statusCode == 200) {
//       final responseData = response.body;
//       if (responseData.startsWith("http")) {
//         setState(() {
//           imageUrl = responseData;
//           hash = "";
//         });
//       } else {
//         setState(() {
//           imageUrl = "";
//           hash = responseData;
//         });

//         if (hash != "") {
//           makeHttpGetRequest(hash: hash);
//         }
//       }
//     } else {
//       // Handle errors here, e.g., display an error message
//       print('Request failed with status: ${response.statusCode}');
//     }
//     id++;
//   }

//   Future<void> makeHttpGetRequest({hash}) async {
//     final Uri url = Uri.parse('https://arimagesynthesizer.p.rapidapi.com/get');
//     Map<String, dynamic> jsonMap = json.decode(hash);
//     String hashValue = jsonMap['hash'];
//     final Map<String, String> queryParams = {
//       'hash': hashValue,
//       'returnType': 'image',
//     };

//     final Map<String, String> headers = {
//       'X-RapidAPI-Key': '5ec03aabe4msh46f623ca5b53d24p1b15d3jsn89b6c4f58c9d',
//       'X-RapidAPI-Host': 'arimagesynthesizer.p.rapidapi.com',
//     };

//     final response = await http.get(url.replace(queryParameters: queryParams),
//         headers: headers);

//     if (response.statusCode == 200) {
//       print(response.body);
//       setState(() {
//         imageUrl = response.body;
//         hashValue = "";
//       });
//     } else {
//       print('GET Request failed with status: ${response.statusCode}');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Texto a imagen (ARImageSynthesizer API)'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: TextField(
//               controller: promptController,
//               decoration: InputDecoration(labelText: 'Prompt aca'),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: makeHttpPostRequest,
//             child: Text('Mandar prompt'),
//           ),
//           imageUrl != ""
//               ? Image.network(imageUrl)
//               : hash != ""
//                   ? Text(hash)
//                   : Container(),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     promptController.dispose();
//     super.dispose();
//   }
// }

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController promptController = TextEditingController();
  String imageUrl = "";
  String hash = "";
  int id = 12345;

  Future<void> makeHttpPostRequest() async {
    final Uri url =
        Uri.parse('https://arimagesynthesizer.p.rapidapi.com/generate');

    final Map<String, String> headers = {
      'content-type': 'application/x-www-form-urlencoded',
      'X-RapidAPI-Key': '5ec03aabe4msh46f623ca5b53d24p1b15d3jsn89b6c4f58c9d',
      'X-RapidAPI-Host': 'arimagesynthesizer.p.rapidapi.com',
    };

    final Map<String, dynamic> body = {
      'prompt': promptController.text,
      'id': id.toString(),
      'width': 768,
      'height': 768,
      'inferenceSteps': 50,
      'guidanceScale': 7.5,
      'img2img_strength': 0.75,
    };

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 202 || response.statusCode == 200) {
      final responseData = response.body;
      if (responseData.startsWith("http")) {
        setState(() {
          imageUrl = responseData;
          hash = "";
        });
      } else {
        setState(() {
          imageUrl = "";
          hash = responseData;
        });

        if (hash != "") {
          makeHttpGetRequest(hash: hash);
        }
      }
    } else {
      // Handle errors here, e.g., display an error message
      print('Request failed with status: ${response.statusCode}');
    }
    id++;
  }

  Future<void> makeHttpGetRequest({hash}) async {
    final dio = Dio();
    Map<String, dynamic> jsonMap = json.decode(hash);
    String hashValue = jsonMap['hash'];
    dio.options.headers = {
      'X-RapidAPI-Key': '5ec03aabe4msh46f623ca5b53d24p1b15d3jsn89b6c4f58c9d',
      'X-RapidAPI-Host': 'arimagesynthesizer.p.rapidapi.com',
    };

    try {
      final url =
          'https://arimagesynthesizer.p.rapidapi.com/get?hash=$hashValue&returnType=image';
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        Image.memory(response.data);
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Texto a imagen (ARImageSynthesizer API)'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: promptController,
              decoration: const InputDecoration(labelText: 'Prompt aca'),
            ),
          ),
          ElevatedButton(
            onPressed: makeHttpPostRequest,
            child: const Text('Mandar prompt'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    promptController.dispose();
    super.dispose();
  }
}
