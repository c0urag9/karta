import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../audit/audit_screen.dart';

enum TaskPeriod { threeMonths, sixMonths, twelveMonths }
enum TaskStatus { pending, inProgress, done }
enum TaskCategory { finance, marketing, operations, hr, digital, strategy }

extension TaskPeriodLabel on TaskPeriod {
  String get label {
    switch (this) {
      case TaskPeriod.threeMonths:  return '1–3 месяца';
      case TaskPeriod.sixMonths:    return '3–6 месяцев';
      case TaskPeriod.twelveMonths: return '6–12 месяцев';
    }
  }
  String get shortLabel {
    switch (this) {
      case TaskPeriod.threeMonths:  return '1–3 мес';
      case TaskPeriod.sixMonths:    return '3–6 мес';
      case TaskPeriod.twelveMonths: return '6–12 мес';
    }
  }
}

extension TaskCategoryInfo on TaskCategory {
  String get label {
    switch (this) {
      case TaskCategory.finance:    return 'Финансы';
      case TaskCategory.marketing:  return 'Маркетинг';
      case TaskCategory.operations: return 'Операции';
      case TaskCategory.hr:         return 'Персонал';
      case TaskCategory.digital:    return 'Цифровизация';
      case TaskCategory.strategy:   return 'Стратегия';
    }
  }
  Color get color {
    switch (this) {
      case TaskCategory.finance:    return const Color(0xFF1D9E75);
      case TaskCategory.marketing:  return const Color(0xFF378ADD);
      case TaskCategory.operations: return const Color(0xFFEF9F27);
      case TaskCategory.hr:         return const Color(0xFF9B59B6);
      case TaskCategory.digital:    return const Color(0xFF534AB7);
      case TaskCategory.strategy:   return const Color(0xFFE74C3C);
    }
  }
  IconData get icon {
    switch (this) {
      case TaskCategory.finance:    return Icons.attach_money;
      case TaskCategory.marketing:  return Icons.campaign;
      case TaskCategory.operations: return Icons.settings;
      case TaskCategory.hr:         return Icons.people;
      case TaskCategory.digital:    return Icons.computer;
      case TaskCategory.strategy:   return Icons.rocket_launch;
    }
  }

  static TaskCategory fromString(String s) {
    switch (s.toLowerCase()) {
      case 'финансы':      return TaskCategory.finance;
      case 'маркетинг':    return TaskCategory.marketing;
      case 'операции':     return TaskCategory.operations;
      case 'персонал':     return TaskCategory.hr;
      case 'цифровизация': return TaskCategory.digital;
      default:             return TaskCategory.strategy;
    }
  }
}

class RoadmapTask {
  final String id;
  final String title;
  final String description;
  final String result;
  final TaskPeriod period;
  final TaskCategory category;
  final int priority;
  TaskStatus status;

  RoadmapTask({
    required this.id,
    required this.title,
    required this.description,
    required this.result,
    required this.period,
    required this.category,
    this.priority = 1,
    this.status = TaskStatus.pending,
  });
}

class Roadmap {
  final String id;
  final String companyName;
  final String executiveSummary;
  final List<RoadmapTask> tasks;
  final DateTime createdAt;

  Roadmap({
    required this.id,
    required this.companyName,
    required this.executiveSummary,
    required this.tasks,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  List<RoadmapTask> byPeriod(TaskPeriod p) =>
      tasks.where((t) => t.period == p).toList()
        ..sort((a, b) => a.priority.compareTo(b.priority));
}

class RoadmapProvider extends ChangeNotifier {
  static const String _token  = '';
  static const String _apiUrl = '';
  static const String _model  = '';

  Roadmap? _roadmap;
  bool _isLoading = false;
  String? _error;

  Roadmap? get roadmap => _roadmap;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasRoadmap => _roadmap != null;

  Future<void> generate(AuditData data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {
              'role': 'system',
              'content': 'Ты эксперт МСБ. Отвечай ТОЛЬКО валидным JSON без markdown.',
            },
            {'role': 'user', 'content': _buildPrompt(data)},
          ],
          'max_tokens': 2000,
          'temperature': 0.6,
        }),
      ).timeout(
        const Duration(seconds: 60),
        onTimeout: () => throw Exception('Превышено время ожидания. Попробуйте снова.'),
      );

      debugPrint('Status: ${response.statusCode}');
      debugPrint('Body: ${response.body.substring(0, response.body.length.clamp(0, 300))}');

      if (response.statusCode != 200) {
        final err = jsonDecode(response.body);
        throw Exception('Ошибка API ${response.statusCode}: ${err['error']?['message'] ?? response.body}');
      }

      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      final content = decoded['choices'][0]['message']['content'] as String;
      final clean   = content.replaceAll('```json', '').replaceAll('```', '').trim();
      final Map<String, dynamic> json = jsonDecode(clean);
      _roadmap = _parseRoadmap(data.companyName, json);

    } catch (e) {
      _error = e.toString();
      debugPrint('RoadmapProvider error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateTaskStatus(String taskId, TaskStatus status) {
    final idx = _roadmap?.tasks.indexWhere((t) => t.id == taskId) ?? -1;
    if (idx != -1) {
      _roadmap!.tasks[idx].status = status;
      notifyListeners();
    }
  }

  void clear() {
    _roadmap = null;
    _error = null;
    notifyListeners();
  }

  String _buildPrompt(AuditData d) => '''
Создай дорожную карту МСБ. Верни ТОЛЬКО JSON, без текста до/после.

Компания: ${d.companyName}, ${d.industry}, ${d.region}
Выручка: ${d.annualRevenue} руб., сотрудников: ${d.employeeCount}
Проблемы: ${d.bottlenecks}
Цели: ${d.strategicGoals}
Приоритет: ${d.growthPriority}

Формат:
{
  "summary": "2 предложения об анализе",
  "tasks": [
    {
      "id": "1",
      "title": "Название до 50 символов",
      "description": "Что сделать",
      "result": "Измеримый результат",
      "period": "3months",
      "category": "Финансы",
      "priority": 1
    }
  ]
}

period: "3months"|"6months"|"12months"
category: "Финансы"|"Маркетинг"|"Операции"|"Персонал"|"Цифровизация"|"Стратегия"
Ровно 3 задачи на каждый период, итого 9 задач.
''';

  Roadmap _parseRoadmap(String companyName, Map<String, dynamic> json) {
    final rawTasks = json['tasks'];
    if (rawTasks == null || rawTasks is! List) {
      throw Exception('Неверный формат: нет поля tasks');
    }

    final tasks = (rawTasks as List).map((t) {
      final periodStr = t['period'] as String? ?? '3months';
      final period = periodStr == '12months'
          ? TaskPeriod.twelveMonths
          : periodStr == '6months'
              ? TaskPeriod.sixMonths
              : TaskPeriod.threeMonths;

      return RoadmapTask(
        id: t['id']?.toString() ?? UniqueKey().toString(),
        title: t['title']?.toString() ?? '',
        description: t['description']?.toString() ?? '',
        result: t['result']?.toString() ?? '',
        period: period,
        category: TaskCategoryInfo.fromString(t['category']?.toString() ?? ''),
        priority: (t['priority'] as num?)?.toInt() ?? 3,
      );
    }).toList();

    return Roadmap(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      companyName: companyName,
      executiveSummary: json['summary']?.toString() ?? '',
      tasks: tasks,
    );
  }
}