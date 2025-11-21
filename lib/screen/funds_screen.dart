import 'package:flutter/material.dart';
import '../model/fund_models.dart';
import 'fund_screen.dart';

class FundsScreen extends StatelessWidget {
  final List<Fund> funds;

  FundsScreen({Key? key, List<Fund>? funds})
      : funds = funds ?? _buildSampleFunds(),
        super(key: key);

  static List<Fund> _buildSampleFunds() {
    final now = DateTime.now();

    Fund f(String id, String name, List<FundTransaction> txs) =>
        Fund(id: id, name: name, transactions: txs);

    return [
      f('f1', 'Family Trip 2026', [
        FundTransaction(type: TransactionType.income, whoOrReason: 'Alice', amount: 500, date: now.subtract(Duration(days: 360))),
        FundTransaction(type: TransactionType.income, whoOrReason: 'Bob', amount: 300, date: now.subtract(Duration(days: 240))),
        FundTransaction(type: TransactionType.outcome, whoOrReason: 'Hotel booking', amount: 200, date: now.subtract(Duration(days: 30))),
        FundTransaction(type: TransactionType.income, whoOrReason: 'Charlie', amount: 150, date: now.subtract(Duration(days: 15))),
      ]),
      f('f2', 'Temple Repair', [
        FundTransaction(type: TransactionType.income, whoOrReason: 'Community', amount: 1500, date: now.subtract(Duration(days: 400))),
        FundTransaction(type: TransactionType.outcome, whoOrReason: 'Materials', amount: 400, date: now.subtract(Duration(days: 300))),
        FundTransaction(type: TransactionType.income, whoOrReason: 'Donation', amount: 250, date: now.subtract(Duration(days: 10))),
        FundTransaction(type: TransactionType.outcome, whoOrReason: 'Labor', amount: 200, date: now.subtract(Duration(days: 5))),
      ]),
      f('f3', 'Education Fund', [
        FundTransaction(type: TransactionType.income, whoOrReason: 'Grandma', amount: 1000, date: now.subtract(Duration(days: 700))),
        FundTransaction(type: TransactionType.income, whoOrReason: 'Scholarship', amount: 500, date: now.subtract(Duration(days: 200))),
        FundTransaction(type: TransactionType.outcome, whoOrReason: 'Tuition', amount: 800, date: now.subtract(Duration(days: 60))),
        FundTransaction(type: TransactionType.income, whoOrReason: 'Family', amount: 200, date: now.subtract(Duration(days: 20))),
      ]),
      f('f4', 'Emergency Reserve', [
        FundTransaction(type: TransactionType.income, whoOrReason: 'Monthly Save', amount: 100, date: now.subtract(Duration(days: 330))),
        FundTransaction(type: TransactionType.income, whoOrReason: 'Monthly Save', amount: 120, date: now.subtract(Duration(days: 300))),
        FundTransaction(type: TransactionType.income, whoOrReason: 'Monthly Save', amount: 130, date: now.subtract(Duration(days: 270))),
        FundTransaction(type: TransactionType.outcome, whoOrReason: 'Medical', amount: 250, date: now.subtract(Duration(days: 40))),
      ]),
      f('f5', 'Wedding Fund', [
        FundTransaction(type: TransactionType.income, whoOrReason: 'Parents', amount: 2000, date: now.subtract(Duration(days: 500))),
        FundTransaction(type: TransactionType.income, whoOrReason: 'Friends', amount: 600, date: now.subtract(Duration(days: 90))),
        FundTransaction(type: TransactionType.outcome, whoOrReason: 'Venue deposit', amount: 800, date: now.subtract(Duration(days: 25))),
      ]),
      f('f6', 'Ancestral Hall Maintenance', [
        FundTransaction(type: TransactionType.income, whoOrReason: 'Lineage Association', amount: 800, date: now.subtract(Duration(days: 420))),
        FundTransaction(type: TransactionType.outcome, whoOrReason: 'Roof repair', amount: 500, date: now.subtract(Duration(days: 350))),
        FundTransaction(type: TransactionType.income, whoOrReason: 'Donation', amount: 300, date: now.subtract(Duration(days: 60))),
      ]),
      f('f7', 'Health Support', [
        FundTransaction(type: TransactionType.income, whoOrReason: 'Charity', amount: 1200, date: now.subtract(Duration(days: 200))),
        FundTransaction(type: TransactionType.outcome, whoOrReason: 'Medication', amount: 150, date: now.subtract(Duration(days: 180))),
        FundTransaction(type: TransactionType.outcome, whoOrReason: 'Surgery', amount: 900, date: now.subtract(Duration(days: 20))),
        FundTransaction(type: TransactionType.income, whoOrReason: 'Well-wisher', amount: 400, date: now.subtract(Duration(days: 7))),
      ]),
      f('f8', 'Community Event', [
        FundTransaction(type: TransactionType.income, whoOrReason: 'Sponsors', amount: 750, date: now.subtract(Duration(days: 120))),
        FundTransaction(type: TransactionType.income, whoOrReason: 'Ticket Sales', amount: 320, date: now.subtract(Duration(days: 45))),
        FundTransaction(type: TransactionType.outcome, whoOrReason: 'Catering', amount: 500, date: now.subtract(Duration(days: 10))),
      ]),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Funds'),
      // ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: funds.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final fund = funds[index];
          final summaries = fund.monthlySummaries(months: 6);
           return Card(
             child: InkWell(
               onTap: () {
                 Navigator.of(context).push(MaterialPageRoute(
                   builder: (_) => FundScreen(fund: fund),
                 ));
               },
               child: Padding(
                 padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                 child: Row(
                   children: [
                     Expanded(
                       flex: 3,
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text(fund.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                           const SizedBox(height: 6),
                           Text('Balance: ${_formatCurrency(fund.currentBalance)}', style: const TextStyle(fontSize: 14)),
                         ],
                       ),
                     ),
                     Expanded(
                       flex: 2,
                       child: SizedBox(
                         height: 48,
                         child: ClipRRect(
                           borderRadius: BorderRadius.circular(6),
                           child: Container(
                             color: Colors.grey.shade50,
                             child: Padding(
                               padding: const EdgeInsets.symmetric(horizontal: 8.0),
                               child: _miniTrend(summaries),
                             ),
                           ),
                         ),
                       ),
                     ),
                     const SizedBox(width: 8),
                     const Icon(Icons.chevron_right),
                   ],
                 ),
               ),
             ),
           );
         },
       ),
     );
   }

  static String _formatCurrency(double v) {
    final sign = v < 0 ? '-' : '';
    final absV = v.abs();
    return '$sign\$${absV.toStringAsFixed(2)}';
  }

  Widget _miniTrend(List<MonthlyData> summaries) {
    if (summaries.isEmpty) {
      return Center(child: Text('No data', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)));
    }
    final empty = summaries.every((s) => s.income == 0.0 && s.outcome == 0.0 && s.balance == 0.0);
    if (empty) {
      return Center(child: Text('No data', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)));
    }

    final len = summaries.length;
    final last = summaries[len - 1];
    final prev = len >= 2 ? summaries[len - 2] : null;
    final prevBal = prev?.balance ?? 0.0;
    final lastBal = last.balance;
    final pct = (prevBal != 0.0) ? ((lastBal - prevBal) / prevBal) * 100.0 : 0.0;
    final up = pct >= 0.0;
    final icon = up ? Icons.arrow_upward : Icons.arrow_downward;
    final color = up ? Colors.green : Colors.red;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 6),
            Text(
              '${up ? '+' : ''}${pct.toStringAsFixed(0)}%',
              style: TextStyle(color: color, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(_formatCurrency(lastBal), style: const TextStyle(fontWeight: FontWeight.w700)),
            Text(
              '+${last.income.toStringAsFixed(0)} / -${last.outcome.toStringAsFixed(0)}',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
          ],
        ),
      ],
    );
  }
}