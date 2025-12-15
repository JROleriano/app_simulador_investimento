import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/investment_provider.dart';
import '../utils/formatters.dart';
import '../utils/constants.dart';
import '../widgets/evolution_chart.dart';
import '../widgets/allocation_pie_chart.dart';
import '../widgets/asset_breakdown_table.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.results),
        centerTitle: true,
      ),
      body: Consumer<InvestmentProvider>(
        builder: (context, provider, _) {
          final result = provider.result;
          if (result == null) {
            return const Center(
              child: Text('Nenhuma simulação realizada'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSummaryCard(context, result),
                const SizedBox(height: 16),
                _buildEvolutionCard(context, result),
                const SizedBox(height: 16),
                _buildAllocationCard(context, result),
                const SizedBox(height: 16),
                _buildBreakdownCard(context, result),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, result) {
    return Card(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Valor Final Estimado',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white70,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              Formatters.currency(result.finalValue),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSummaryItem(
                  context,
                  AppStrings.totalInvested,
                  Formatters.currency(result.totalInvested),
                ),
                _buildSummaryItem(
                  context,
                  AppStrings.totalGains,
                  Formatters.currency(result.totalGains),
                ),
                _buildSummaryItem(
                  context,
                  AppStrings.totalReturn,
                  '${result.totalReturn.toStringAsFixed(1)}%',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildEvolutionCard(BuildContext context, result) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.show_chart, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  AppStrings.evolution,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: EvolutionChart(result: result),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllocationCard(BuildContext context, result) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.pie_chart, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Distribuição Final',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: AllocationPieChart(result: result),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakdownCard(BuildContext context, result) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.list_alt, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  AppStrings.breakdown,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AssetBreakdownTable(result: result),
          ],
        ),
      ),
    );
  }
}

