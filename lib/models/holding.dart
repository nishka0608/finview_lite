class Holding {
  final String symbol;
  final String name;
  final int units;
  final double avgCost;
  final double currentPrice;

  Holding({
    required this.symbol,
    required this.name,
    required this.units,
    required this.avgCost,
    required this.currentPrice,
  });

  factory Holding.fromJson(Map<String, dynamic> j) => Holding(
        symbol: j['symbol'] as String,
        name: j['name'] as String,
        units: (j['units'] as num).toInt(),
        avgCost: (j['avg_cost'] as num).toDouble(),
        currentPrice: (j['current_price'] as num).toDouble(),
      );

  double get invested => units * avgCost;
  double get currentValue => units * currentPrice;
  double get gainAmount => currentValue - invested;

  /// Safe percent even when invested is zero
  double get gainPercent => invested == 0 ? 0 : (gainAmount / invested) * 100;
}
