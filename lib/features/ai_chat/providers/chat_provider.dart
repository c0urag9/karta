import 'package:flutter/material.dart';
import '../../../models/chat_message.dart';
import '../../../services/ai_service.dart';
import '../../../services/storage_service.dart';

class ChatProvider extends ChangeNotifier {
  final AiService _ai = AiService();
  final StorageService _storage = StorageService();

  List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _error;
  String _chatId = DateTime.now().millisecondsSinceEpoch.toString();

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isEmpty => _messages.isEmpty;

  /// Отправить сообщение пользователя
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
        text: reply,
        role: MessageRole.assistant,
      ));
      await _storage.saveChat(_chatId, _messages);
    } catch (e) {
      _error = 'Не удалось получить ответ. Проверьте соединение.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Новый чат
  void newChat() {
    _messages = [];
    _chatId = DateTime.now().millisecondsSinceEpoch.toString();
    _error = null;
    notifyListeners();
  }

  /// Загрузить существующий чат
  Future<void> loadChat(String chatId) async {
    _chatId = chatId;
    _messages = await _storage.loadChat(chatId);
    notifyListeners();
  }
}
