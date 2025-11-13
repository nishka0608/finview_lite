<<<<<<< HEAD
# FinView Lite

A modern **Flutter investment dashboard** that visualizes a user's portfolio, holdings, and returns using local JSON data.

# How to Run
### Install Flutter
Check Flutter version:
flutter --version

### Install packages
flutter pub get

### Run on Chrome (Web)
flutter run -d chrome

### Run on Android emulator / device
flutter run

### Ensure assets are added in `pubspec.yaml`
assets:
assets/portfolio.json
yaml

## Mock Data Used (portfolio.json)

{
  "user": "Aarav Patel",
  "portfolio_value": 150000,
  "total_gain": 12000,
  "holdings": [
    { "symbol": "TCS", "name": "Tata Consultancy", "units": 5, "avg_cost": 3200, "current_price": 3400 },
    { "symbol": "INFY", "name": "Infosys Ltd", "units": 10, "avg_cost": 1400, "current_price": 1500 },
    { "symbol": "HDFCBANK", "name": "HDFC Bank", "units": 8, "avg_cost": 1500, "current_price": 1585 },
    { "symbol": "RELIANCE", "name": "Reliance", "units": 4, "avg_cost": 2500, "current_price": 2420 }
  ]
}
# Dependencies Used
dependencies:
  flutter:
    sdk: flutter
  fl_chart: ^0.66.2

dev_dependencies:
  flutter_test:
    sdk: flutter

# Project Structure
lib/
  screens/
    dashboard_screen.dart
  widgets/
    portfolio_header.dart
    holdings_list.dart
    allocation_chart.dart
  models/
    holding.dart
    portfolio.dart
  utils/
    data_loader.dart

assets/
  portfolio.json

screenshots/
  dashboard_light.png
  dashboard_dark.png
  holdings_view.png

# Features Implemented
Sort by Value / Gain / Name
Light & Dark mode
Holdings list
Pie allocation chart

Demo Video Link
https://drive.google.com/drive/folders/1WKDz2Jz3fHHa3u-fbpmn9C1oa5TnUAxy

Screenshots: https://drive.google.com/drive/folders/1WKDz2Jz3fHHa3u-fbpmn9C1oa5TnUAxy

