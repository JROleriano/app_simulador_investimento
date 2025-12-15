import 'package:intl/intl.dart';

class Formatters {
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
    decimalDigits: 2,
  );

  static final NumberFormat _compactCurrencyFormat = NumberFormat.compactCurrency(
    locale: 'pt_BR',
    symbol: 'R\$',
    decimalDigits: 1,
  );

  static final NumberFormat _percentFormat = NumberFormat.decimalPercentPattern(
    locale: 'pt_BR',
    decimalDigits: 2,
  );

  static final NumberFormat _numberFormat = NumberFormat.decimalPattern('pt_BR');

  /// Formata valor como moeda brasileira (R$ 1.234,56)
  static String currency(double value) {
    return _currencyFormat.format(value);
  }

  /// Formata valor compacto (R$ 1,2 mi)
  static String currencyCompact(double value) {
    return _compactCurrencyFormat.format(value);
  }

  /// Formata percentual (12,50%)
  static String percent(double value) {
    return _percentFormat.format(value);
  }

  /// Formata percentual simples sem multiplicar por 100
  static String percentSimple(double value) {
    return '${_numberFormat.format(value * 100)}%';
  }

  /// Formata número decimal
  static String decimal(double value, {int digits = 2}) {
    return value.toStringAsFixed(digits).replaceAll('.', ',');
  }

  /// Parse de string monetária para double
  static double? parseCurrency(String value) {
    try {
      final cleaned = value
          .replaceAll('R\$', '')
          .replaceAll('.', '')
          .replaceAll(',', '.')
          .trim();
      return double.tryParse(cleaned);
    } catch (_) {
      return null;
    }
  }
}

