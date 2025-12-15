import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/simulation_result.dart';
import '../providers/investment_provider.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';

class AssetBreakdownTable extends StatelessWidget {
  final SimulationResult result;

  const AssetBreakdownTable({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final lastPeriod = result.yearlyResults.isNotEmpty
        ? result.yearlyResults.last
        : null;

    if (lastPeriod == null) {
      return const Center(child: Text('Sem dados'));
    }

    final investments = context.read<InvestmentProvider>().investments;
    final total = lastPeriod.totalValue;

    // Agrupa por categoria
    final categories = <String, List<_AssetData>>{};
    for (final inv in investments) {
      final value = lastPeriod.valueByAsset[inv.ticker] ?? 0;
      final initialValue = result.initialInvestment * inv.allocation;
      final contributions = result.monthlyContribution * inv.allocation * (result.years * 12);
      final invested = initialValue + contributions;

      categories.putIfAbsent(inv.category, () => []).add(_AssetData(
        ticker: inv.ticker,
        name: inv.name,
        value: value,
        allocation: value / total,
        invested: invested,
        gain: value - invested,
        expectedReturn: inv.annualReturn,
      ));
    }

    final categoryColors = {
      'Tesouro': AppColors.tesouro,
      'ETFs': AppColors.etfs,
      'FIIs': AppColors.fiis,
    };

    return Column(
      children: categories.entries.map((categoryEntry) {
        final categoryName = categoryEntry.key;
        final assets = categoryEntry.value;
        final categoryTotal = assets.fold<double>(0, (sum, a) => sum + a.value);
        final categoryColor = categoryColors[categoryName] ?? Colors.grey;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho da categoria
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: categoryColor.withAlpha(25),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 24,
                    decoration: BoxDecoration(
                      color: categoryColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      categoryName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: categoryColor,
                      ),
                    ),
                  ),
                  Text(
                    Formatters.currency(categoryTotal),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: categoryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Lista de ativos
            ...assets.map((asset) => _buildAssetTile(context, asset)),
            const SizedBox(height: 16),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildAssetTile(BuildContext context, _AssetData asset) {
    final isPositive = asset.gain >= 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 8, left: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        asset.ticker,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        asset.name,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      Formatters.currency(asset.value),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '${(asset.allocation * 100).toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoChip('Investido', Formatters.currencyCompact(asset.invested)),
                _buildInfoChip(
                  'Ganho',
                  '${isPositive ? '+' : ''}${Formatters.currencyCompact(asset.gain)}',
                  color: isPositive ? Colors.green : Colors.red,
                ),
                _buildInfoChip(
                  'Retorno',
                  '${(asset.expectedReturn * 100).toStringAsFixed(1)}% a.a.',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, String value, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _AssetData {
  final String ticker;
  final String name;
  final double value;
  final double allocation;
  final double invested;
  final double gain;
  final double expectedReturn;

  _AssetData({
    required this.ticker,
    required this.name,
    required this.value,
    required this.allocation,
    required this.invested,
    required this.gain,
    required this.expectedReturn,
  });
}

