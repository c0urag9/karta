import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_message.dart';

class StorageService {
  static const _chatsKey = 'chats';

  Future<void> saveChat(String chatId, List<ChatMessage> messages) async {
    final prefs = await SharedPreferences.getInstance();
    final data = messages.map((m) => {
      'id': m.id,
      'text': m.text,
      'role': m.role.name,
      'createdAt': m.createdAt.toIso8601String(),
    }).toList();
    await prefs.setString('$_chatsKey.$chatId', jsonEncode(data));
  }

  Future<List<ChatMessage>> loadChat(String chatId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('$_chatsKey.$chatId');
    if (raw == null) return [];
    final List<dynamic> data = jsonDecode(raw);
    return data.map((m) => ChatMessage(
      id: m['id'],
      text: m['text'],
      role: m['role'] == 'user' ? MessageRole.user : MessageRole.assistant,
      createdAt: DateTime.parse(m['createdAt']),
    )).toList();
  }

  Future<List<String>> getChatIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getKeys()
        .where((k) => k.startsWith('$_chatsKey.'))
        .map((k) => k.replaceFirst('$_chatsKey.', ''))
        .toList();
  }

  Future<void> deleteChat(String chatId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_chatsKey.$chatId');
  }
}
