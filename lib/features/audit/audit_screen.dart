import 'package:flutter/material.dart';

class AuditData {
  String companyName = '';
  String inn = '';
  String industry = '';
  String legalForm = '';
  String foundedYear = '';
  String region = '';
  String description = '';
  String annualRevenue = '';
  String revenueGrowth = '';
  String netProfit = '';
  String mainCosts = '';
  bool hasAccounting = false;
  bool hasFinancialPlan = false;
  List<String> selectedChannels = [];
  String monthlyLeads = '';
  String conversionRate = '';
  String avgCheck = '';
  bool hasCRM = false;
  bool hasWebsite = false;
  bool hasSMM = false;
  String mainProcesses = '';
  String bottlenecks = '';
  bool hasAutomation = false;
  bool hasQualityControl = false;
  String softwareUsed = '';
  String productionCapacity = '';
  String employeeCount = '';
  String avgSalary = '';
  String turnoverRate = '';
  bool hasHRDept = false;
  bool hasTraining = false;
  String keyRoles = '';
  String hiringPlan = '';
  String digitalLevel = '';
  List<String> digitalTools = [];
  String strategicGoals = '';
  String mainChallenges = '';
  String growthPriority = '';
  bool wantsRoadmap = true;
}

class AuditScreen extends StatefulWidget {
  const AuditScreen({super.key});

  @override
  State<AuditScreen> createState() => _AuditScreenState();
}

class _AuditScreenState extends State<AuditScreen> {
  int currentStep = 0;
  final int totalSteps = 6;
  final AuditData data = AuditData();

  static const List<Map<String, dynamic>> _steps = [
    {'icon': Icons.business, 'label': 'Общее'},
    {'icon': Icons.attach_money, 'label': 'Финансы'},
    {'icon': Icons.campaign, 'label': 'Маркетинг'},
    {'icon': Icons.settings, 'label': 'Операции'},
    {'icon': Icons.people, 'label': 'Персонал'},
    {'icon': Icons.rocket_launch, 'label': 'Стратегия'},
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: Container(
        width: 920,
        height: 700,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.18), blurRadius: 24, spreadRadius: 4)],
        ),
        child: Column(
          children: [
            _buildHeader(),
            _buildStepIndicator(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(32, 24, 32, 8),
                child: _buildCurrentStep(),
              ),
            ),
            _buildNavButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() => Container(
    padding: const EdgeInsets.fromLTRB(28, 20, 20, 16),
    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE)))),
    child: Row(children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
        child: const Icon(Icons.assignment_outlined, color: Colors.blue, size: 22),
      ),
      const SizedBox(width: 14),
      const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Анкета бизнеса', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text('Заполните информацию для создания дорожной карты', style: TextStyle(fontSize: 13, color: Colors.grey)),
      ]),
      const Spacer(),
      IconButton(icon: const Icon(Icons.close, color: Colors.grey), onPressed: () => Navigator.pop(context)),
    ]),
  );

  Widget _buildStepIndicator() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
    decoration: const BoxDecoration(color: Color(0xFFF8F9FA), border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE)))),
    child: Row(children: List.generate(totalSteps, (i) {
      final isActive = i == currentStep;
      final isDone = i < currentStep;
      return Expanded(child: Row(children: [
        Expanded(child: GestureDetector(
          onTap: isDone ? () => setState(() => currentStep = i) : null,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 30, height: 30,
              decoration: BoxDecoration(
                color: isDone ? Colors.green : isActive ? Colors.blue : Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Icon(isDone ? Icons.check : _steps[i]['icon'] as IconData, size: 16, color: (isDone || isActive) ? Colors.white : Colors.grey),
            ),
            const SizedBox(width: 6),
            Text(_steps[i]['label'] as String, style: TextStyle(
              fontSize: 13,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              color: isActive ? Colors.blue : isDone ? Colors.green : Colors.grey,
            )),
          ]),
        )),
        if (i < totalSteps - 1)
          Container(height: 1, width: 20, color: i < currentStep ? Colors.green[200] : Colors.grey[300]),
      ]));
    })),
  );

  Widget _buildNavButtons() => Container(
    padding: const EdgeInsets.fromLTRB(28, 12, 28, 20),
    decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFFEEEEEE)))),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text('Шаг ${currentStep + 1} из $totalSteps', style: const TextStyle(fontSize: 13, color: Colors.grey)),
      Row(children: [
        if (currentStep > 0)
          OutlinedButton.icon(
            onPressed: () => setState(() => currentStep--),
            icon: const Icon(Icons.arrow_back, size: 16),
            label: const Text('Назад'),
            style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          ),
        const SizedBox(width: 12),
        ElevatedButton.icon(
          onPressed: _onNext,
          icon: Icon(currentStep == totalSteps - 1 ? Icons.check_circle_outline : Icons.arrow_forward, size: 16),
          label: Text(currentStep == totalSteps - 1 ? 'Завершить анкету' : 'Далее'),
          style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        ),
      ]),
    ]),
  );

  void _onNext() {
    if (currentStep < totalSteps - 1) {
      setState(() => currentStep++);
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Анкета для "${data.companyName.isNotEmpty ? data.companyName : 'вашей компании'}" завершена!')),
      );
    }
  }

  Widget _buildCurrentStep() {
    switch (currentStep) {
      case 0: return _buildStepGeneral();
      case 1: return _buildStepFinance();
      case 2: return _buildStepMarketing();
      case 3: return _buildStepOperations();
      case 4: return _buildStepHR();
      case 5: return _buildStepStrategy();
      default: return const SizedBox();
    }
  }

  // ==================== ШАГИ ====================

  Widget _buildStepGeneral() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    _stepTitle('Общая информация о компании', 'Расскажите нам о вашем бизнесе'),
    const SizedBox(height: 24),
    Row(children: [
      Expanded(child: _field('Название компании *', Icons.business, initial: data.companyName, onChanged: (v) => data.companyName = v)),
      const SizedBox(width: 16),
      Expanded(child: _field('ИНН', Icons.numbers, initial: data.inn, onChanged: (v) => data.inn = v, inputType: TextInputType.number)),
    ]),
    const SizedBox(height: 16),
    Row(children: [
      Expanded(child: _dropdown('Отрасль *', _industries, value: data.industry, onChanged: (v) => setState(() => data.industry = v ?? ''))),
      const SizedBox(width: 16),
      Expanded(child: _dropdown('Организационно-правовая форма', _legalForms, value: data.legalForm, onChanged: (v) => setState(() => data.legalForm = v ?? ''))),
    ]),
    const SizedBox(height: 16),
    Row(children: [
      Expanded(child: _field('Год основания', Icons.calendar_today, initial: data.foundedYear, onChanged: (v) => data.foundedYear = v)),
      const SizedBox(width: 16),
      Expanded(child: _field('Регион / город', Icons.location_on, initial: data.region, onChanged: (v) => data.region = v)),
    ]),
    const SizedBox(height: 16),
    _field('Краткое описание бизнеса', Icons.description, initial: data.description, onChanged: (v) => data.description = v, maxLines: 3),
  ]);

  Widget _buildStepFinance() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    _stepTitle('Финансовые показатели', 'Текущее состояние финансов компании'),
    const SizedBox(height: 24),
    Row(children: [
      Expanded(child: _field('Годовая выручка (руб.)', Icons.trending_up, initial: data.annualRevenue, onChanged: (v) => data.annualRevenue = v)),
      const SizedBox(width: 16),
      Expanded(child: _dropdown('Рост выручки за последний год', _growthOptions, value: data.revenueGrowth, onChanged: (v) => setState(() => data.revenueGrowth = v ?? ''))),
    ]),
    const SizedBox(height: 16),
    Row(children: [
      Expanded(child: _field('Чистая прибыль (руб.)', Icons.account_balance_wallet, initial: data.netProfit, onChanged: (v) => data.netProfit = v)),
      const SizedBox(width: 16),
      Expanded(child: _field('Основные статьи расходов', Icons.receipt_long, initial: data.mainCosts, onChanged: (v) => data.mainCosts = v)),
    ]),
    const SizedBox(height: 20),
    _sectionLabel('Управление финансами'),
    Row(children: [
      Expanded(child: _switchTile('Ведётся бухгалтерский учёт', Icons.book_outlined, data.hasAccounting, (v) => setState(() => data.hasAccounting = v))),
      const SizedBox(width: 16),
      Expanded(child: _switchTile('Есть финансовый план / бюджет', Icons.pie_chart_outline, data.hasFinancialPlan, (v) => setState(() => data.hasFinancialPlan = v))),
    ]),
  ]);

  Widget _buildStepMarketing() {
    final channels = ['SEO / сайт', 'Соцсети', 'Контекстная реклама', 'Рекомендации', 'Холодные звонки', 'Email-рассылка', 'Маркетплейсы', 'Офлайн'];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _stepTitle('Маркетинг и продажи', 'Как вы привлекаете и удерживаете клиентов'),
      const SizedBox(height: 24),
      _sectionLabel('Каналы привлечения клиентов'),
      Wrap(spacing: 8, runSpacing: 8, children: channels.map((ch) {
        final selected = data.selectedChannels.contains(ch);
        return FilterChip(
          label: Text(ch),
          selected: selected,
          onSelected: (v) => setState(() {
            if (v) data.selectedChannels.add(ch);
            else data.selectedChannels.remove(ch);
          }),
        );
      }).toList()),
      const SizedBox(height: 20),
      Row(children: [
        Expanded(child: _field('Лидов в месяц', Icons.person_add_outlined, initial: data.monthlyLeads, onChanged: (v) => data.monthlyLeads = v)),
        const SizedBox(width: 16),
        Expanded(child: _field('Конверсия в продажу (%)', Icons.percent, initial: data.conversionRate, onChanged: (v) => data.conversionRate = v)),
        const SizedBox(width: 16),
        Expanded(child: _field('Средний чек (руб.)', Icons.shopping_bag_outlined, initial: data.avgCheck, onChanged: (v) => data.avgCheck = v)),
      ]),
      const SizedBox(height: 20),
      _sectionLabel('Инструменты продаж'),
      Row(children: [
        Expanded(child: _switchTile('Есть CRM-система', Icons.business_center, data.hasCRM, (v) => setState(() => data.hasCRM = v))),
        const SizedBox(width: 16),
        Expanded(child: _switchTile('Есть сайт', Icons.language, data.hasWebsite, (v) => setState(() => data.hasWebsite = v))),
        const SizedBox(width: 16),
        Expanded(child: _switchTile('Ведутся соцсети', Icons.thumb_up_outlined, data.hasSMM, (v) => setState(() => data.hasSMM = v))),
      ]),
    ]);
  }

  Widget _buildStepOperations() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    _stepTitle('Операционная деятельность', 'Бизнес-процессы, автоматизация, качество'),
    const SizedBox(height: 24),
    _field('Основные бизнес-процессы', Icons.account_tree_outlined, initial: data.mainProcesses, onChanged: (v) => data.mainProcesses = v, maxLines: 3),
    const SizedBox(height: 16),
    _field('Основные узкие места / проблемы', Icons.warning_amber_outlined, initial: data.bottlenecks, onChanged: (v) => data.bottlenecks = v, maxLines: 2),
    const SizedBox(height: 16),
    Row(children: [
      Expanded(child: _field('Используемое ПО', Icons.computer, initial: data.softwareUsed, onChanged: (v) => data.softwareUsed = v)),
      const SizedBox(width: 16),
      Expanded(child: _field('Производственная мощность', Icons.factory_outlined, initial: data.productionCapacity, onChanged: (v) => data.productionCapacity = v)),
    ]),
    const SizedBox(height: 20),
    _sectionLabel('Зрелость процессов'),
    Row(children: [
      Expanded(child: _switchTile('Есть автоматизация процессов', Icons.precision_manufacturing_outlined, data.hasAutomation, (v) => setState(() => data.hasAutomation = v))),
      const SizedBox(width: 16),
      Expanded(child: _switchTile('Контроль качества выстроен', Icons.verified_outlined, data.hasQualityControl, (v) => setState(() => data.hasQualityControl = v))),
    ]),
  ]);

  Widget _buildStepHR() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    _stepTitle('Персонал и HR', 'Команда, найм, удержание'),
    const SizedBox(height: 24),
    Row(children: [
      Expanded(child: _field('Количество сотрудников', Icons.people_outline, initial: data.employeeCount, onChanged: (v) => data.employeeCount = v)),
      const SizedBox(width: 16),
      Expanded(child: _field('Средняя зарплата', Icons.payments_outlined, initial: data.avgSalary, onChanged: (v) => data.avgSalary = v)),
      const SizedBox(width: 16),
      Expanded(child: _dropdown('Текучесть кадров', _turnoverOptions, value: data.turnoverRate, onChanged: (v) => setState(() => data.turnoverRate = v ?? ''))),
    ]),
    const SizedBox(height: 16),
    _field('Ключевые роли', Icons.badge_outlined, initial: data.keyRoles, onChanged: (v) => data.keyRoles = v),
    const SizedBox(height: 16),
    _field('План найма на год', Icons.person_search_outlined, initial: data.hiringPlan, onChanged: (v) => data.hiringPlan = v, maxLines: 2),
  ]);

  Widget _buildStepStrategy() {
    final tools = ['1С / ERP', 'CRM', 'ЭДО', 'Аналитика / BI', 'Онлайн-касса', 'Маркетплейс', 'Мобильное приложение'];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _stepTitle('Цифровизация и стратегия', 'Ваши цели и приоритеты'),
      const SizedBox(height: 24),
      _dropdown('Уровень цифровизации', _digitalLevels, value: data.digitalLevel, onChanged: (v) => setState(() => data.digitalLevel = v ?? '')),
      const SizedBox(height: 16),
      _sectionLabel('Используемые цифровые инструменты'),
      Wrap(spacing: 8, runSpacing: 8, children: tools.map((t) {
        final selected = data.digitalTools.contains(t);
        return FilterChip(
          label: Text(t),
          selected: selected,
          onSelected: (v) => setState(() {
            if (v) data.digitalTools.add(t);
            else data.digitalTools.remove(t);
          }),
        );
      }).toList()),
      const SizedBox(height: 20),
      _field('Стратегические цели', Icons.flag_outlined, initial: data.strategicGoals, onChanged: (v) => data.strategicGoals = v, maxLines: 2),
      const SizedBox(height: 16),
      _field('Главные вызовы', Icons.report_problem_outlined, initial: data.mainChallenges, onChanged: (v) => data.mainChallenges = v, maxLines: 2),
    ]);
  }

  // ==================== ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ ====================
  Widget _stepTitle(String title, String subtitle) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    const SizedBox(height: 4),
    Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.grey)),
  ]);

  Widget _sectionLabel(String label) => Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600));

  Widget _field(String label, IconData icon, {required Function(String) onChanged, String hint = '', String initial = '', int maxLines = 1, TextInputType inputType = TextInputType.text}) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      const SizedBox(height: 6),
      TextFormField(
        initialValue: initial,
        onChanged: onChanged,
        maxLines: maxLines,
        keyboardType: inputType,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, size: 18, color: Colors.grey),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: const Color(0xFFFAFAFA),
        ),
      ),
    ],
  );

    Widget _dropdown(String label, List<String> items, {String? value, required Function(String?) onChanged}) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      const SizedBox(height: 6),
      DropdownButtonFormField<String>(
        value: value != null && items.contains(value) ? value : null, // ← Вот исправление
        isExpanded: true,
        hint: const Text('Выберите...', style: TextStyle(fontSize: 13, color: Colors.grey)),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: const Color(0xFFFAFAFA),
        ),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
      ),
    ],
  );

  Widget _switchTile(String label, IconData icon, bool value, Function(bool) onChanged) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(
      color: value ? Colors.blue.withOpacity(0.06) : const Color(0xFFF8F9FA),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: value ? Colors.blue.withOpacity(0.3) : const Color(0xFFE0E0E0)),
    ),
    child: Row(children: [
      Icon(icon, size: 18, color: value ? Colors.blue : Colors.grey),
      const SizedBox(width: 8),
      Expanded(child: Text(label)),
      Switch(value: value, onChanged: onChanged, activeColor: Colors.blue),
    ]),
  );

  // Справочники
  static const _industries = ['IT и технологии', 'Торговля', 'Производство', 'Строительство', 'Логистика', 'Общественное питание', 'Другое'];
  static const _legalForms = ['ООО', 'ИП', 'АО', 'Самозанятый'];
  static const _growthOptions = ['Снизилась', 'Не изменилась', 'Выросла'];
  static const _turnoverOptions = ['Низкая', 'Умеренная', 'Высокая'];
  static const _digitalLevels = ['Минимальный', 'Базовый', 'Средний', 'Продвинутый', 'Высокий'];
}