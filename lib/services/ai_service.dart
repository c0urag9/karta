import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat_message.dart';

class AiService {
  static const String _apiUrl = '';
  // TODO: вынести ключ в .env или flutter_dotenv
  static const String _apiKey = 'YOUR_API_KEY_HERE';

  static const String _systemPrompt = '''
Ты — бизнес-консультант для малого и среднего бизнеса. 
Твоя задача: анализировать бизнес пользователя, задавать уточняющие вопросы 
и предлагать конкретные шаги для роста. 
Отвечай на русском языке. Будь конкретным, практичным и дружелюбным.
Если пользователь описал свой бизнес или прошёл анкету — дай персонализированные рекомендации.
''';

  /// Отправить сообщение и получить ответ ИИ
  Future<String> sendMessage(List<ChatMessage> history, String userMessage) async {
    final messages = [
      {'role': 'system', 'content': _systemPrompt},
      ...history.map((m) => {
        'role': m.isUser ? 'user' : 'assistant',
        'content': m.text,
      }),
      {'role': 'user', 'content': userMessage},
    ];

    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-4o-mini',
        'messages': messages,
        'max_tokens': 1000,
        'temperature': 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['choices'][0]['message']['content'] as String;
    } else {
      throw Exception('Ошибка API: ${response.statusCode} — ${response.body}');
    }
  }

  /// Сгенерировать дорожную карту по данным анкеты
  Future<String> generateRoadmap(Map<String, dynamic> auditData) async {
    final prompt = '''
На основе данных аудита компании создай детальную дорожную карту развития.

Данные компании:
${auditData.entries.map((e) => '${e.key}: ${e.value}').join('\n')}

Сформируй дорожную карту в формате JSON со следующей структурой:
{
  "summary": "краткое резюме анализа",
  "tasks": [
    {
      "id": "1",
      "title": "название задачи",
      "description": "подробное описание",
      "category": "категория (Финансы/Маркетинг/Операции/HR/Цифровизация)",
      "priority": 1
    }
  ]
}
Верни только JSON без лишнего текста.
''';

    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-4o-mini',
        'messages': [
          {'role': 'system', 'content': 'Ты бизнес-консультант. Отвечай только валидным JSON.'},
          {'role': 'user', 'content': prompt},
        ],
        'max_tokens': 2000,
        'temperature': 0.5,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['choices'][0]['message']['content'] as String;
    } else {
      throw Exception('Ошибка генерации дорожной карты: ${response.statusCode}');
    }
  }
}
