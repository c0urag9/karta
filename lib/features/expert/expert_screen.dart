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
  const Expert({
    required this.name, required this.title, required this.avatar,
    required this.color, required this.comment, required this.rating,
  });
}

class ExpertScreen extends StatelessWidget {
  const ExpertScreen({super.key});

  static const List<Expert> _experts = [
    Expert(
      name: 'Алексей Морозов', title: 'Бизнес-аналитик, 12 лет опыта', avatar: 'АМ',
      color: Color(0xFF534AB7),
      comment: 'Дорожная карта составлена грамотно. Особое внимание уделите первым 3 месяцам — быстрые победы создадут momentum для команды. Рекомендую начать с финансового блока.',
      rating: 4.8,
    ),
    Expert(
      name: 'Елена Соколова', title: 'Эксперт по маркетингу МСБ', avatar: 'ЕС',
      color: Color(0xFF1D9E75),
      comment: 'Маркетинговые задачи подобраны точно под ваш профиль. Обратите внимание на digital-каналы — они дадут ROI быстрее всего. Советую не откладывать CRM на потом.',
      rating: 4.9,
    ),
    Expert(
      name: 'Дмитрий Волков', title: 'Операционный директор, консультант', avatar: 'ДВ',
      color: Color(0xFFEF9F27),
      comment: 'Операционный блок требует особого внимания. Автоматизация процессов в первые 6 месяцев освободит до 30% времени команды. Это ключевой драйвер роста.',
      rating: 4.7,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final roadmap = context.read<RoadmapProvider>().roadmap;
    final companyName = roadmap?.companyName ?? 'вашей компании';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('Оценка экспертов',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
        bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Divider(height: 1, color: Color(0xFFEEEEF0))),
      ),

      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'roadmap',
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => RoadmapsScreen()),
            ),
            backgroundColor: const Color(0xFF534AB7),
            icon: const Icon(Icons.map_outlined, color: Colors.white, size: 20),
            label: const Text('Дорожная карта',
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
            elevation: 3,
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'back',
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            backgroundColor: Colors.white,
            elevation: 3,
            icon: const Icon(Icons.arrow_back, color: Color(0xFF534AB7), size: 20),
            label: const Text('Назад в чат',
                style: TextStyle(color: Color(0xFF534AB7), fontSize: 14, fontWeight: FontWeight.w600)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
              side: const BorderSide(color: Color(0xFF534AB7), width: 1.5),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 100),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          // ── Шапка ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF534AB7), Color(0xFF378ADD)],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(
                color: const Color(0xFF534AB7).withOpacity(0.3),
                blurRadius: 16, offset: const Offset(0, 6),
              )],
            ),
            child: Row(children: [
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.auto_awesome, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 18),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Дорожная карта для $companyName',
                    style: const TextStyle(
                        color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                const Text('3 эксперта оценили вашу карту развития',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 10),
                Row(children: [
                  _statChip('9 задач', Icons.task_alt_outlined),
                  const SizedBox(width: 10),
                  _statChip('12 месяцев', Icons.calendar_month_outlined),
                  const SizedBox(width: 10),
                  _statChip('3 периода', Icons.timeline_outlined),
                ]),
              ])),
            ]),
          ),

          const SizedBox(height: 24),

          const Text('Мнения экспертов',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
          const SizedBox(height: 4),
          const Text('Профессиональная оценка вашей дорожной карты',
              style: TextStyle(fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 16),

          ..._experts.map((e) => _buildExpertCard(e)),
        ]),
      ),
    );
  }

  Widget _statChip(String label, IconData icon) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.15),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, color: Colors.white70, size: 13),
      const SizedBox(width: 5),
      Text(label, style: const TextStyle(
          color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
    ]),
  );

  Widget _buildExpertCard(Expert expert) => Container(
    margin: const EdgeInsets.only(bottom: 14),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFFEEEEEE)),
      boxShadow: [BoxShadow(
          color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(
          width: 52, height: 52,
          decoration: BoxDecoration(
              color: expert.color.withOpacity(0.12), shape: BoxShape.circle),
          child: Center(child: Text(expert.avatar,
              style: TextStyle(color: expert.color, fontWeight: FontWeight.bold, fontSize: 16))),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(expert.name,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 3),
          Text(expert.title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1), borderRadius: BorderRadius.circular(20)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.star_rounded, color: Color(0xFFFFB300), size: 16),
            const SizedBox(width: 4),
            Text(expert.rating.toString(),
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF8B6914))),
          ]),
        ),
      ]),
      const SizedBox(height: 14),
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: expert.color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: expert.color.withOpacity(0.15)),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(Icons.format_quote, color: expert.color, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(expert.comment,
              style: const TextStyle(fontSize: 13, height: 1.5, color: Color(0xFF1A1A2E)))),
        ]),
      ),
    ]),
  );
}