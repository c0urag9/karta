import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';

class PromptTemplateItem extends StatelessWidget {
  final String text;
  const PromptTemplateItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.read<ChatProvider>().sendMessage(text),
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        child: Row(children: [
          const Icon(Icons.lightbulb_outline, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(child: Text(text,
              style: const TextStyle(fontSize: 13, color: Colors.black87))),
        ]),
      ),
    );
  }
}
