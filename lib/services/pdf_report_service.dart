import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/user_model.dart';
import 'student_report_service.dart';

class PdfReportService {
  Future<Uint8List> buildPdf(StudentReportData report) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(report),
              pw.SizedBox(height: 15),
              _buildSummaryCard(report),
              pw.SizedBox(height: 20),

              pw.Text('EVOLUCIÓN DIARIA', style: sectionTitleStyle),
              pw.SizedBox(height: 10),
              _buildDailyChart(report.daily),
              pw.SizedBox(height: 20),

              pw.Text('DETALLE DE RESULTADOS POR JUEGO', style: sectionTitleStyle),
              pw.SizedBox(height: 8),
              _buildGamesTable(report),
              pw.SizedBox(height: 25),

              _buildPedagogicalBox(report),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildHeader(StudentReportData report) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Columna izquierda: Título y Nombre del Alumno
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('INFORME DE PROGRESO', style: titleStyle),
            pw.Text(
                'Alumno: ${report.student.name ?? 'Alumno'}',
                style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)
            ),
          ],
        ),
        // Columna derecha: Fechas de periodo y generación
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text('Periodo: ${_formatPeriod(report.start, report.end)}', style: mutedTextStyle),
            pw.Text('Generado: ${_formatDate(DateTime.now())}', style: mutedTextStyle),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildSummaryCard(StudentReportData report) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(color: PdfColors.blue50, borderRadius: pw.BorderRadius.circular(8)),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          _statItem('Sesiones', '${report.totalSessions}'),
          _statItem('Días Activos', '${report.activeDays}'),
          _statItem('Éxito Global', '${report.successRate.toStringAsFixed(0)}%'),
        ],
      ),
    );
  }

  pw.Widget _statItem(String label, String value) {
    return pw.Column(children: [
      pw.Text(label, style: mutedTextStyle),
      pw.Text(value, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
    ]);
  }

  pw.Widget _buildDailyChart(List<DailyAgg> dailyData) {
    return pw.Column(
      children: dailyData.map((day) {
        final total = day.hits + day.fails;
        final double hitW = total == 0 ? 0 : (day.hits / total);
        return pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 2),
          child: pw.Row(
            children: [
              pw.SizedBox(width: 65, child: pw.Text(_formatDate(day.day), style: mutedTextStyle)),
              pw.Expanded(
                child: pw.Container(
                  height: 10,
                  decoration: pw.BoxDecoration(color: PdfColors.grey200, borderRadius: pw.BorderRadius.circular(2)),
                  child: pw.Row(children: [
                    if (hitW > 0) pw.Expanded(flex: (hitW * 100).toInt(), child: pw.Container(color: PdfColors.green)),
                    if ((1 - hitW) > 0) pw.Expanded(flex: ((1 - hitW) * 100).toInt(), child: pw.Container(color: PdfColors.red)),
                  ]),
                ),
              ),
              pw.SizedBox(width: 45, child: pw.Text('${day.hits}/${total}', style: mutedTextStyle, textAlign: pw.TextAlign.right)),
            ],
          ),
        );
      }).toList(),
    );
  }

  pw.Widget _buildGamesTable(StudentReportData report) {
    final rows = <pw.TableRow>[
      pw.TableRow(
        decoration: const pw.BoxDecoration(color: PdfColors.grey300),
        children: [
          _cell('Juego', bold: true),
          _cell('Aciertos', bold: true),
          _cell('Errores', bold: true),
          _cell('% Éxito', bold: true),
          _cell('Acción Recomendada', bold: true),
        ],
      ),
    ];

    report.byGame.forEach((gameType, agg) {
      final total = agg.hits + agg.fails;
      final double rate = total == 0 ? 0.0 : (agg.hits / total) * 100.0;
      rows.add(pw.TableRow(
        children: [
          _cell(StudentReportService.gameNames[gameType] ?? 'Juego $gameType'),
          _cell('${agg.hits}'),
          _cell('${agg.fails}'),
          _cell('${rate.toStringAsFixed(0)}%'),
          _cell(_getGameRec(rate, total), color: _getCol(rate)),
        ],
      ));
    });

    return pw.Table(border: pw.TableBorder.all(color: PdfColors.grey400), children: rows);
  }

  // Lógica mejorada para la acción recomendada
  String _getGameRec(double rate, int total) {
    if (rate >= 95) return 'Subir nivel'; // Priorizamos el éxito total
    if (total < 3) return 'Continuar práctica';
    if (rate >= 70) return 'Mantener nivel';
    return 'Reforzar apoyo';
  }

  PdfColor _getCol(double rate) {
    if (rate >= 95) return PdfColors.blue700;
    if (rate >= 70) return PdfColors.green700;
    return PdfColors.red700;
  }

  pw.Widget _buildPedagogicalBox(StudentReportData report) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: PdfColors.grey300),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('RECOMENDACIONES PEDAGÓGICAS', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
          pw.SizedBox(height: 6),
          pw.Text(_generateRecommendations(report), style: pw.TextStyle(fontSize: 9)),
        ],
      ),
    );
  }

  String _generateRecommendations(StudentReportData report) {
    List<String> toReinforce = [];
    report.byGame.forEach((tipo, agg) {
      final total = agg.hits + agg.fails;
      if (total > 0 && (agg.hits / total) < 0.6) {
        toReinforce.add(StudentReportService.gameNames[tipo] ?? 'Juego $tipo');
      }
    });

    if (toReinforce.isEmpty) return 'El alumno muestra un rendimiento sólido. Se recomienda seguir con la planificación actual y fomentar la autonomía.';
    return 'Se recomienda trabajar especialmente en: ${toReinforce.join(", ")}. Es aconsejable utilizar apoyos visuales y mediación verbal durante estas actividades.';
  }

  pw.Widget _cell(String text, {bool bold = false, PdfColor? color}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(text, style: pw.TextStyle(fontSize: 9, fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal, color: color)),
    );
  }
}

final titleStyle = pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900);
final sectionTitleStyle = pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey800);
final mutedTextStyle = pw.TextStyle(fontSize: 8, color: PdfColors.grey700);
String _formatDate(DateTime? d) => d == null ? '-' : '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
String _formatPeriod(DateTime s, DateTime e) => '${_formatDate(s)} - ${_formatDate(e)}';