import 'package:finance_track_app/core/Model/graph_model.dart';
import 'package:finance_track_app/core/widgets/graph_chart.dart';
import 'package:finance_track_app/ui/dashboard/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

Widget customGraphChart() {
  return GraphChart(
    data: [
      GraphSeries(
        label: 'Income',
        price: double.parse(controllerdash.totalIncome.toString()),
        barColor: charts.ColorUtil.fromDartColor(Colors.green),
      ),
      GraphSeries(
        label: 'Expenses',
        price: double.parse(controllerdash.totalExpenses.toString()),
        barColor: charts.ColorUtil.fromDartColor(Colors.red),
      ),
      GraphSeries(
        label: 'Savings',
        price: double.parse(controllerdash.remainingIncome.toString()),
        barColor: charts.ColorUtil.fromDartColor(Colors.blueGrey),
      ),
    ],
  );
}
