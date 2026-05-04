import 'package:flutter/material.dart';

class WelcomeChat extends StatelessWidget {
  const WelcomeChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.smart_toy_outlined, size: 110, color: Colors.blue[300]),
          const SizedBox(height: 32),
          const Text(
            'Добро пожаловать в Бизнес-навигатор',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            'Опишите ваш бизнес или\nпройдите анкету, чтобы получить\nперсональную дорожную карту',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
          ),
        ],
      ),
    );
  }
}