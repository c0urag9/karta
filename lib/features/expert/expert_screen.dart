import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_business_app/features/roadmap/roadmap_provider.dart';
import 'package:my_business_app/features/roadmap/roadmaps_screen.dart';

class Expert {
  final String name;
  final String title;
  final String avatar;
  final Color color;
  final String comment;
  final double rating;
  const Expert({required this.name, required this.title, required this.avatar,
      required this.color, required this.comment, required this.rating});
}

class ExpertScreen extends StatelessWidget {
  const ExpertScreen({super.key});

  static const List<Expert> _experts = [
    Expert(name: 'Алексей Морозов', title: 'Бизнес-аналитик, 12 лет опыта', avatar: 'АМ',
        color: Color(0xFF534AB7),
        comment: 'Дорожная карта составлена грамотно. Особое внимание уделите первым 3 месяцам — быстрые победы создадут momentum для команды. Рекомендую начать с финансового блока.',
        rating: 4.8),
    Expert(name: 'Елена Соколова', title: 'Эксперт по маркетингу МСБ', avatar: 'ЕС',
        color: Color(0xFF1D9E75),
        comment: 'Маркетинговые задачи подобраны точно под ваш профиль. Обратите внимание на digital-каналы — они дадут ROI быстрее всего. Советую не откладывать CRM на потом.',
        rating: 4.9),
    Expert(name: 'Дмитрий Волков', title: 'Операционный директор, консультант', avatar: 'ДВ',
        color: Color(0xFFEF9F27),
        comment: 'Операционный блок требует особого внимания. Автоматизация процессов в первые 6 месяцев освободит до 30% времени команды. Это ключевой драйвер роста.',
        rating: 4.7),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Оценка экспертов',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
        bottom: const PreferredSize(preferredSize: Size.fromHeight(1), child: Divider(height: 1)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          ..._experts.map((e) => _buildExpertCard(e)),
          const SizedBox(height: 16),
          _buildOpenRoadmapButton(context),
        ]),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final roadmap = context.read<RoadmapProvider>().roadmap;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF534AB7), Color(0xFF378ADD)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(children: [
        const Icon(Icons.auto_awesome, color: Colors.white, size: 32),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            roadmap != null ? 'Карта для ${roadmap.companyName}' : 'Дорожная карта готова',
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text('3 эксперта оценили вашу карту развития',
              style: TextStyle(color: Colors.white70, fontSize: 13)),
        ])),
      ]),
    );
  }

  Widget _buildExpertCard(Expert expert) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(color: expert.color.withValues(alpha:0.12), shape: BoxShape.circle),
            child: Center(child: Text(expert.avatar,
                style: TextStyle(color: expert.color, fontWeight: FontWeight.bold, fontSize: 16))),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(expert.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 3),
            Text(expert.title, style: const TextStyle(fontSize: 13, color: Colors.grey)),
          ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: const Color(0xFFFFF8E1), borderRadius: BorderRadius.circular(20)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.star_rounded, color: Color(0xFFFFB300), size: 16),
              const SizedBox(width: 4),
              Text(expert.rating.toString(),
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF8B6914))),
            ]),
          ),
        ]),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: expert.color.withValues(alpha:0.05),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: expert.color.withValues(alpha:0.15)),
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(Icons.format_quote, color: expert.color, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text(expert.comment,
                style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.black87))),
          ]),
        ),
      ]),
    );
  }

  Widget _buildOpenRoadmapButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const RoadmapsScreen())),
        icon: const Icon(Icons.map_outlined),
        label: const Text('Открыть дорожную карту'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF534AB7),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
