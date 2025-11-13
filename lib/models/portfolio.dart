import 'holding.dart';

class Portfolio {
  final String user;
  final double portfolioValue; // optional from json, we’ll also compute
  final double totalGain;      // optional from json, we’ll also compute
  final List<Holding> holdings;

  Portfolio({
    required this.user,
    required this.portfolioValue,
    required this.totalGain,
    required this.holdings,
  });

  factory Portfolio.fromJson(Map<String, dynamic> j) {
    final holdings = (j['holdings'] as List<dynamic>)
        .map((e) => Holding.fromJson(e as Map<String, dynamic>))
        .toList();

    // Compute totals if missing or inconsistent
    final computedValue = holdings.fold<double>(0, (s, h) => s + h.currentValue);
    final computedInvested = holdings.fold<double>(0, (s, h) => s + h.invested);
    final computedGain = computedValue - computedInvested;

    return Portfolio(
      user: j['user'] as String,
      portfolioValue: (j['portfolio_value'] as num?)?.toDouble() ?? computedValue,
      totalGain: (j['total_gain'] as num?)?.toDouble() ?? computedGain,
      holdings: holdings,
    );
  }
}
