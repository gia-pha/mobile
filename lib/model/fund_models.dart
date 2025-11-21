import 'package:flutter/material.dart';
import 'dart:math';

enum TransactionType { income, outcome }

class FundTransaction {
  final TransactionType type;
  final String whoOrReason;
  final double amount;
  final DateTime date;

  FundTransaction({
    required this.type,
    required this.whoOrReason,
    required this.amount,
    required this.date,
  });
}

class Fund {
  final String id;
  final String name;
  final List<FundTransaction> transactions;

  Fund({
    required this.id,
    required this.name,
    List<FundTransaction>? transactions,
  }) : transactions = transactions ?? [];

  double get totalIncome => transactions
      .where((t) => t.type == TransactionType.income)
      .fold(0.0, (s, t) => s + t.amount);

  double get totalOutcome => transactions
      .where((t) => t.type == TransactionType.outcome)
      .fold(0.0, (s, t) => s + t.amount);

  double get currentBalance => totalIncome - totalOutcome;

  /// Returns a list of balances for the past [months] months (oldest -> newest).
  List<double> monthlyBalances({int months = 12}) {
    final now = DateTime.now();
    // initialize balances per month index 0..months-1
    final balances = List<double>.filled(months, 0.0);
    // compute cumulative starting from oldest month -> newest
    // We'll compute monthly net change (income - outcome) and then cumulative sum.
    final monthlyNet = List<double>.filled(months, 0.0);

    for (var tx in transactions) {
      final monthsAgo = (now.year - tx.date.year) * 12 + (now.month - tx.date.month);
      if (monthsAgo >= 0 && monthsAgo < months) {
        final idx = months - 1 - monthsAgo; // index oldest->newest
        monthlyNet[idx] += (tx.type == TransactionType.income) ? tx.amount : -tx.amount;
      }
    }

    double cumulative = 0.0;
    for (var i = 0; i < months; i++) {
      cumulative += monthlyNet[i];
      balances[i] = cumulative;
    }

    return balances;
  }

  /// New: returns detailed monthly summaries (oldest -> newest)
  List<MonthlyData> monthlySummaries({int months = 12}) {
    final now = DateTime.now();
    final incomes = List<double>.filled(months, 0.0);
    final outcomes = List<double>.filled(months, 0.0);
    final txsPerMonth = List<List<FundTransaction>>.generate(months, (_) => []);

    for (var tx in transactions) {
      final monthsAgo = (now.year - tx.date.year) * 12 + (now.month - tx.date.month);
      if (monthsAgo >= 0 && monthsAgo < months) {
        final idx = months - 1 - monthsAgo; // oldest->newest
        if (tx.type == TransactionType.income) incomes[idx] += tx.amount;
        else outcomes[idx] += tx.amount;
        txsPerMonth[idx].add(tx);
      }
    }

    final summaries = <MonthlyData>[];
    double cumulative = 0.0;
    for (var i = 0; i < months; i++) {
      cumulative += incomes[i] - outcomes[i];
      // compute the month DateTime for labeling if needed
      final monthDate = DateTime(now.year, now.month - (months - 1 - i), 1);
      summaries.add(MonthlyData(
        month: monthDate,
        income: incomes[i],
        outcome: outcomes[i],
        balance: cumulative,
        transactions: List.unmodifiable(txsPerMonth[i]),
      ));
    }

    return summaries;
  }
}

// New helper class representing a month summary
class MonthlyData {
  final DateTime month;
  final double income;
  final double outcome;
  final double balance;
  final List<FundTransaction> transactions;
  MonthlyData({
    required this.month,
    required this.income,
    required this.outcome,
    required this.balance,
    this.transactions = const [],
  });
}

/// Simple sparkline painter used by the UI. Scales the values to the widget size.
class Sparkline extends StatelessWidget {
  final List<double> values;
  final Color lineColor;
  final double strokeWidth;
  final Color? fillColor;

  const Sparkline({
    Key? key,
    required this.values,
    this.lineColor = Colors.blue,
    this.strokeWidth = 2.0,
    this.fillColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _SparklinePainter(values, lineColor, strokeWidth, fillColor),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> values;
  final Color lineColor;
  final double strokeWidth;
  final Color? fillColor;

  _SparklinePainter(this.values, this.lineColor, this.strokeWidth, this.fillColor);

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty || size.width <= 0 || size.height <= 0) return;
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    double minV = values.reduce(min);
    double maxV = values.reduce(max);
    if (minV == maxV) {
      // produce a flat line in the middle
      final y = size.height / 2;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
      return;
    }

    final path = Path();
    for (int i = 0; i < values.length; i++) {
      final t = values[i];
      final dx = (i / (values.length - 1)) * size.width;
      final dy = size.height - ((t - minV) / (maxV - minV) * size.height);
      if (i == 0) path.moveTo(dx, dy);
      else path.lineTo(dx, dy);
    }

    if (fillColor != null) {
      final fillPaint = Paint()
        ..color = fillColor!.withOpacity(0.15)
        ..style = PaintingStyle.fill;
      final fillPath = Path.from(path)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();
      canvas.drawPath(fillPath, fillPaint);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.lineColor != lineColor;
  }
}

// New: Monthly chart that draws income/outcome bars per month and overlays balance line.
class MonthlyChart extends StatelessWidget {
  final List<MonthlyData> data;
  final double strokeWidth;
  final void Function(MonthlyData month)? onMonthTap;

  const MonthlyChart({
    Key? key,
    required this.data,
    this.strokeWidth = 2.0,
    this.onMonthTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (details) {
        if (onMonthTap == null || data.isEmpty) return;
        final box = context.findRenderObject() as RenderBox?;
        if (box == null) return;
        final local = box.globalToLocal(details.globalPosition);
        final monthCount = data.length;
        final idx = (local.dx / box.size.width * monthCount).floor().clamp(0, monthCount - 1);
        onMonthTap!(data[idx]);
      },
      child: CustomPaint(
        size: Size.infinite,
        painter: _MonthlyChartPainter(data, strokeWidth),
      ),
    );
  }
}

class _MonthlyChartPainter extends CustomPainter {
  final List<MonthlyData> data;
  final double strokeWidth;
  _MonthlyChartPainter(this.data, this.strokeWidth);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty || size.width <= 0 || size.height <= 0) return;

    // compute scales
    double maxIncome = 0.0, maxOutcome = 0.0;
    double minBalance = double.infinity, maxBalance = double.negativeInfinity;
    for (var d in data) {
      if (d.income > maxIncome) maxIncome = d.income;
      if (d.outcome > maxOutcome) maxOutcome = d.outcome;
      if (d.balance < minBalance) minBalance = d.balance;
      if (d.balance > maxBalance) maxBalance = d.balance;
    }
    if (minBalance == double.infinity) {
      minBalance = 0.0;
      maxBalance = 0.0;
    }

    final maxBar = max(maxIncome, maxOutcome);
    final barMax = maxBar > 0 ? maxBar : 1.0;
    final balanceRange = (maxBalance - minBalance) != 0 ? (maxBalance - minBalance) : 1.0;

    final monthCount = data.length;
    final monthW = size.width / monthCount;
    final barW = min(12.0, monthW * 0.3);

    // Draw month boundaries and labels
    final borderPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1.0;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i <= monthCount; i++) {
      final x = i * monthW;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), borderPaint);

      if (i < monthCount) {
        final monthLabel = _formatMonthLabel(data[i].month);
        textPainter.text = TextSpan(
          text: monthLabel,
          style: const TextStyle(color: Colors.grey, fontSize: 9),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x + 2, size.height - 12),
        );
      }
    }

    // Reserve space for month labels
    final chartHeight = size.height - 14;

    // draw bars (income left, outcome right) bottom aligned
    final incomePaint = Paint()..color = Colors.green.withOpacity(0.9);
    final outcomePaint = Paint()..color = Colors.amber.withOpacity(0.9);

    for (int i = 0; i < monthCount; i++) {
      final d = data[i];
      final cx = i * monthW + monthW / 2;
      final incomeH = (d.income / barMax) * chartHeight;
      final outcomeH = (d.outcome / barMax) * chartHeight;
      final incomeRect = Rect.fromLTWH(cx - barW - 2, chartHeight - incomeH, barW, incomeH);
      final outcomeRect = Rect.fromLTWH(cx + 2, chartHeight - outcomeH, barW, outcomeH);
      if (incomeH > 0.0) canvas.drawRRect(RRect.fromRectAndRadius(incomeRect, Radius.circular(3)), incomePaint);
      if (outcomeH > 0.0) canvas.drawRRect(RRect.fromRectAndRadius(outcomeRect, Radius.circular(3)), outcomePaint);
    }

    // draw balance line (map balance to vertical)
    final balancePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..isAntiAlias = true;

    final path = Path();
    for (int i = 0; i < monthCount; i++) {
      final d = data[i];
      final x = i * monthW + monthW / 2;
      final normalized = (d.balance - minBalance) / balanceRange;
      final y = chartHeight - (normalized * chartHeight);
      if (i == 0) path.moveTo(x, y);
      else path.lineTo(x, y);
    }
    canvas.drawPath(path, balancePaint);
  }

  String _formatMonthLabel(DateTime date) {
    const months = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];
    return months[date.month - 1];
  }

  @override
  bool shouldRepaint(covariant _MonthlyChartPainter oldDelegate) {
    if (oldDelegate.data.length != data.length) return true;
    for (int i = 0; i < data.length; i++) {
      final a = oldDelegate.data[i], b = data[i];
      if (a.income != b.income || a.outcome != b.outcome || a.balance != b.balance) return true;
    }
    return false;
  }
}