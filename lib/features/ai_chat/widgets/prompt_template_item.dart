import 'package:flutter/material.dart';

class PromptTemplateItem extends StatelessWidget {
  final String text;

  const PromptTemplateItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: const Icon(Icons.lightbulb_outline, size: 20, color: Colors.grey),
      title: Text(text),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Промпт выбран: "$text"'),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
        // Позже здесь будет вставка текста в поле ввода
      },
    );
  }
}