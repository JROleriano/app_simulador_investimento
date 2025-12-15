import 'dart:math' show log, exp;

/// Representa um ativo de investimento individual
class Investment {
  final String name;
  final String ticker;
  final String category; // 'tesouro', 'etf', 'fii'
  final double allocation; // percentual de alocação (ex: 0.12 = 12%)
  final double annualReturn; // retorno anual esperado (ex: 0.12 = 12% a.a.)
  final String description;

  const Investment({
    required this.name,
    required this.ticker,
    required this.category,
    required this.allocation,
    required this.annualReturn,
    required this.description,
  });

  /// Retorno mensal baseado no retorno anual
  double get monthlyReturn => (1 + annualReturn).toNthRoot(12) - 1;
}

extension DoubleExtension on double {
  /// Calcula a raiz n-ésima de um número
  double toNthRoot(int n) {
    if (this < 0 && n % 2 == 0) {
      throw ArgumentError('Cannot calculate even root of negative number');
    }
    return this < 0
        ? -(-this).pow(1.0 / n)
        : pow(1.0 / n);
  }

  double pow(double exponent) {
    return double.parse(
      (this as num).toDouble().toString(),
    ).toPower(exponent);
  }

  double toPower(double exponent) {
    return _pow(this, exponent);
  }
}

double _pow(double base, double exponent) {
  // Usando dart:math para potência
  return base <= 0 ? 0 : exp(exponent * log(base));
}

