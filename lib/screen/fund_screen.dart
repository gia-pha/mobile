import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/fund_models.dart';

class FundScreen extends StatelessWidget {
  final Fund fund;

  const FundScreen({Key? key, required this.fund}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final summaries = fund.monthlySummaries(months: 12);
    return Scaffold(
      appBar: AppBar(
        title: Text(fund.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () => _exportCsv(context),
            tooltip: 'Export CSV',
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareFund(context),
            tooltip: 'Share summary',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _buildSummaryCard(),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                height: 160,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Account volatility (last 12 months)', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        child: summaries.every((s) => s.income == 0.0 && s.outcome == 0.0 && s.balance == 0.0)
                            ? Center(child: Text('No monthly data', style: TextStyle(color: Colors.grey.shade600)))
                            : MonthlyChart(
                                data: summaries,
                                strokeWidth: 2.0,
                                onMonthTap: (m) {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (_) {
                                      final txs = m.transactions;
                                      if (txs.isEmpty) {
                                        return Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Center(child: Text('No transactions this month')),
                                        );
                                      }
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text(
                                              '${m.month.year}-${m.month.month.toString().padLeft(2, '0')} — Transactions',
                                              style: const TextStyle(fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Flexible(
                                            child: ListView.separated(
                                              shrinkWrap: true,
                                              itemCount: txs.length,
                                              separatorBuilder: (_, __) => const Divider(height: 1),
                                              itemBuilder: (_, i) {
                                                final tx = txs[i];
                                                return ListTile(
                                                  title: Text(tx.whoOrReason),
                                                  subtitle: Text(tx.date.toLocal().toIso8601String().split('T').first),
                                                  trailing: Text(
                                                    '${tx.type == TransactionType.income ? '+' : '-'}\$${tx.amount.toStringAsFixed(2)}',
                                                    style: TextStyle(
                                                      color: tx.type == TransactionType.income ? Colors.green.shade700 : Colors.red.shade700,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text('Transactions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Card(
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: fund.transactions.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final tx = fund.transactions.reversed.toList()[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: tx.type == TransactionType.income ? Colors.green.shade50 : Colors.amber.shade50,
                    child: Icon(
                      tx.type == TransactionType.income ? Icons.arrow_upward : Icons.arrow_downward,
                      color: tx.type == TransactionType.income ? Colors.green : Colors.amber,
                    ),
                  ),
                  title: Text(tx.whoOrReason),
                  subtitle: Text(_formatDate(tx.date)),
                  trailing: Text(
                    '${tx.type == TransactionType.income ? '+' : '-'}\$${tx.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: tx.type == TransactionType.income ? Colors.green.shade700 : Colors.amber.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        child: Row(
          children: [
            Expanded(
              child: _statColumn('Balance', _formatCurrency(fund.currentBalance), Colors.blue),
            ),
            Expanded(
              child: _statColumn('Total Income', _formatCurrency(fund.totalIncome), Colors.green),
            ),
            Expanded(
              child: _statColumn('Total Outcome', _formatCurrency(fund.totalOutcome), Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statColumn(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 6),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: color)),
      ],
    );
  }

  static String _formatCurrency(double v) {
    final sign = v < 0 ? '-' : '';
    final absV = v.abs();
    return '$sign\$${absV.toStringAsFixed(2)}';
  }

  static String _formatDate(DateTime d) {
    final dt = d.toLocal();
    final y = dt.year.toString();
    final m = dt.month.toString().padLeft(2, '0');
    final day = dt.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  void _exportCsv(BuildContext context) {
    final rows = <String>['date,type,who_or_reason,amount'];
    for (var tx in fund.transactions) {
      final date = tx.date.toIso8601String();
      final type = tx.type == TransactionType.income ? 'income' : 'outcome';
      final who = tx.whoOrReason.replaceAll(',', ' ');
      rows.add('$date,$type,$who,${tx.amount.toStringAsFixed(2)}');
    }
    final csv = rows.join('\n');
    Clipboard.setData(ClipboardData(text: csv));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('CSV copied to clipboard')));
  }

  void _shareFund(BuildContext context) {
    final summary = 'Fund ${fund.name}\nBalance: ${_formatCurrency(fund.currentBalance)}\nTotal Income: ${_formatCurrency(fund.totalIncome)}\nTotal Outcome: ${_formatCurrency(fund.totalOutcome)}';
    Clipboard.setData(ClipboardData(text: summary));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Summary copied to clipboard')));
  }
}