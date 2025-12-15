import 'dart:math' show pow;
import 'package:flutter/material.dart';
import '../models/investment.dart';
import '../models/portfolio.dart';
import '../models/simulation_result.dart';

class InvestmentProvider extends ChangeNotifier {
  double _initialInvestment = 10000;
  double _monthlyContribution = 1000;
  int _years = 10;
  SimulationResult? _result;
  bool _isLoading = false;

  // Getters
  double get initialInvestment => _initialInvestment;
  double get monthlyContribution => _monthlyContribution;
  int get years => _years;
  SimulationResult? get result => _result;
  bool get isLoading => _isLoading;
  List<Investment> get investments => Portfolio.defaultInvestments;

  // Setters
  void setInitialInvestment(double value) {
    _initialInvestment = value;
    notifyListeners();
  }

  void setMonthlyContribution(double value) {
    _monthlyContribution = value;
    notifyListeners();
  }

  void setYears(int value) {
    _years = value;
    notifyListeners();
  }

  /// Executa a simulação de investimentos
  Future<void> simulate() async {
    _isLoading = true;
    notifyListeners();

    // Simula um pequeno delay para UX
    await Future.delayed(const Duration(milliseconds: 300));

    final monthlyResults = <SimulationPeriod>[];
    final yearlyResults = <SimulationPeriod>[];

    // Valores iniciais por ativo
    final valueByAsset = <String, double>{};
    for (final inv in investments) {
      valueByAsset[inv.ticker] = _initialInvestment * inv.allocation;
    }

    double totalInvested = _initialInvestment;
    final totalMonths = _years * 12;

    for (int month = 1; month <= totalMonths; month++) {
      // Adiciona aporte mensal (exceto no mês 1, já que começamos com o inicial)
      if (month > 1) {
        totalInvested += _monthlyContribution;
        for (final inv in investments) {
          valueByAsset[inv.ticker] = (valueByAsset[inv.ticker] ?? 0) +
              (_monthlyContribution * inv.allocation);
        }
      }

      // Aplica rendimento mensal para cada ativo
      for (final inv in investments) {
        final monthlyReturn = _calculateMonthlyReturn(inv.annualReturn);
        valueByAsset[inv.ticker] =
            (valueByAsset[inv.ticker] ?? 0) * (1 + monthlyReturn);
      }

      // Calcula totais
      final totalValue = valueByAsset.values.fold<double>(0, (a, b) => a + b);
      final valueByCategory = _groupByCategory(valueByAsset);

      final period = SimulationPeriod(
        period: month,
        totalValue: totalValue,
        investedAmount: totalInvested,
        gains: totalValue - totalInvested,
        valueByCategory: Map.from(valueByCategory),
        valueByAsset: Map.from(valueByAsset),
      );

      monthlyResults.add(period);

      // Salva resultado anual
      if (month % 12 == 0) {
        yearlyResults.add(SimulationPeriod(
          period: month ~/ 12,
          totalValue: totalValue,
          investedAmount: totalInvested,
          gains: totalValue - totalInvested,
          valueByCategory: Map.from(valueByCategory),
          valueByAsset: Map.from(valueByAsset),
        ));
      }
    }

    _result = SimulationResult(
      initialInvestment: _initialInvestment,
      monthlyContribution: _monthlyContribution,
      years: _years,
      monthlyResults: monthlyResults,
      yearlyResults: yearlyResults,
    );

    _isLoading = false;
    notifyListeners();
  }

  /// Calcula retorno mensal a partir do anual
  double _calculateMonthlyReturn(double annualReturn) {
    return pow(1 + annualReturn, 1 / 12) - 1;
  }

  /// Agrupa valores por categoria
  Map<String, double> _groupByCategory(Map<String, double> valueByAsset) {
    final result = <String, double>{};
    for (final inv in investments) {
      final category = inv.category;
      result[category] = (result[category] ?? 0) + (valueByAsset[inv.ticker] ?? 0);
    }
    return result;
  }

  /// Limpa resultado da simulação
  void clearResult() {
    _result = null;
    notifyListeners();
  }
}

