import 'package:finance_track_app/core/Model/graph_model.dart';
import 'package:finance_track_app/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:get/get.dart';

class GraphChart extends StatelessWidget {
  final List<GraphSeries> data;

  const GraphChart({super.key, required this.data});
  @override
  Widget build(BuildContext context) {
    List<charts.Series<GraphSeries, String>> series = [
      charts.Series(
          id: "Graphs",
          data: data,
          domainFn: (GraphSeries series, _) => series.label,
          measureFn: (GraphSeries series, _) => series.price,
          colorFn: (GraphSeries series, _) => series.barColor)
    ];

    return Container(
      width: Get.width,
      height: 250,
      padding: const EdgeInsets.all(1),
      child: Card(
        color: ColorConstraint().primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: charts.BarChart(series, animate: true),
              )
            ],
          ),
        ),
      ),
    );
  }
}
