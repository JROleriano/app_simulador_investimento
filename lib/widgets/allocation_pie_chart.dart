import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/simulation_result.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';

class AllocationPieChart extends StatefulWidget {
  final SimulationResult result;

  const AllocationPieChart({super.key, required this.result});

  @override
  State<AllocationPieChart> createState() => _AllocationPieChartState();
}

class _AllocationPieChartState extends State<AllocationPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final lastPeriod = widget.result.yearlyResults.isNotEmpty
        ? widget.result.yearlyResults.last
        : null;

    if (lastPeriod == null) {
      return const Center(child: Text('Sem dados'));
    }

    final categoryData = lastPeriod.valueByCategory;
    final total = categoryData.values.fold<double>(0, (a, b) => a + b);

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: _buildSections(categoryData, total),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildLegend(categoryData, total),
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _buildSections(
    Map<String, double> data,
    double total,
  ) {
    final colors = {
      'Tesouro': AppColors.tesouro,
      'ETFs': AppColors.etfs,
      'FIIs': AppColors.fiis,
    };

    final entries = data.entries.toList();

    return entries.asMap().entries.map((entry) {
      final index = entry.key;
      final category = entry.value.key;
      final value = entry.value.value;
      final percent = (value / total) * 100;
      final isTouched = index == touchedIndex;
      final radius = isTouched ? 60.0 : 50.0;

      return PieChartSectionData(
        color: colors[category] ?? Colors.grey,
        value: value,
        title: '${percent.toStringAsFixed(0)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: isTouched ? 14 : 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  List<Widget> _buildLegend(Map<String, double> data, double total) {
    final colors = {
      'Tesouro': AppColors.tesouro,
      'ETFs': AppColors.etfs,
      'FIIs': AppColors.fiis,
    };

    return data.entries.map((entry) {
      final color = colors[entry.key] ?? Colors.grey;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.key,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    Formatters.currencyCompact(entry.value),
                    style: const TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}

