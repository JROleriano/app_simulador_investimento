/// Resultado da simulação de um período (mensal ou anual)
class SimulationPeriod {
  final int period; // mês ou ano
  final double totalValue;
  final double investedAmount; // valor aportado total
  final double gains; // ganhos totais
  final Map<String, double> valueByCategory; // valor por categoria
  final Map<String, double> valueByAsset; // valor por ativo

  const SimulationPeriod({
    required this.period,
    required this.totalValue,
    required this.investedAmount,
    required this.gains,
    required this.valueByCategory,
    required this.valueByAsset,
  });
}

/// Resultado completo de uma simulação
class SimulationResult {
  final double initialInvestment;
  final double monthlyContribution;
  final int years;
  final List<SimulationPeriod> monthlyResults;
  final List<SimulationPeriod> yearlyResults;

  const SimulationResult({
    required this.initialInvestment,
    required this.monthlyContribution,
    required this.years,
    required this.monthlyResults,
    required this.yearlyResults,
  });

  /// Valor final após o período
  double get finalValue => yearlyResults.isNotEmpty
      ? yearlyResults.last.totalValue
      : 0;

  /// Total investido
  double get totalInvested => yearlyResults.isNotEmpty
      ? yearlyResults.last.investedAmount
      : initialInvestment;

  /// Ganhos totais
  double get totalGains => finalValue - totalInvested;

  /// Rentabilidade percentual total
  double get totalReturn => totalInvested > 0
      ? (totalGains / totalInvested) * 100
      : 0;
}

