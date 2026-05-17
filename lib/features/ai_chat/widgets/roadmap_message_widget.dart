import 'package:flutter/material.dart';
import 'package:my_business_app/features/roadmap/roadmaps_screen.dart';
import 'package:provider/provider.dart';
import 'package:my_business_app/features/roadmap/roadmap_provider.dart';
import 'package:my_business_app/features/expert/expert_screen.dart';

/// Виджет-сообщение в чате, которое появляется когда дорожная карта готова
class RoadmapMessageWidget extends StatelessWidget {
  const RoadmapMessageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final roadmap = context.read<RoadmapProvider>().roadmap;
    if (roadmap == null) return const SizedBox.shrink();

    final totalTasks = roadmap.tasks.length;
    final periods = [
      roadmap.byPeriod(TaskPeriod.threeMonths).length,
      roadmap.byPeriod(TaskPeriod.sixMonths).length,
      roadmap.byPeriod(TaskPeriod.twelveMonths).length,
    ];

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: const BoxConstraints(maxWidth: 520),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16), topRight: Radius.circular(16),
            bottomLeft: Radius.circular(4), bottomRight: Radius.circular(16),
          ),
          border: Border.all(color: const Color(0xFFE8E8E8)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.04), blurRadius: 8)],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ── Шапка ──
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF534AB7), Color(0xFF378ADD)],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16),
              ),
            ),
            child: Row(children: [
              const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Дорожная карта для ${roadmap.companyName}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 2),
                Text('$totalTasks задач на 12 месяцев',
                    style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ])),
            ]),
          ),

          // ── Резюме ──
          if (roadmap.executiveSummary.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Text(roadmap.executiveSummary,
                  style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.5)),
            ),

          // ── Статистика по периодам ──
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              _periodChip('1–3 мес', periods[0], const Color(0xFF1D9E75)),
              const SizedBox(width: 8),
              _periodChip('3–6 мес', periods[1], const Color(0xFF378ADD)),
              const SizedBox(width: 8),
              _periodChip('6–12 мес', periods[2], const Color(0xFF534AB7)),
            ]),
          ),

          // ── Кнопки ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(children: [
              // Кнопка "Оценка экспертов" — главная
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const ExpertScreen())),
                  icon: const Icon(Icons.people_outline, size: 18),
                  label: const Text('Оценка экспертов'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF534AB7),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Кнопка "Открыть дорожную карту"
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const RoadmapsScreen())),
                  icon: const Icon(Icons.map_outlined, size: 18),
                  label: const Text('Открыть дорожную карту'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF534AB7),
                    side: const BorderSide(color: Color(0xFF534AB7)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _periodChip(String label, int count, Color color) {
    return Expanded(child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha:0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha:0.2)),
      ),
      child: Column(children: [
        Text('$count', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: TextStyle(fontSize: 11, color: color)),
      ]),
    ));
  }
}
