import 'package:flutter/material.dart';

class WelcomeChat extends StatelessWidget {
  const WelcomeChat({super.key});

  static const _suggestions = [
    ('💰', 'Как увеличить прибыль?'),
    ('📈', 'Стратегия роста на год'),
    ('🎯', 'Найти новых клиентов'),
    ('⚙️', 'Оптимизировать процессы'),
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // ── Иконка ──
          Container(
            width: 72, height: 72,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF534AB7), Color(0xFF378ADD)],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: const Color(0xFF534AB7).withValues(alpha:0.3),
                    blurRadius: 20, offset: const Offset(0, 8)),
              ],
            ),
            child: const Icon(Icons.insights_rounded, color: Colors.white, size: 36),
          ),
          const SizedBox(height: 24),

          // ── Заголовок ──
          const Text('Добро пожаловать в Бизнес-навигатор',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
          const SizedBox(height: 12),
          const Text(
            'Опишите ваш бизнес или задайте вопрос.\nПройдите анкету для персональной дорожной карты.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Color(0xFF888888), height: 1.5),
          ),
          const SizedBox(height: 36),

          // ── Подсказки ──
          Wrap(
            spacing: 10, runSpacing: 10,
            alignment: WrapAlignment.center,
            children: _suggestions.map((s) => _SuggestionChip(emoji: s.$1, text: s.$2)).toList(),
          ),
        ]),
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  final String emoji;
  final String text;
  const _SuggestionChip({required this.emoji, required this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Отправляем подсказку в чат — через провайдер
        // context.read<ChatProvider>().sendMessage(text);
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE8E8E8)),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha:0.04), blurRadius: 6, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 13, color: Color(0xFF444444), fontWeight: FontWeight.w500)),
        ]),
      ),
    );
  }
}
