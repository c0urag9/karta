import 'package:flutter/material.dart';
import '../../../models/chat_message.dart';
import '../../../services/ai_service.dart';

class ChatProvider extends ChangeNotifier {
  final AiService _ai = AiService();

  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _error;

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isEmpty => _messages.isEmpty;

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text.trim(),
      role: MessageRole.user,
    );

    _messages.add(userMsg);
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final reply = await _ai.sendMessage(_messages, text.trim());
      _messages.add(ChatMessage(
        id: '${DateTime.now().millisecondsSinceEpoch}_ai',
        text: reply.trim(),
        role: MessageRole.assistant,
      ));
    } catch (e) {
      _error = e.toString();
      _messages.add(ChatMessage(
        id: '${DateTime.now().millisecondsSinceEpoch}_err',
        text: 'Не удалось получить ответ. Убедитесь что прокси запущен (node proxy.js).',
        role: MessageRole.assistant,
      ));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void newChat() {
    _messages.clear();
    _error = null;
    notifyListeners();
  }
}
