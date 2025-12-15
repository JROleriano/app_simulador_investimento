import 'investment.dart';

/// Portfolio de investimentos com os ativos pré-definidos
class Portfolio {
  static const List<Investment> defaultInvestments = [
    // TESOURO - 20%
    Investment(
      name: 'Tesouro Selic',
      ticker: 'SELIC',
      category: 'Tesouro',
      allocation: 0.12,
      annualReturn: 0.1275, // ~12.75% a.a. (taxa Selic atual)
      description: 'Liquidez diária, reserva de emergência',
    ),
    Investment(
      name: 'Tesouro IPCA+ / Renda+',
      ticker: 'IPCA+',
      category: 'Tesouro',
      allocation: 0.08,
      annualReturn: 0.10, // ~6% real + ~4% IPCA
      description: 'Proteção real, longo prazo, aposentadoria',
    ),

    // ETFs - 45%
    Investment(
      name: 'iShares S&P 500 (IVVB11)',
      ticker: 'IVVB11',
      category: 'ETFs',
      allocation: 0.25,
      annualReturn: 0.12, // média histórica S&P500 + variação cambial
      description: 'Crescimento global, dólar, tech + líderes mundiais',
    ),
    Investment(
      name: 'iShares Ibovespa (BOVA11)',
      ticker: 'BOVA11',
      category: 'ETFs',
      allocation: 0.12,
      annualReturn: 0.10, // média histórica Ibovespa
      description: 'Brasil grande, dividendos indiretos, ciclo doméstico',
    ),
    Investment(
      name: 'iShares Small Cap (SMAL11)',
      ticker: 'SMAL11',
      category: 'ETFs',
      allocation: 0.08,
      annualReturn: 0.14, // maior volatilidade, maior retorno potencial
      description: 'Small caps, volatilidade controlada, potencial extra',
    ),

    // FIIs - 35%
    Investment(
      name: 'Kinea Rendimentos (KNCR11)',
      ticker: 'KNCR11',
      category: 'FIIs',
      allocation: 0.12,
      annualReturn: 0.13, // CDI + spread
      description: 'FII papel CDI, renda previsível',
    ),
    Investment(
      name: 'Kinea Renda Imobiliária (KNRI11)',
      ticker: 'KNRI11',
      category: 'FIIs',
      allocation: 0.10,
      annualReturn: 0.10, // dividend yield + valorização
      description: 'Híbrido, tijolo de qualidade, gestão sólida',
    ),
    Investment(
      name: 'Kinea Securities (KNSC11)',
      ticker: 'KNSC11',
      category: 'FIIs',
      allocation: 0.07,
      annualReturn: 0.12, // IPCA + spread
      description: 'FII papel IPCA, proteção contra inflação',
    ),
    Investment(
      name: 'CSHG Logística (HGLG11)',
      ticker: 'HGLG11',
      category: 'FIIs',
      allocation: 0.06,
      annualReturn: 0.09, // dividend yield + valorização
      description: 'Logística, ativo físico, contratos longos',
    ),
  ];

  /// Agrupa investimentos por categoria
  static Map<String, List<Investment>> get byCategory {
    final map = <String, List<Investment>>{};
    for (final inv in defaultInvestments) {
      map.putIfAbsent(inv.category, () => []).add(inv);
    }
    return map;
  }

  /// Retorna alocação total por categoria
  static Map<String, double> get allocationByCategory {
    final map = <String, double>{};
    for (final inv in defaultInvestments) {
      map[inv.category] = (map[inv.category] ?? 0) + inv.allocation;
    }
    return map;
  }

  /// Verifica se alocações somam 100%
  static bool get isAllocationValid {
    final total = defaultInvestments.fold<double>(
      0,
      (sum, inv) => sum + inv.allocation,
    );
    return (total - 1.0).abs() < 0.001;
  }
}

