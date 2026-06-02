import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/sidebar_chat.dart';
import 'widgets/welcome_chat.dart';
import 'widgets/chat_input_field.dart';
import 'widgets/roadmap_message_widget.dart';
import 'providers/chat_provider.dart';
import 'package:my_business_app/features/roadmap/roadmap_provider.dart';
import 'package:my_business_app/features/roadmap/roadmaps_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _roadmapShown = false;
  bool _roadmapPinned = false; // закреплена ли карта сверху

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RoadmapProvider>().addListener(_onRoadmapChanged);
    });
  }

  @override
  void dispose() {
    context.read<RoadmapProvider>().removeListener(_onRoadmapChanged);
    _scrollController.dispose();
    super.dispose();
  }

  void _onRoadmapChanged() {
    final provider = context.read<RoadmapProvider>();
    if (!provider.isLoading && provider.hasRoadmap && !_roadmapShown) {
      setState(() => _roadmapShown = true);
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
          );
        }
      });
    }
    if (!provider.hasRoadmap) {
      setState(() {
        _roadmapShown = false;
        _roadmapPinned = false;
      });
    }
  }

  void _togglePin() {
    setState(() => _roadmapPinned = !_roadmapPinned);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(children: [
        const SidebarChat(),
        const VerticalDivider(width: 1, thickness: 1, color: Color(0xFFE0E0E0)),
        Expanded(
          child: Column(children: [
            // Баннер генерации
            _buildGeneratingBanner(),
            // Закреплённый баннер дорожной карты
            if (_roadmapPinned) _buildPinnedBanner(),
            Expanded(
              child: Consumer<ChatProvider>(
                builder: (context, provider, _) {
                  final isEmpty = provider.isEmpty && !_roadmapShown;
                  if (isEmpty) return const WelcomeChat();
                  return _buildMessageList(provider);
                },
              ),
            ),
            const ChatInputField(),
          ]),
        ),
      ]),
    );
  }

  // ── Баннер генерации ──────────────────────
  Widget _buildGeneratingBanner() {
    return Consumer<RoadmapProvider>(
      builder: (context, provider, _) {
        if (!provider.isLoading) return const SizedBox.shrink();
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF534AB7), Color(0xFF378ADD)],
              begin: Alignment.topLeft, end: Alignment.bottomRight,
            ),
          ),
          child: const Row(children: [
            SizedBox(width: 16, height: 16,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
            SizedBox(width: 12),
            Text('ИИ генерирует дорожную карту развития...',
                style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
          ]),
        );
      },
    );
  }

  // ── Закреплённый баннер ───────────────────
  Widget _buildPinnedBanner() {
    return Consumer<RoadmapProvider>(
      builder: (context, provider, _) {
        final roadmap = provider.roadmap;
        if (roadmap == null) return const SizedBox.shrink();
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF534AB7).withOpacity(0.07),
            border: const Border(
              bottom: BorderSide(color: Color(0xFFDDDAF5), width: 1),
            ),
          ),
          child: Row(children: [
            // Иконка иголки
            const Icon(Icons.push_pin, size: 16, color: Color(0xFF534AB7)),
            const SizedBox(width: 10),
            // Иконка карты
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF534AB7), Color(0xFF378ADD)],
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.map_outlined, size: 14, color: Colors.white),
            ),
            const SizedBox(width: 10),
            // Название и кол-во задач
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Дорожная карта — ${roadmap.companyName}',
                  style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E)),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${roadmap.tasks.length} задач · ${roadmap.byPeriod(TaskPeriod.threeMonths).where((t) => t.status == TaskStatus.done).length + roadmap.byPeriod(TaskPeriod.sixMonths).where((t) => t.status == TaskStatus.done).length + roadmap.byPeriod(TaskPeriod.twelveMonths).where((t) => t.status == TaskStatus.done).length} выполнено',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            )),
            // Кнопка "Открыть"
            TextButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => RoadmapsScreen())),
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF534AB7),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Открыть', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(width: 6),
            // Кнопка открепить
            GestureDetector(
              onTap: _togglePin,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFF534AB7).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.close, size: 14, color: Color(0xFF534AB7)),
              ),
            ),
          ]),
        );
      },
    );
  }

  // ── Список сообщений ──────────────────────
  Widget _buildMessageList(ChatProvider provider) {
    final messages = provider.messages;
    final itemCount = messages.length
        + (provider.isLoading ? 1 : 0)
        + (_roadmapShown ? 1 : 0);

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(20),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (_roadmapShown && index == itemCount - 1) {
          return RoadmapMessageWidget(
            onPin: _togglePin,
            isPinned: _roadmapPinned,
          );
        }
        if (provider.isLoading && index == messages.length) {
          return _buildTypingIndicator();
        }
        final msg = messages[index];
        return _buildMessageBubble(msg.text, msg.isUser);
      },
    );
  }

  Widget _buildMessageBubble(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: const BoxConstraints(maxWidth: 680),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF534AB7) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16), topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
          border: isUser ? null : Border.all(color: const Color(0xFFE8E8E8)),
          boxShadow: [BoxShadow(
              color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Text(text,
            style: TextStyle(fontSize: 14, height: 1.5,
                color: isUser ? Colors.white : Colors.black87)),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8E8E8)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          _dot(0), _dot(150), _dot(300),
        ]),
      ),
    );
  }

  Widget _dot(int delayMs) => TweenAnimationBuilder<double>(
    tween: Tween(begin: 0.3, end: 1.0),
    duration: Duration(milliseconds: 600 + delayMs),
    builder: (_, v, __) => Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: 7, height: 7,
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(v), shape: BoxShape.circle),
    ),
  );
}