import 'package:flutter/material.dart';

class AuditScreen extends StatefulWidget {
  const AuditScreen({super.key});

  @override
  State<AuditScreen> createState() => _AuditScreenState();
}

class _AuditScreenState extends State<AuditScreen> {
  int currentStep = 0;
  final int totalSteps = 6;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: Container(
        width: 920,
        height: 680,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          children: [
            // Верхняя панель
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Анкета бизнеса',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        '${currentStep + 1} / $totalSteps',
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Прогресс бар
            LinearProgressIndicator(
              value: (currentStep + 1) / totalSteps,
              backgroundColor: Colors.grey[200],
              color: Colors.blue,
              minHeight: 6,
            ),

            // Основное содержимое
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: _buildCurrentStep(),
              ),
            ),

            // Кнопки навигации
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (currentStep > 0)
                    OutlinedButton(
                      onPressed: () => setState(() => currentStep--),
                      child: const Text('Назад'),
                    )
                  else
                    const SizedBox.shrink(),

                  ElevatedButton(
                    onPressed: () {
                      if (currentStep < totalSteps - 1) {
                        setState(() => currentStep++);
                      } else {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Анкета успешно завершена!')),
                        );
                      }
                    },
                    child: Text(currentStep == totalSteps - 1 ? 'Завершить анкету' : 'Далее'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (currentStep) {
      case 0:
        return _buildStepGeneral();
      case 1:
        return _buildStepFinance();
      case 2:
        return _buildStepMarketing();
      case 3:
        return _buildStepOperations();
      case 4:
        return _buildStepHR();
      case 5:
        return _buildStepStrategy();
      default:
        return const Center(child: Text('Шаг не найден'));
    }
  }

  // Шаг 1 — Общая информация
  Widget _buildStepGeneral() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Общая информация о компании', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        // Здесь будут поля формы
        const Text('Название компании'),
        const SizedBox(height: 8),
        TextField(decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
        const SizedBox(height: 16),
        const Text('ИНН'),
        const SizedBox(height: 8),
        TextField(decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
      ],
    );
  }

  Widget _buildStepFinance() => const Center(child: Text('Шаг 2 — Финансовые показатели'));
  Widget _buildStepMarketing() => const Center(child: Text('Шаг 3 — Маркетинг и продажи'));
  Widget _buildStepOperations() => const Center(child: Text('Шаг 4 — Операционная деятельность'));
  Widget _buildStepHR() => const Center(child: Text('Шаг 5 — Персонал и HR'));
  Widget _buildStepStrategy() => const Center(child: Text('Шаг 6 — Цифровизация и стратегия'));
}