import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

///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




class ChatGptModel{

  String message;
  String sender;
  ChatGptModel({required this.message,required this.sender});
}
//

//
class ChatGPT {
  static const String apiUrl = "https://api.openai.com/v1/";
  final String apiKey;
  ChatGPT(this.apiKey);

  Future<String> sendMassage(String message) async {
    final response = await http.post(Uri.parse('${apiUrl}completions'),
        headers: {
          'Authorization': 'Bearer $apiUrl',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'text-davinci-003',
          'prompt': message,
          'temperature': 0.5,
          'max_tokens': 2000
        }));
    print(response.statusCode);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      var finalResponse = jsonResponse['choices'][0]['text'].toString();
      return finalResponse;
    } else {
      throw Exception('Error');
    }
  }
}
