import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/ai_chat/chat_screen.dart';
import 'features/ai_chat/providers/chat_provider.dart';
import 'features/roadmap/roadmap_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => RoadmapProvider()),
      ],
      child: MaterialApp(
        title: 'Бизнес Навигатор',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF534AB7),
            primary: const Color(0xFF534AB7),
          ),
        ),
        home: const ChatScreen(),
      ),
    );
  }
}
