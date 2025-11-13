import 'package:flutter/material.dart';

class PortfolioHeader extends StatelessWidget {
  final String user;
  final double totalValue;
  final double totalGain;
  final bool showPercent;

  const PortfolioHeader({
    super.key,
    required this.user,
    required this.totalValue,
    required this.totalGain,
    required this.showPercent,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gainColor = totalGain >= 0 ? const Color.fromARGB(255, 250, 250, 250) : const Color.fromARGB(255, 43, 183, 78);

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF0D0A25)        // Dark mode header
            : const Color(0xFF067D71),       //  Light mode header
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header text
          Text(
            'Hi, $user 👋',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: isDark ? Colors.white : Colors.white, 
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),

          // Label
          Text(
            'Portfolio Value',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: isDark ? Colors.white70 : Colors.white70,
                ),
          ),
          const SizedBox(height: 4),

          // Portfolio Value Text
          Text(
            '₹${totalValue.toStringAsFixed(0)}',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: isDark ? Colors.white : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),

          // Total Gain Row
          Row(
            children: [
              Text(
                'Total Gain: ',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: isDark ? Colors.white70 : Colors.white,
                    ),
              ),
              Text(
                showPercent ? _formatPercent() : '₹${totalGain.toStringAsFixed(0)}',
                style: TextStyle(color: gainColor, fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatPercent() {
    final invested = totalValue - totalGain;
    if (invested <= 0) return '+0.00%';
    final percent = (totalGain / invested) * 100;
    return '${percent >= 0 ? '+' : ''}${percent.toStringAsFixed(2)}%';
  }
}
