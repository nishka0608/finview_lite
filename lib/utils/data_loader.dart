import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/portfolio.dart';

class DataLoader {
  static Future<Portfolio> loadPortfolio() async {
    final jsonString = await rootBundle.loadString('assets/portfolio.json');
    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    return Portfolio.fromJson(data);
  }
}
