import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/simulation_result.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';

class EvolutionChart extends StatelessWidget {
  final SimulationResult result;

  const EvolutionChart({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final yearlyData = result.yearlyResults;

    if (yearlyData.isEmpty) {
      return const Center(child: Text('Sem dados para exibir'));
    }

    final maxY = yearlyData.map((e) => e.totalValue).reduce((a, b) => a > b ? a : b);
    const minY = 0.0;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY / 5,
          getDrawingHorizontalLine: (value) {
            return const FlLine(
              color: AppColors.gridLine,
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: _calculateInterval(yearlyData.length),
              getTitlesWidget: (value, meta) {
                final year = value.toInt();
                if (year >= 0 && year <= yearlyData.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Ano $year',
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 55,
              interval: maxY / 5,
              getTitlesWidget: (value, meta) {
                return Text(
                  Formatters.currencyCompact(value),
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: yearlyData.length.toDouble(),
        minY: minY,
        maxY: maxY * 1.1,
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => Colors.blueGrey.shade800,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final isTotal = spot.barIndex == 0;
                return LineTooltipItem(
                  '${isTotal ? 'Total' : 'Investido'}: ${Formatters.currency(spot.y)}',
                  const TextStyle(color: Colors.white, fontSize: 12),
                );
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          // Linha de valor total
          LineChartBarData(
            spots: [
              FlSpot(0, result.initialInvestment),
              ...yearlyData.asMap().entries.map(
                    (e) => FlSpot(e.key + 1, e.value.totalValue),
                  ),
            ],
            isCurved: true,
            color: AppColors.chartLine,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.chartLine.withAlpha(25),
            ),
          ),
          // Linha de valor investido
          LineChartBarData(
            spots: [
              FlSpot(0, result.initialInvestment),
              ...yearlyData.asMap().entries.map(
                    (e) => FlSpot(e.key + 1, e.value.investedAmount),
                  ),
            ],
            isCurved: false,
            color: AppColors.chartInvested,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            dashArray: [5, 5],
          ),
        ],
      ),
    );
  }

  double _calculateInterval(int years) {
    if (years <= 5) return 1;
    if (years <= 15) return 2;
    if (years <= 30) return 5;
    return 10;
  }
}

