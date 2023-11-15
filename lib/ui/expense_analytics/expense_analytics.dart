import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:finance_track_app/core/theme.dart';
import 'package:finance_track_app/core/utils.dart';
import 'package:finance_track_app/core/widgets/app_bar.dart';
import 'package:finance_track_app/core/widgets/spaces_widget.dart';
import 'package:finance_track_app/core/widgets/text_widgets.dart';
import 'package:finance_track_app/ui/dashboard/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';

class ExpenseAnalytics extends StatelessWidget {
  ExpenseAnalytics({super.key});
  final ThemeController _themeController = Get.put(ThemeController());
  DashboardController dashboardController = Get.put(DashboardController());
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: _themeController.isDarkMode.value
              ? Colors.black87
              : ColorConstraint().primaryColor,
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: GlobalAppBar1('EXPENSE ANALYTICS')),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SingleChildScrollView(
              child: Column(children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Obx(
                      () => customTextWidget(
                          'NOVEMBER',
                          _themeController.isDarkMode.value
                              ? ColorConstraint().primaryColor
                              : ColorConstraint().backColor,
                          FontWeight.w700,
                          32),
                    ),
                    Spaces().midw(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: customTextWidget(
                          'Analytics',
                          _themeController.isDarkMode.value
                              ? ColorConstraint().primaryColor
                              : ColorConstraint().secondaryColor,
                          FontWeight.w600,
                          20),
                    ),
                  ],
                ),
                Spaces().largeh(),
                SizedBox(
                    height: 300,
                    width: Get.width,
                    child: GetBuilder<DashboardController>(
                      builder: (controller) {
                        return chartToRun(
                            controller.perExpense,
                            controller.perSaving,
                            controller.time,
                            controller.perIncome);
                      },
                    )),
              ]),
            ),
          ),
        ));
  }

  Widget chartToRun(chart1, chart2, time, perincome) {
    if (dashboardController.time.isEmpty ||
        dashboardController.perExpense.isEmpty ||
        dashboardController.perSaving.isEmpty) {
      return Center(child: Text('No Expenses available'));
    }

    try {
      LabelLayoutStrategy? xContainerLabelLayoutStrategy;
      ChartData chartData;
      ChartOptions chartOptions = const ChartOptions();

      chartOptions = const ChartOptions(
        dataContainerOptions: DataContainerOptions(
          startYAxisAtDataMinRequested: true,
        ),
      );

      chartData = ChartData(
        dataRows: [chart1, chart2],
        yUserLabels: perincome,
        xUserLabels: time,
        dataRowsLegends: const ['Expenses', 'Savings'],
        chartOptions: chartOptions,
      );

      var lineChartContainer = LineChartTopContainer(
        chartData: chartData,
        xContainerLabelLayoutStrategy: xContainerLabelLayoutStrategy,
      );

      var lineChart = LineChart(
        painter: LineChartPainter(
          lineChartContainer: lineChartContainer,
        ),
      );

      return lineChart;
    } catch (e) {
      print('Error in chartToRun: $e');
      return Text('Error generating chart');
    }
  }
}
