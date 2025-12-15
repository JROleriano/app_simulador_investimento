import 'package:flutter/material.dart';

/// Cores para categorias de investimento
class AppColors {
  // Categorias
  static const Color tesouro = Color(0xFF2196F3); // Azul
  static const Color etfs = Color(0xFF4CAF50); // Verde
  static const Color fiis = Color(0xFFFF9800); // Laranja

  // Tons para ativos individuais
  static const List<Color> tesouroShades = [
    Color(0xFF1976D2),
    Color(0xFF42A5F5),
  ];

  static const List<Color> etfShades = [
    Color(0xFF388E3C),
    Color(0xFF66BB6A),
    Color(0xFF81C784),
  ];

  static const List<Color> fiiShades = [
    Color(0xFFE65100),
    Color(0xFFFB8C00),
    Color(0xFFFFB74D),
    Color(0xFFFFCC80),
  ];

  // Gráficos
  static const Color chartLine = Color(0xFF6200EE);
  static const Color chartGain = Color(0xFF4CAF50);
  static const Color chartInvested = Color(0xFF9E9E9E);
  static const Color gridLine = Color(0xFFE0E0E0);
}

/// Textos e labels
class AppStrings {
  static const String appTitle = 'Simulador de Investimentos';
  static const String initialInvestment = 'Investimento Inicial';
  static const String monthlyContribution = 'Aporte Mensal';
  static const String investmentPeriod = 'Período (anos)';
  static const String simulate = 'Simular';
  static const String results = 'Resultados';
  static const String portfolio = 'Portfólio';
  static const String evolution = 'Evolução Patrimonial';
  static const String breakdown = 'Detalhamento';
  static const String finalValue = 'Valor Final';
  static const String totalInvested = 'Total Investido';
  static const String totalGains = 'Ganhos Totais';
  static const String totalReturn = 'Rentabilidade';
}

/// Constantes de valores padrão
class AppDefaults {
  static const double initialInvestment = 10000.0;
  static const double monthlyContribution = 1000.0;
  static const int years = 10;
  static const double inflationRate = 0.045; // 4.5% a.a.
}

