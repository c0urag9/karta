import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'prompt_template_item.dart';
import 'package:my_business_app/features/audit/audit_screen.dart';
import 'package:my_business_app/features/ai_chat/providers/chat_provider.dart';

class SidebarChat extends StatelessWidget {
  const SidebarChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: const BoxDecoration(
        color: Color(0xFFFAFAFC),
        border: Border(right: BorderSide(color: Color(0xFFEEEEF0), width: 1)),
      ),
      child: Column(children: [
        
        Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 16, 16),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF534AB7), Color(0xFF378ADD)],
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.insights_rounded, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            const Text('Бизнес-навигатор',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
          ]),
        ),

        const Divider(height: 1, color: Color(0xFFEEEEF0)),
        const SizedBox(height: 12),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: InkWell(
            onTap: () => context.read<ChatProvider>().newChat(),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF534AB7), Color(0xFF378ADD)],
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF534AB7).withValues(alpha:0.3),
                      blurRadius: 8, offset: const Offset(0, 3)),
                ],
              ),
              child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.add_rounded, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text('Новый чат', style: TextStyle(color: Colors.white,
                    fontWeight: FontWeight.w600, fontSize: 14)),
              ]),
            ),
          ),
        ),
        const SizedBox(height: 8),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: InkWell(
            onTap: () => showDialog(context: context, builder: (_) => const AuditScreen()),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF534AB7).withValues(alpha:0.3)),
              ),
              child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.assignment_outlined, color: Color(0xFF534AB7), size: 18),
                SizedBox(width: 8),
                Text('Пройти анкету', style: TextStyle(color: Color(0xFF534AB7),
                    fontWeight: FontWeight.w600, fontSize: 14)),
              ]),
            ),
          ),
        ),

        const SizedBox(height: 20),

        const Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('ИСТОРИЯ ЧАТОВ',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                    color: Color(0xFFAAAAAA), letterSpacing: 0.8)),
          ),
        ),

        Consumer<ChatProvider>(
          builder: (context, provider, _) {
            if (provider.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF534AB7).withValues(alpha:0.06),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(children: [
                    Icon(Icons.chat_bubble_outline_rounded, size: 16, color: Color(0xFF534AB7)),
                    SizedBox(width: 10),
                    Text('Новый чат', style: TextStyle(fontSize: 13, color: Color(0xFF534AB7))),
                  ]),
                ),
              );
            }
            final preview = provider.messages.first.text;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF534AB7).withValues(alpha:0.06),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(children: [
                  const Icon(Icons.chat_bubble_outline_rounded, size: 16, color: Color(0xFF534AB7)),
                  const SizedBox(width: 10),
                  Expanded(child: Text(
                    preview.length > 26 ? '${preview.substring(0, 26)}...' : preview,
                    style: const TextStyle(fontSize: 13, color: Color(0xFF534AB7)),
                    overflow: TextOverflow.ellipsis,
                  )),
                ]),
              ),
            );
          },
        ),

        const Spacer(),
        const Divider(height: 1, color: Color(0xFFEEEEF0)),
        const SizedBox(height: 12),

        const Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('ШАБЛОНЫ', style: TextStyle(fontSize: 11,
                fontWeight: FontWeight.w600, color: Color(0xFFAAAAAA), letterSpacing: 0.8)),
          ),
        ),

        const PromptTemplateItem(text: 'Помогите увеличить продажи'),
        const PromptTemplateItem(text: 'Как оптимизировать расходы'),
        const PromptTemplateItem(text: 'Хочу масштабировать бизнес'),
        const PromptTemplateItem(text: 'Нужно автоматизировать процессы'),

        const SizedBox(height: 16),
      ]),
    );
  }
}
