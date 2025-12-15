import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/investment_provider.dart';
import '../utils/constants.dart';
import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _initialController;
  late TextEditingController _monthlyController;
  late TextEditingController _yearsController;

  @override
  void initState() {
    super.initState();
    final provider = context.read<InvestmentProvider>();
    _initialController = TextEditingController(
      text: provider.initialInvestment.toStringAsFixed(0),
    );
    _monthlyController = TextEditingController(
      text: provider.monthlyContribution.toStringAsFixed(0),
    );
    _yearsController = TextEditingController(
      text: provider.years.toString(),
    );
  }

  @override
  void dispose() {
    _initialController.dispose();
    _monthlyController.dispose();
    _yearsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appTitle),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildInputCard(),
              const SizedBox(height: 24),
              _buildPortfolioCard(),
              const SizedBox(height: 24),
              _buildSimulateButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      color: Theme.of(context).primaryColor.withAlpha(25),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              Icons.trending_up,
              size: 48,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 8),
            Text(
              'Simule seus investimentos',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'Veja como seu patrimônio pode crescer ao longo do tempo',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dados da Simulação',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _initialController,
              decoration: const InputDecoration(
                labelText: AppStrings.initialInvestment,
                prefixText: 'R\$ ',
                border: OutlineInputBorder(),
                hintText: '10000',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Informe o valor inicial';
                }
                final number = double.tryParse(value);
                if (number == null || number < 0) {
                  return 'Valor inválido';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _monthlyController,
              decoration: const InputDecoration(
                labelText: AppStrings.monthlyContribution,
                prefixText: 'R\$ ',
                border: OutlineInputBorder(),
                hintText: '1000',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Informe o aporte mensal';
                }
                final number = double.tryParse(value);
                if (number == null || number < 0) {
                  return 'Valor inválido';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _yearsController,
              decoration: const InputDecoration(
                labelText: AppStrings.investmentPeriod,
                suffixText: 'anos',
                border: OutlineInputBorder(),
                hintText: '10',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Informe o período';
                }
                final number = int.tryParse(value);
                if (number == null || number < 1 || number > 50) {
                  return 'Período entre 1 e 50 anos';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPortfolioCard() {
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
                  'Alocação do Portfólio',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildCategoryRow('Tesouro', 0.20, AppColors.tesouro),
            const SizedBox(height: 8),
            _buildCategoryRow('ETFs', 0.45, AppColors.etfs),
            const SizedBox(height: 8),
            _buildCategoryRow('FIIs', 0.35, AppColors.fiis),
            const Divider(height: 24),
            Consumer<InvestmentProvider>(
              builder: (context, provider, _) {
                return ExpansionTile(
                  title: const Text('Ver ativos detalhados'),
                  tilePadding: EdgeInsets.zero,
                  children: provider.investments.map((inv) {
                    return ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      title: Text(inv.ticker),
                      subtitle: Text(inv.name, style: const TextStyle(fontSize: 11)),
                      trailing: Text(
                        '${(inv.allocation * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryRow(String name, double allocation, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(name)),
        Text(
          '${(allocation * 100).toStringAsFixed(0)}%',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 100,
          child: LinearProgressIndicator(
            value: allocation,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }

  Widget _buildSimulateButton() {
    return Consumer<InvestmentProvider>(
      builder: (context, provider, _) {
        return ElevatedButton(
          onPressed: provider.isLoading ? null : _onSimulate,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: provider.isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calculate),
                    SizedBox(width: 8),
                    Text(
                      AppStrings.simulate,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Future<void> _onSimulate() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<InvestmentProvider>();

    provider.setInitialInvestment(double.parse(_initialController.text));
    provider.setMonthlyContribution(double.parse(_monthlyController.text));
    provider.setYears(int.parse(_yearsController.text));

    await provider.simulate();

    if (mounted && provider.result != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ResultScreen()),
      );
    }
  }
}

