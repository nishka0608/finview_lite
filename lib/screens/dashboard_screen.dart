import 'package:flutter/material.dart';
import '../models/portfolio.dart';
import '../models/holding.dart';
import '../utils/data_loader.dart';
import '../widgets/portfolio_header.dart';
import '../widgets/holdings_list.dart';
import '../widgets/allocation_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<Portfolio> _future;
  bool _showPercent = false;
  HoldingSort _sortBy = HoldingSort.value;

  @override
  void initState() {
    super.initState();
    _future = DataLoader.loadPortfolio();
  }

  void _refresh() {
    setState(() => _future = DataLoader.loadPortfolio());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FutureBuilder<Portfolio>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Padding(padding: const EdgeInsets.all(16), child: Text('Failed to load: ${snapshot.error}'))),
          );
        }

        final portfolio = snapshot.data!;
        final media = MediaQuery.of(context).size;
        final isWide = media.width >= 700;

        return Scaffold(
          
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(84),
            child: Container(
              padding: const EdgeInsets.only(top: 28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.brightness == Brightness.dark ? const Color.fromARGB(255, 180, 91, 91) : const Color.fromARGB(255, 33, 155, 70),
                    theme.brightness == Brightness.dark ? const Color.fromARGB(255, 131, 202, 216) : const Color.fromARGB(255, 124, 196, 231),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(14)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text('FinView Lite', style: theme.textTheme.titleLarge?.copyWith(color: const Color.fromARGB(255, 255, 255, 255))),
                    const Spacer(),
                    IconButton(
                      onPressed: _refresh,
                      icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                      tooltip: 'Refresh',
                    ),
                    const SizedBox(width: 8),
                    // toggle Amount 
                    ToggleButtons(
                      isSelected: [_showPercent == false, _showPercent == true],
                      onPressed: (i) => setState(() => _showPercent = i == 1),
                      borderRadius: BorderRadius.circular(20),
                      selectedColor: const Color.fromARGB(255, 40, 117, 234),
                      fillColor: const Color.fromARGB(255, 211, 228, 212),
                      color: Colors.white70,
                      children: const [Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('₹')), Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('%'))],
                    ),
                  ],
                ),
              ),
            ),
          ),

          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PortfolioHeader(
                  user: portfolio.user,
                  totalValue: portfolio.portfolioValue,
                  totalGain: portfolio.totalGain,
                  showPercent: _showPercent,
                ),
                const SizedBox(height: 12),
                if (isWide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
  child: Container(
    margin: const EdgeInsets.only(right: 12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      gradient: theme.brightness == Brightness.dark
          ? const LinearGradient(colors: [Color.fromARGB(255, 19, 52, 63), Color.fromARGB(255, 136, 41, 55)])
          : const LinearGradient(colors: [Color.fromARGB(255, 18, 72, 165), Color.fromARGB(255, 59, 173, 93)]),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: Offset(0, 6))],
    ),
    padding: const EdgeInsets.all(18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Asset Allocation', style: TextStyle(color: Colors.white.withOpacity(0.95), fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        Center(child: AllocationChart(holdings: portfolio.holdings)),
      ],
    ),
  ),
),

                      SizedBox(
                        width: 520,
                        child: _buildHoldingsCard(portfolio.holdings),
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: AllocationChart(holdings: portfolio.holdings),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildHoldingsCard(portfolio.holdings),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHoldingsCard(List<Holding> holdings) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                const Text('Holdings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const Spacer(),
                DropdownButton<HoldingSort>(
                  value: _sortBy,
                  underline: const SizedBox.shrink(),
                  items: const [
                    DropdownMenuItem(value: HoldingSort.value, child: Text('Sort: Value')),
                    DropdownMenuItem(value: HoldingSort.gain, child: Text('Sort: Gain')),
                    DropdownMenuItem(value: HoldingSort.name, child: Text('Sort: Name')),
                  ],
                  onChanged: (v) => setState(() => _sortBy = v!),
                ),
              ],
            ),
            const SizedBox(height: 8),
            HoldingsList(
              holdings: holdings,
              showPercent: _showPercent,
              sortBy: _sortBy,
            ),
          ],
        ),
      ),
    );
  }
}
