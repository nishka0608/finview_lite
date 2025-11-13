import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(const FinViewLiteApp());
}

class FinViewLiteApp extends StatefulWidget {
  const FinViewLiteApp({super.key});

  @override
  State<FinViewLiteApp> createState() => _FinViewLiteAppState();
}

class _FinViewLiteAppState extends State<FinViewLiteApp> {
  ThemeMode _mode = ThemeMode.system;

  // Light theme
  ThemeData get lightFintech {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4F46E5)),
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF7F8FB),
      cardColor: Colors.white,
      appBarTheme: const AppBarTheme(elevation: 0, backgroundColor: Colors.transparent),
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
      ),
    );
  }

  // Dark theme
  ThemeData get darkFintech {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF6366F1),
        secondary: Color(0xFF14B8A6),
        surface: Color(0xFF1E1E28),
        background: Color(0xFF0B0C10),
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFF0B0C10),
      cardColor: const Color(0xFF11121A),
      appBarTheme: const AppBarTheme(elevation: 0, backgroundColor: Colors.transparent),
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color.fromARGB(255, 133, 76, 225)),
        headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white),
      ),
    );
  }

  void _toggleMode() {
    setState(() {
      _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedTheme(
      data: _mode == ThemeMode.dark ? darkFintech : lightFintech,
      duration: const Duration(milliseconds: 350),
      child: MaterialApp(
        title: 'FinView Lite',
        debugShowCheckedModeBanner: false,
        themeMode: _mode,
        theme: lightFintech,
        darkTheme: darkFintech,
        home: Builder(builder: (ctx) {
          return Scaffold(
             
            body: Stack(
              children: [
                const DashboardScreen(),
 
                Positioned(
                  left: 16,
                  bottom: 18,
                  child: _ThemeToggleButton(
                    mode: _mode,
                    onTap: _toggleMode,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}


class _ThemeToggleButton extends StatelessWidget {
  final ThemeMode mode;
  final VoidCallback onTap;

  const _ThemeToggleButton({required this.mode, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = mode == ThemeMode.dark;
    final theme = Theme.of(context);

    // Button colors 
    final bgColor = isDark
        ? theme.colorScheme.surface // dark 
        : Colors.white; // light 

    final fgColor = isDark ? Colors.white : Colors.black87;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.18 : 0.06),
                blurRadius: isDark ? 8 : 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isDark ? Icons.wb_sunny : Icons.nightlight_round,
                size: 18,
                color: fgColor,
              ),
              const SizedBox(width: 8),
              Text(
                isDark ? 'Light Mode' : 'Dark Mode',
                style: TextStyle(color: fgColor, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
