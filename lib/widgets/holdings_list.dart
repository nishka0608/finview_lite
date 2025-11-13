import 'package:flutter/material.dart';
import '../models/holding.dart';

enum HoldingSort { name, value, gain }

class HoldingsList extends StatelessWidget {
  final List<Holding> holdings;
  final bool showPercent;
  final HoldingSort sortBy;

  const HoldingsList({
    super.key,
    required this.holdings,
    required this.showPercent,
    required this.sortBy,
  });

  @override
  Widget build(BuildContext context) {
    final sorted = [...holdings];
    switch (sortBy) {
      case HoldingSort.name:
        sorted.sort((a, b) => a.name.compareTo(b.name));
        break;
      case HoldingSort.value:
        sorted.sort((b, a) => a.currentValue.compareTo(b.currentValue));
        break;
      case HoldingSort.gain:
        sorted.sort((b, a) => a.gainAmount.compareTo(b.gainAmount));
        break;
    }

    if (sorted.isEmpty) {
      return const Center(child: Padding(padding: EdgeInsets.all(24), child: Text('No holdings yet. Start investing to see insights.')));
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sorted.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final h = sorted[index];
        final gainColor = h.gainAmount >= 0 ? Colors.green : Colors.red;
        final rhs = showPercent ? '${h.gainPercent >= 0 ? '+' : ''}${h.gainPercent.toStringAsFixed(2)}%' : '₹${h.gainAmount.toStringAsFixed(2)}';

        return _HoverCard(
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            leading: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white10 : Colors.black87,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  h.symbol.length <= 4 ? h.symbol.toUpperCase() : h.symbol.substring(0, 4).toUpperCase(),
                  style: const TextStyle(color: Color.fromARGB(255, 230, 238, 5), fontWeight: FontWeight.w800, fontSize: 13),
                ),
              ),
            ),
            title: Text('${h.symbol}  ${h.name}', style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Text(
              '${h.units} units @ ₹${h.avgCost.toStringAsFixed(2)}',
              style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7)),
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('₹${h.currentValue.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(rhs, style: TextStyle(color: gainColor, fontSize: 13)),
              ],
            ),
          ),
        );
      },
    );
  }
}


class _HoverCard extends StatefulWidget {
  final Widget child;
  const _HoverCard({required this.child});

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        transform: _hover ? (Matrix4.identity()..translate(0, -6)) : Matrix4.identity(),
        child: Card(
          elevation: _hover ? 6 : 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: widget.child,
        ),
      ),
    );
  }
}
