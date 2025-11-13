import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/holding.dart';

class AllocationChart extends StatefulWidget {
  final List<Holding> holdings;

  const AllocationChart({super.key, required this.holdings});

  @override
  State<AllocationChart> createState() => _AllocationChartState();
}

class _AllocationChartState extends State<AllocationChart> {
  int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (widget.holdings.isEmpty || widget.holdings.fold<double>(0, (s, h) => s + h.currentValue) == 0) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(child: Text('No data to show allocation', style: theme.textTheme.bodyLarge)),
      );
    }

    final total = widget.holdings.fold<double>(0, (s, h) => s + h.currentValue);

    final colors = [
      const Color.fromARGB(160, 165, 38, 187),
      const Color(0xFF06B6D4),
      const Color(0xFFF59E0B),
      const Color(0xFFEC4899),
      const Color(0xFF10B981),
    ];

    final sections = widget.holdings.asMap().entries.map((entry) {
      final i = entry.key;
      final h = entry.value;
      final percent = total > 0 ? (h.currentValue / total) * 100 : 0.0;
      final isTouched = touchedIndex == i;
      return PieChartSectionData(
        color: colors[i % colors.length],
        value: h.currentValue,
        radius: isTouched ? 80 : 60,
        title: '${h.symbol}\n${percent.toStringAsFixed(1)}%',
        titleStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.white.withOpacity(0.95),
        ),
        badgeWidget: isTouched
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 6, offset: const Offset(0, 3))],
                ),
                child: Text('₹${h.currentValue.toStringAsFixed(0)}',
                    style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontWeight: FontWeight.w700)),
              )
            : null,
        badgePositionPercentageOffset: 0.98,
      );
    }).toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 260,
          child: PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 54,
              sectionsSpace: 4,
              pieTouchData: PieTouchData(
                touchCallback: (event, response) {
                  if (response == null || response.touchedSection == null) {
                    setState(() => touchedIndex = null);
                    return;
                  }
                  setState(() => touchedIndex = response.touchedSection!.touchedSectionIndex);
                },
              ),
            ),
            swapAnimationDuration: const Duration(milliseconds: 300),
          ),
        ),
        const SizedBox(height: 12),
        
        Wrap(
          spacing: 8,
          runSpacing: 6,
          alignment: WrapAlignment.center,
          children: widget.holdings.asMap().entries.map((entry) {
            final i = entry.key;
            final h = entry.value;
            final c = colors[i % colors.length];
            return Chip(
              backgroundColor: c.withOpacity(0.12),
              label: Text(
                h.symbol,
                style: TextStyle(color: c, fontWeight: FontWeight.w700, fontSize: 12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            );
          }).toList(),
        ),
      ],
    );
  }
}
