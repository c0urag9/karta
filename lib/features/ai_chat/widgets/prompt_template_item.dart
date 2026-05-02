import 'package:flutter/material.dart';

class PromptTemplateItem extends StatelessWidget {
  final String text;

  const PromptTemplateItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: const Icon(Icons.description_outlined, size: 20),
      title: Text(text, style: const TextStyle(fontSize: 14)),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Выбран промпт: $text')),
        );
      },
    );
  }
}