import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat_message.dart';

class AiService {

  static const String _token  = '';
  static const String _apiUrl = '';
  static const String _model  = '';


  static const String _systemPrompt =
    'Ты — бизнес-консультант для малого и среднего бизнеса. '
    'Помогаешь предпринимателям развивать бизнес, решать проблемы и находить точки роста. '
    'Отвечай на русском языке. Будь конкретным, практичным и дружелюбным. '
    'Давай структурированные советы с конкретными шагами.';

  Future<String> sendMessage(List<ChatMessage> history, String userMessage) async {
    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode({
        'model': _model,
        'messages': [
          {'role': 'system', 'content': _systemPrompt},
          ...history.map((m) => {
            'role': m.isUser ? 'user' : 'assistant',
            'content': m.text,
          }),
          {'role': 'user', 'content': userMessage},
        ],
        'max_tokens': 1000,
        'temperature': 0.7,
      }),
    ).timeout(const Duration(seconds: 60));

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['choices'][0]['message']['content'] as String;
    } else {
      throw Exception('Ошибка API: ${response.statusCode}');
    }
  }
}
