import 'package:flutter/material.dart';
import 'prompt_template_item.dart';

class SidebarChat extends StatelessWidget {
  const SidebarChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(Icons.home, size: 28),
                const SizedBox(width: 10),
                const Text(
                  'Чат бизнес-навигатор',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const Divider(),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('+ Новый чат'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.assignment_outlined),
                  label: const Text('Пройти анкету'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ],
            ),
          ),

          const Divider(),

          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('История чатов', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.chat_bubble_outline),
                SizedBox(width: 10),
                Text('История чатов'),
              ],
            ),
          ),

          const Spacer(),

          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Шаблоны промптов', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),

          const PromptTemplateItem(text: 'Помогите увеличить продажи'),
          const PromptTemplateItem(text: 'Как оптимизировать расходы'),
          const PromptTemplateItem(text: 'Хочу масштабировать бизнес'),
          const PromptTemplateItem(text: 'Нужно автоматизировать процессы'),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}