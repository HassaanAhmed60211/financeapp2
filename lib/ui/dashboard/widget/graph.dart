import 'package:finance_track_app/core/Model/graph_model.dart';
import 'package:finance_track_app/core/Model/income_model.dart';
import 'package:finance_track_app/core/utils.dart';
import 'package:finance_track_app/core/widgets/graph_chart.dart';
import 'package:finance_track_app/core/widgets/text_widgets.dart';
import 'package:finance_track_app/ui/dashboard/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:get/get.dart';

Widget customGraphChart() {
  return GetBuilder<DashboardController>(builder: (controlle) {
    return FutureBuilder<IncomeModel?>(
      future: controlle.fetchIncomeData(),
      builder: (context, AsyncSnapshot<IncomeModel?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: Get.height * 0.3,
            child: const Center(
              child: CircularProgressIndicator(
                color: ColorConstraint.primeColor,
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: customTextWidget(
              snapshot.error.toString(),
              Colors.black,
              FontWeight.w500,
              12,
            ),
          );
        } else if (snapshot.data == null) {
          return Center(
            child: customTextWidget(
              'No data available',
              Colors.black,
              FontWeight.w500,
              12,
            ),
          );
        } else {
          final data = snapshot.data!;
          return GraphChart(
            data: [
              GraphSeries(
                label: 'Income',
                price: double.tryParse('${data.income}') ?? 0.0,
                barColor: charts.ColorUtil.fromDartColor(Colors.green),
              ),
              GraphSeries(
                label: 'Expenses',
                price: double.tryParse('${data.expenses}') ?? 0.0,
                barColor: charts.ColorUtil.fromDartColor(Colors.red),
              ),
              GraphSeries(
                label: 'Savings',
                price: double.tryParse('${data.savings}') ?? 0.0,
                barColor: charts.ColorUtil.fromDartColor(Colors.blueGrey),
              ),
            ],
          );
        }
      },
    );
  });
}
