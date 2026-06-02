import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'roadmap_provider.dart';
import 'roadmap_pdf_export.dart';
import 'package:my_business_app/features/expert/expert_screen.dart';

class RoadmapsScreen extends StatefulWidget {
  const RoadmapsScreen({super.key});

  @override
  State<RoadmapsScreen> createState() => _RoadmapsScreenState();
}

class _RoadmapsScreenState extends State<RoadmapsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RoadmapProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) return _buildLoading(context);
        if (provider.error != null) return _buildError(context, provider);
        if (!provider.hasRoadmap) return _buildEmpty(context);
        return _buildRoadmap(context, provider.roadmap!, provider);
      },
    );
  }

  Widget _buildLoading(BuildContext context) => Scaffold(
    appBar: _simpleAppBar(context, 'Дорожная карта'),
    body: const Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        CircularProgressIndicator(color: Color(0xFF534AB7)),
        SizedBox(height: 24),
        Text('ИИ анализирует ваш бизнес...', style: TextStyle(fontSize: 16, color: Colors.grey)),
        SizedBox(height: 8),
        Text('Это займёт 10–30 секунд', style: TextStyle(fontSize: 13, color: Colors.grey)),
      ]),
    ),
  );

  Widget _buildError(BuildContext context, RoadmapProvider provider) => Scaffold(
    appBar: _simpleAppBar(context, 'Дорожная карта'),
    body: Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.error_outline, size: 64, color: Colors.red),
        const SizedBox(height: 16),
        const Text('Не удалось создать дорожную карту',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(provider.error ?? '',
              textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: provider.clear,
          icon: const Icon(Icons.refresh),
          label: const Text('Попробовать снова'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF534AB7), foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ]),
    ),
  );

  Widget _buildEmpty(BuildContext context) => Scaffold(
    appBar: _simpleAppBar(context, 'Дорожная карта'),
    body: Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.map_outlined, size: 80, color: Colors.grey[300]),
        const SizedBox(height: 24),
        const Text('Дорожная карта не создана',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        const Text('Пройдите анкету бизнеса, и ИИ составит\nперсональный план развития на 12 месяцев',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.grey, height: 1.5)),
      ]),
    ),
  );

  // ── Основной экран ─────────────────────────
  Widget _buildRoadmap(BuildContext context, Roadmap roadmap, RoadmapProvider provider) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              roadmap.companyName.isNotEmpty ? roadmap.companyName : 'Дорожная карта',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)),
              overflow: TextOverflow.ellipsis,
            ),
            Text('Создана ${_formatDate(roadmap.createdAt)}',
                style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ])),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_outlined, color: Colors.grey, size: 22),
            tooltip: 'Экспорт в PDF',
            onPressed: () => RoadmapPdfExport.export(context, roadmap),
          ),
          IconButton(
            icon: const Icon(Icons.refresh_outlined, color: Colors.grey, size: 22),
            tooltip: 'Пересоздать',
            onPressed: () => _showRegenerateDialog(context, provider),
          ),
        ]),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFEEEEF0)),
        ),
      ),

      // ── Две кнопки справа снизу ──
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'experts',
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => ExpertScreen())),
            backgroundColor: const Color(0xFF534AB7),
            icon: const Icon(Icons.people_outline, color: Colors.white, size: 20),
            label: const Text('Эксперты',
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

      body: Column(children: [
        _buildSummaryCard(roadmap),
        _buildStats(roadmap),
        _buildTabBar(),
        Expanded(child: _buildTabContent(roadmap, provider)),
      ]),
    );
  }

  // ── Простой AppBar с кнопкой назад ─────────
  AppBar _simpleAppBar(BuildContext context, String title) => AppBar(
    backgroundColor: Colors.white, elevation: 0,
    leading: TextButton.icon(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(Icons.arrow_back, size: 16, color: Color(0xFF534AB7)),
      label: const Text('Чат', style: TextStyle(color: Color(0xFF534AB7), fontSize: 14)),
    ),
    leadingWidth: 90,
    title: Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
    bottom: const PreferredSize(preferredSize: Size.fromHeight(1), child: Divider(height: 1)),
  );

  // ── Резюме ─────────────────────────────────
  Widget _buildSummaryCard(Roadmap roadmap) => Container(
    color: Colors.white,
    padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEEEDFE), Color(0xFFE6F1FB)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Icon(Icons.auto_awesome, color: Color(0xFF534AB7), size: 18),
        const SizedBox(width: 10),
        Expanded(child: Text(roadmap.executiveSummary,
            style: const TextStyle(fontSize: 13, height: 1.5, color: Color(0xFF2D2B55)))),
      ]),
    ),
  );

  // ── Статистика ─────────────────────────────
  Widget _buildStats(Roadmap roadmap) => Container(
    color: Colors.white,
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
    child: Row(children: TaskPeriod.values.map((p) {
      final count    = roadmap.byPeriod(p).length;
      final done     = roadmap.byPeriod(p).where((t) => t.status == TaskStatus.done).length;
      final progress = count > 0 ? done / count : 0.0;
      final colors   = [const Color(0xFF1D9E75), const Color(0xFF378ADD), const Color(0xFF534AB7)];
      final idx      = p.index;
      return Expanded(child: Container(
        margin: EdgeInsets.only(right: idx < 2 ? 10 : 0),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors[idx].withOpacity(0.07),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: colors[idx].withOpacity(0.2)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(p.shortLabel,
              style: TextStyle(fontSize: 12, color: colors[idx], fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text('$count задач', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(value: progress, minHeight: 4,
                backgroundColor: colors[idx].withOpacity(0.15), color: colors[idx]),
          ),
          const SizedBox(height: 4),
          Text('$done из $count выполнено',
              style: TextStyle(fontSize: 11, color: colors[idx])),
        ]),
      ));
    }).toList()),
  );

  // ── Таб-бар ────────────────────────────────
  Widget _buildTabBar() => Container(
    color: Colors.white,
    child: TabBar(
      controller: _tabController,
      labelColor: const Color(0xFF534AB7),
      unselectedLabelColor: Colors.grey,
      indicatorColor: const Color(0xFF534AB7),
      indicatorWeight: 2,
      tabs: TaskPeriod.values.map((p) => Tab(text: p.label)).toList(),
    ),
  );

  // ── Список задач ───────────────────────────
  Widget _buildTabContent(Roadmap roadmap, RoadmapProvider provider) => TabBarView(
    controller: _tabController,
    children: TaskPeriod.values.map((p) {
      final tasks = roadmap.byPeriod(p);
      if (tasks.isEmpty) return const Center(
          child: Text('Нет задач для этого периода', style: TextStyle(color: Colors.grey)));
      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        itemCount: tasks.length,
        itemBuilder: (ctx, i) => _buildTaskCard(tasks[i], provider),
      );
    }).toList(),
  );

  // ── Карточка задачи ────────────────────────
  Widget _buildTaskCard(RoadmapTask task, RoadmapProvider provider) {
    final isDone       = task.status == TaskStatus.done;
    final isInProgress = task.status == TaskStatus.inProgress;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDone ? const Color(0xFFF0FAF5) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDone
              ? const Color(0xFF1D9E75).withOpacity(0.3)
              : isInProgress
                  ? const Color(0xFF534AB7).withOpacity(0.3)
                  : const Color(0xFFE8E8E8),
        ),
      ),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 10, 8),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: task.category.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(task.category.icon, size: 12, color: task.category.color),
                const SizedBox(width: 4),
                Text(task.category.label,
                    style: TextStyle(fontSize: 11, color: task.category.color, fontWeight: FontWeight.w600)),
              ]),
            ),
            const SizedBox(width: 8),
            _priorityBadge(task.priority),
            const Spacer(),
            _statusDropdown(task, provider),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 6),
          child: Row(children: [
            if (isDone) const Padding(padding: EdgeInsets.only(right: 8),
                child: Icon(Icons.check_circle, color: Color(0xFF1D9E75), size: 18)),
            Expanded(child: Text(task.title, style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w600,
              decoration: isDone ? TextDecoration.lineThrough : null,
              color: isDone ? Colors.grey : Colors.black87,
            ))),
          ]),
        ),
        if (task.description.isNotEmpty)
          Padding(padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
              child: Text(task.description,
                  style: const TextStyle(fontSize: 13, color: Colors.grey, height: 1.4))),
        if (task.result.isNotEmpty)
          Container(
            margin: const EdgeInsets.fromLTRB(14, 0, 14, 12),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FAF5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.flag_outlined, size: 14, color: Color(0xFF1D9E75)),
              const SizedBox(width: 6),
              Expanded(child: Text(task.result,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF0F6E56), height: 1.4))),
            ]),
          ),
      ]),
    );
  }

  Widget _priorityBadge(int priority) {
    final labels = ['', 'Критично', 'Высокий', 'Средний', 'Низкий', 'Минимум'];
    final colors = [Colors.grey, Colors.red, Colors.orange, Colors.blue, Colors.teal, Colors.grey];
    final p = priority.clamp(1, 5);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
          color: colors[p].withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
      child: Text(labels[p],
          style: TextStyle(fontSize: 11, color: colors[p], fontWeight: FontWeight.w500)),
    );
  }

  Widget _statusDropdown(RoadmapTask task, RoadmapProvider provider) {
    final items = {
      TaskStatus.pending:    ('Не начата', Colors.grey),
      TaskStatus.inProgress: ('В работе',  const Color(0xFF534AB7)),
      TaskStatus.done:       ('Выполнено', const Color(0xFF1D9E75)),
    };
    return DropdownButton<TaskStatus>(
      value: task.status, underline: const SizedBox(), isDense: true,
      style: const TextStyle(fontSize: 12),
      items: items.entries.map((e) => DropdownMenuItem(
        value: e.key,
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 8, height: 8,
              decoration: BoxDecoration(color: e.value.$2, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text(e.value.$1, style: TextStyle(color: e.value.$2, fontWeight: FontWeight.w500)),
        ]),
      )).toList(),
      onChanged: (v) { if (v != null) provider.updateTaskStatus(task.id, v); },
    );
  }

  void _showRegenerateDialog(BuildContext context, RoadmapProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Пересоздать карту?'),
        content: const Text('Текущий прогресс задач будет потерян. Продолжить?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
          ElevatedButton(
            onPressed: () {
              provider.clear();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF534AB7), foregroundColor: Colors.white),
            child: const Text('Пересоздать'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}';
}
