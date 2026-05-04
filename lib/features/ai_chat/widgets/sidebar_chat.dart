import 'package:flutter/material.dart';
import 'prompt_template_item.dart';
import 'package:my_business_app/features/audit/audit_screen.dart';

class SidebarChat extends StatelessWidget {
  const SidebarChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      color: const Color(0xFFF8F9FA),
      child: Column(
        children: [
          // ========== ЗАГОЛОВОК ==========
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Row(
              children: [
                Icon(Icons.home, size: 26),
                SizedBox(width: 10),
                Text(
                  'Чат бизнес-навигатор',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),

          const SizedBox(height: 16),

          // ========== КНОПКА "ПРОЙТИ АНКЕТУ" ==========
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AuditScreen(),   // ← УБРАЛИ const
                );
              },
              icon: const Icon(Icons.assignment_outlined),
              label: const Text('Пройти анкету'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ========== ИСТОРИЯ ЧАТОВ ==========
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'История чатов',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Активный чат (выделенный)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.chat_bubble_outline, size: 20),
                SizedBox(width: 10),
                Text('Новый чат'),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // ========== РАЗДЕЛИТЕЛЬ ==========
          const Divider(height: 20, thickness: 1),

          // ========== ШАБЛОНЫ ПРОМПТОВ (ВНИЗУ) ==========
          const Spacer(),

          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Шаблоны промптов',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const PromptTemplateItem(text: 'Помогите увеличить продажи'),
          const PromptTemplateItem(text: 'Как оптимизировать расходы'),
          const PromptTemplateItem(text: 'Хочу масштабировать бизнес'),
          const PromptTemplateItem(text: 'Нужно автоматизировать процессы'),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}