import 'package:flutter/material.dart';
import 'package:my_business_app/features/roadmap/roadmaps_screen.dart';
import 'package:provider/provider.dart';
import 'package:my_business_app/features/roadmap/roadmap_provider.dart';
import 'package:my_business_app/features/expert/expert_screen.dart';

class RoadmapMessageWidget extends StatelessWidget {
  final VoidCallback onPin;
  final bool isPinned;

  const RoadmapMessageWidget({
    super.key,
    required this.onPin,
    required this.isPinned,
  });

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
          boxShadow: [BoxShadow(
              color: Colors.black.withOpacity(0.04), blurRadius: 8)],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 10, 14),
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
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 2),
                Text('$totalTasks задач на 12 месяцев',
                    style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ])),

              GestureDetector(
                onTap: onPin,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: isPinned
                        ? Colors.white.withOpacity(0.3)
                        : Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.white.withOpacity(isPinned ? 0.8 : 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(
                      isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                      color: Colors.white,
                      size: 15,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isPinned ? 'Закреплено' : 'Закрепить',
                      style: const TextStyle(color: Colors.white, fontSize: 11,
                          fontWeight: FontWeight.w500),
                    ),
                  ]),
                ),
              ),
            ]),
          ),

          if (roadmap.executiveSummary.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Text(roadmap.executiveSummary,
                  style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.5)),
            ),

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

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => ExpertScreen())),
                  icon: const Icon(Icons.people_outline, size: 18),
                  label: const Text('Оценка экспертов'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF534AB7),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => RoadmapsScreen())),
                  icon: const Icon(Icons.map_outlined, size: 18),
                  label: const Text('Открыть дорожную карту'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF534AB7),
                    side: const BorderSide(color: Color(0xFF534AB7)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
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
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(children: [
        Text('$count', style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: TextStyle(fontSize: 11, color: color)),
      ]),
    ));
  }
}