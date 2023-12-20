import 'package:charts_flutter/flutter.dart' as charts;

class GraphSeries {
  final String label;
  final double price;
  final charts.Color barColor;

  GraphSeries(
      {required this.label, required this.price, required this.barColor});
}
