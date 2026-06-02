import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:my_business_app/features/roadmap/roadmap_provider.dart';

PdfColor pdfOpacity(PdfColor c, double opacity) =>
    PdfColor(c.red, c.green, c.blue, opacity);
 
class RoadmapPdfExport {
  static const _purple = PdfColor(0.325, 0.290, 0.718);
  static const _blue   = PdfColor(0.216, 0.541, 0.867);
  static const _teal   = PdfColor(0.114, 0.620, 0.459);
  static const _amber  = PdfColor(0.937, 0.624, 0.153);
  static const _violet = PdfColor(0.608, 0.349, 0.714);
  static const _red    = PdfColor(0.906, 0.455, 0.235);
  static const _dark   = PdfColor(0.102, 0.102, 0.180);
  static const _grey   = PdfColor(0.533, 0.533, 0.533);
  static const _white  = PdfColors.white;
  static const _lightBg = PdfColor(0.973, 0.976, 0.980);

  static PdfColor _categoryColor(TaskCategory cat) {
    switch (cat) {
      case TaskCategory.finance:    return _teal;
      case TaskCategory.marketing:  return _blue;
      case TaskCategory.operations: return _amber;
      case TaskCategory.hr:         return _violet;
      case TaskCategory.digital:    return _purple;
      case TaskCategory.strategy:   return _red;
    }
  }

  static PdfColor _periodColor(TaskPeriod p) {
    switch (p) {
      case TaskPeriod.threeMonths:  return _teal;
      case TaskPeriod.sixMonths:    return _blue;
      case TaskPeriod.twelveMonths: return _purple;
    }
  }

  static String _periodLabel(TaskPeriod p) {
    switch (p) {
      case TaskPeriod.threeMonths:  return '1-3 месяца';
      case TaskPeriod.sixMonths:    return '3-6 месяцев';
      case TaskPeriod.twelveMonths: return '6-12 месяцев';
    }
  }

  static String _statusLabel(TaskStatus s) {
    switch (s) {
      case TaskStatus.pending:    return 'Не начата';
      case TaskStatus.inProgress: return 'В работе';
      case TaskStatus.done:       return 'Выполнено';
    }
  }

  static PdfColor _statusColor(TaskStatus s) {
    switch (s) {
      case TaskStatus.pending:    return _grey;
      case TaskStatus.inProgress: return _purple;
      case TaskStatus.done:       return _teal;
    }
  }

  static Future<void> export(BuildContext context, Roadmap roadmap) async {
    final doc = pw.Document();

    final now = DateTime.now();
    final dateStr =
        '${now.day.toString().padLeft(2,'0')}.${now.month.toString().padLeft(2,'0')}.${now.year}';
    final totalTasks = roadmap.tasks.length;
    final doneTasks  = roadmap.tasks.where((t) => t.status == TaskStatus.done).length;

    doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.zero,
      build: (ctx) => pw.Column(children: [

        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.fromLTRB(40, 40, 40, 32),
          color: _purple,
          child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Row(children: [
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: pw.BoxDecoration(
                  color: pdfOpacity(_white, 0.2),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Text('БН', style: pw.TextStyle(
                    color: _white, fontSize: 16, fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(width: 12),
              pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                pw.Text('Бизнес-навигатор',
                    style: pw.TextStyle(color: _white, fontSize: 13, fontWeight: pw.FontWeight.bold)),
                pw.Text('AI-платформа развития МСБ',
                    style: pw.TextStyle(color: pdfOpacity(_white, 0.7), fontSize: 10)),
              ]),
              pw.Spacer(),
              pw.Text(dateStr,
                  style: pw.TextStyle(color: pdfOpacity(_white, 0.7), fontSize: 10)),
            ]),
            pw.SizedBox(height: 32),
            pw.Text('Дорожная карта развития',
                style: pw.TextStyle(color: pdfOpacity(_white, 0.8), fontSize: 13)),
            pw.SizedBox(height: 8),
            pw.Text(roadmap.companyName,
                style: pw.TextStyle(color: _white, fontSize: 26,
                    fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.Text('Создана: $dateStr',
                style: pw.TextStyle(color: pdfOpacity(_white, 0.7), fontSize: 11)),
            pw.SizedBox(height: 20),
            pw.Row(children: [
              _badge('$totalTasks задач'),
              pw.SizedBox(width: 10),
              _badge('12 месяцев'),
              pw.SizedBox(width: 10),
              _badge('$doneTasks выполнено'),
            ]),
          ]),
        ),

        pw.Expanded(child: pw.Container(
          color: _lightBg,
          padding: const pw.EdgeInsets.all(32),
          child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [

            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(18),
              decoration: pw.BoxDecoration(
                color: _white,
                borderRadius: pw.BorderRadius.circular(10),
                border: pw.Border.all(
                    color: pdfOpacity(_purple, 0.2), width: 0.5),
              ),
              child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                pw.Text('Резюме анализа',
                    style: pw.TextStyle(fontSize: 13,
                        fontWeight: pw.FontWeight.bold, color: _dark)),
                pw.SizedBox(height: 8),
                pw.Text(roadmap.executiveSummary,
                    style: const pw.TextStyle(fontSize: 11, color: _dark, lineSpacing: 3)),
              ]),
            ),

            pw.SizedBox(height: 24),

            pw.Text('Обзор по периодам',
                style: pw.TextStyle(fontSize: 14,
                    fontWeight: pw.FontWeight.bold, color: _dark)),
            pw.SizedBox(height: 12),

            pw.Row(children: TaskPeriod.values.map((p) {
              final tasks    = roadmap.byPeriod(p);
              final done     = tasks.where((t) => t.status == TaskStatus.done).length;
              final pColor   = _periodColor(p);
              final fraction = tasks.isEmpty ? 0.0 : (done / tasks.length).clamp(0.0, 1.0);

              return pw.Expanded(child: pw.Container(
                margin: pw.EdgeInsets.only(right: p.index < 2 ? 10 : 0),
                padding: const pw.EdgeInsets.all(14),
                decoration: pw.BoxDecoration(
                  color: _white,
                  borderRadius: pw.BorderRadius.circular(10),
                  border: pw.Border.all(color: pdfOpacity(pColor, 0.3), width: 0.5),
                ),
                child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                  pw.Text(_periodLabel(p),
                      style: pw.TextStyle(fontSize: 10, color: pColor,
                          fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 6),
                  pw.Text('${tasks.length} задач',
                      style: pw.TextStyle(fontSize: 18,
                          fontWeight: pw.FontWeight.bold, color: _dark)),
                  pw.SizedBox(height: 4),
                  pw.Text('$done выполнено',
                      style: pw.TextStyle(fontSize: 10, color: pColor)),
                  pw.SizedBox(height: 8),

                  pw.Stack(children: [
                    pw.Container(
                      height: 4,
                      decoration: pw.BoxDecoration(
                        color: pdfOpacity(pColor, 0.15),
                        borderRadius: pw.BorderRadius.circular(2),
                      ),
                    ),
                    pw.Container(
                      height: 4,
                      width: fraction * 120, 
                      decoration: pw.BoxDecoration(
                        color: pColor,
                        borderRadius: pw.BorderRadius.circular(2),
                      ),
                    ),
                  ]),
                ]),
              ));
            }).toList()),
          ]),
        )),
      ]),
    ));

    for (final period in TaskPeriod.values) {
      final tasks = roadmap.byPeriod(period);
      if (tasks.isEmpty) continue;

      final pColor = _periodColor(period);

      doc.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(32, 32, 32, 32),
        header: (ctx) => pw.Container(
          margin: const pw.EdgeInsets.only(bottom: 16),
          padding: const pw.EdgeInsets.only(bottom: 12),
          decoration: const pw.BoxDecoration(
            border: pw.Border(bottom: pw.BorderSide(
                color: PdfColors.grey300, width: 0.5)),
          ),
          child: pw.Row(children: [
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: pw.BoxDecoration(
                  color: pColor, borderRadius: pw.BorderRadius.circular(20)),
              child: pw.Text(_periodLabel(period),
                  style: pw.TextStyle(color: _white, fontSize: 10,
                      fontWeight: pw.FontWeight.bold)),
            ),
            pw.SizedBox(width: 12),
            pw.Text(roadmap.companyName,
                style: const pw.TextStyle(fontSize: 10, color: _grey)),
            pw.Spacer(),
            pw.Text('${tasks.length} задач',
                style: const pw.TextStyle(fontSize: 10, color: _grey)),
          ]),
        ),
        footer: (ctx) => pw.Container(
          margin: const pw.EdgeInsets.only(top: 10),
          padding: const pw.EdgeInsets.only(top: 8),
          decoration: const pw.BoxDecoration(
            border: pw.Border(top: pw.BorderSide(
                color: PdfColors.grey300, width: 0.5)),
          ),
          child: pw.Row(children: [
            pw.Text('Бизнес-навигатор · Дорожная карта',
                style: const pw.TextStyle(fontSize: 8, color: _grey)),
            pw.Spacer(),
            pw.Text('Стр. ${ctx.pageNumber}',
                style: const pw.TextStyle(fontSize: 8, color: _grey)),
          ]),
        ),
        build: (ctx) => tasks.map((task) {
          final catColor = _categoryColor(task.category);
          final sColor   = _statusColor(task.status);
          final isDone   = task.status == TaskStatus.done;

          return pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 14),
            decoration: pw.BoxDecoration(
              color: isDone ? pdfOpacity(_teal, 0.05) : _white,
              borderRadius: pw.BorderRadius.circular(10),
              border: pw.Border.all(
                color: isDone
                    ? pdfOpacity(_teal, 0.3)
                    : PdfColors.grey300,
                width: 0.5,
              ),
            ),
            child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [

              pw.Container(height: 3,
                  decoration: pw.BoxDecoration(
                    color: catColor,
                    borderRadius: const pw.BorderRadius.only(
                      topLeft: pw.Radius.circular(10),
                      topRight: pw.Radius.circular(10),
                    ),
                  )),
              pw.Padding(
                padding: const pw.EdgeInsets.all(14),
                child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                  pw.Row(children: [
                    _smallBadge(task.category.label, catColor),
                    pw.SizedBox(width: 6),
                    _smallBadge(_statusLabel(task.status), sColor),
                    pw.Spacer(),
                    pw.Text('Приоритет: ${task.priority}',
                        style: const pw.TextStyle(fontSize: 9, color: _grey)),
                  ]),
                  pw.SizedBox(height: 8),
                  pw.Text(task.title,
                      style: pw.TextStyle(fontSize: 13,
                          fontWeight: pw.FontWeight.bold,
                          color: isDone ? _grey : _dark)),
                  if (task.description.isNotEmpty) ...[
                    pw.SizedBox(height: 6),
                    pw.Text(task.description,
                        style: const pw.TextStyle(fontSize: 10, color: _grey,
                            lineSpacing: 3)),
                  ],
                  if (task.result.isNotEmpty) ...[
                    pw.SizedBox(height: 10),
                    pw.Container(
                      padding: const pw.EdgeInsets.all(10),
                      decoration: pw.BoxDecoration(
                        color: pdfOpacity(_teal, 0.07),
                        borderRadius: pw.BorderRadius.circular(6),
                        border: pw.Border.all(
                            color: pdfOpacity(_teal, 0.2), width: 0.5),
                      ),
                      child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('► ',
                                style: const pw.TextStyle(fontSize: 9, color: _teal)),
                            pw.Expanded(child: pw.Text(task.result,
                                style: const pw.TextStyle(fontSize: 10,
                                    color: _teal, lineSpacing: 3))),
                          ]),
                    ),
                  ],
                ]),
              ),
            ]),
          );
        }).toList(),
      ));
    }

    await Printing.layoutPdf(
      onLayout: (_) async => doc.save(),
      name: 'Дорожная_карта_${roadmap.companyName.replaceAll(' ', '_')}.pdf',
    );
  }

  static pw.Widget _badge(String text) => pw.Container(
    padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: pw.BoxDecoration(
      color: pdfOpacity(_white, 0.15),
      borderRadius: pw.BorderRadius.circular(20),
    ),
    child: pw.Text(text,
        style: pw.TextStyle(color: _white, fontSize: 10,
            fontWeight: pw.FontWeight.bold)),
  );

  static pw.Widget _smallBadge(String text, PdfColor color) => pw.Container(
    padding: const pw.EdgeInsets.symmetric(horizontal: 7, vertical: 3),
    decoration: pw.BoxDecoration(
      color: pdfOpacity(color, 0.1),
      borderRadius: pw.BorderRadius.circular(5),
    ),
    child: pw.Text(text,
        style: pw.TextStyle(fontSize: 9, color: color,
            fontWeight: pw.FontWeight.bold)),
  );
}