import 'package:flutter/material.dart';
import 'widgets/sidebar_chat.dart';
import 'widgets/welcome_chat.dart';
import 'widgets/chat_input_field.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Левая панель
          const SidebarChat(),

          // Вертикальная разделительная линия
          const VerticalDivider(width: 1, thickness: 1, color: Color(0xFFE0E0E0)),

          // Правая основная часть
          Expanded(
            child: Column(
              children: [
                // Верхняя панель с кнопками
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add),
                        label: const Text('+ Новый чат'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.assignment_outlined),
                        label: const Text('Пройти анкету'),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  ),
                ),

                // Центральное приветствие
                const Expanded(
                  child: WelcomeChat(),
                ),

                // Поле ввода
                const ChatInputField(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}