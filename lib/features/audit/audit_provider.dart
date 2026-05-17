import 'package:flutter/material.dart';
import 'dart:convert';
import '../../../services/ai_service.dart';
import '../../../models/roadmap.dart';
import 'audit_screen.dart';

class AuditProvider extends ChangeNotifier {
  final AiService _ai = AiService();

  bool _isGenerating = false;
  String? _error;
  Roadmap? _roadmap;

  bool get isGenerating => _isGenerating;
  String? get error => _error;
  Roadmap? get roadmap => _roadmap;

  /// Конвертировать AuditData в Map для отправки в ИИ
  Map<String, dynamic> _auditToMap(AuditData data) => {
    'Компания': data.companyName,
    'ИНН': data.inn,
    'Отрасль': data.industry,
    'Правовая форма': data.legalForm,
    'Год основания': data.foundedYear,
    'Регион': data.region,
    'Описание': data.description,
    'Годовая выручка': data.annualRevenue,
    'Рост выручки': data.revenueGrowth,
    'Чистая прибыль': data.netProfit,
    'Основные расходы': data.mainCosts,
    'Есть бухучёт': data.hasAccounting,
    'Есть финплан': data.hasFinancialPlan,
    'Каналы привлечения': data.selectedChannels.join(', '),
    'Лидов в месяц': data.monthlyLeads,
    'Конверсия %': data.conversionRate,
    'Средний чек': data.avgCheck,
    'Есть CRM': data.hasCRM,
    'Есть сайт': data.hasWebsite,
    'Есть SMM': data.hasSMM,
    'Бизнес-процессы': data.mainProcesses,
    'Узкие места': data.bottlenecks,
    'Автоматизация': data.hasAutomation,
    'Контроль качества': data.hasQualityControl,
    'ПО': data.softwareUsed,
    'Сотрудников': data.employeeCount,
    'Средняя зарплата': data.avgSalary,
    'Текучесть': data.turnoverRate,
    'HR-отдел': data.hasHRDept,
    'Обучение': data.hasTraining,
    'Ключевые роли': data.keyRoles,
    'Уровень цифровизации': data.digitalLevel,
    'Цифровые инструменты': data.digitalTools.join(', '),
    'Стратегические цели': data.strategicGoals,
    'Главные вызовы': data.mainChallenges,
    'Приоритет роста': data.growthPriority,
  };

  /// Сгенерировать дорожную карту на основе данных анкеты
  Future<void> generateRoadmap(AuditData data) async {
    _isGenerating = true;
    _error = null;
    notifyListeners();

    try {
      final jsonString = await _ai.generateRoadmap(_auditToMap(data));
      final clean = jsonString.replaceAll('```json', '').replaceAll('```', '').trim();
      final Map<String, dynamic> parsed = jsonDecode(clean);

      final tasks = (parsed['tasks'] as List).map((t) => RoadmapTask(
        id: t['id']?.toString() ?? UniqueKey().toString(),
        title: t['title'] ?? '',
        description: t['description'] ?? '',
        category: t['category'] ?? '',
        priority: (t['priority'] as num?)?.toInt() ?? 1,
      )).toList();

      _roadmap = Roadmap(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        companyName: data.companyName,
        summary: parsed['summary'] ?? '',
        tasks: tasks,
      );
    } catch (e) {
      _error = 'Ошибка генерации дорожной карты: $e';
    } finally {
      _isGenerating = false;
      notifyListeners();
    }
  }

  void clear() {
    _roadmap = null;
    _error = null;
    notifyListeners();
  }
}
