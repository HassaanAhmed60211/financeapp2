import 'package:finance_track_app/core/Model/transaction_model.dart';
import 'package:finance_track_app/core/theme.dart';
import 'package:finance_track_app/core/utils.dart';
import 'package:finance_track_app/core/widgets/custom_elevated.dart';
import 'package:finance_track_app/core/widgets/custom_snackbar.dart';
import 'package:finance_track_app/core/widgets/spaces_widget.dart';
import 'package:finance_track_app/core/widgets/text_widgets.dart';
import 'package:finance_track_app/ui/dashboard/dashboard_controller.dart';
import 'package:finance_track_app/ui/dashboard/dialogs/data_dialog.dart';
import 'package:finance_track_app/ui/dashboard/dialogs/update_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget customTransContainer(context) {
  final ThemeController themeController = Get.put(ThemeController());
  DashboardController controllerdash = Get.put(DashboardController());

  return Container(
      width: Get.width,
      decoration: BoxDecoration(
        color: themeController.isDarkMode.value
            ? Colors.grey[200]
            : ColorConstraint().primaryColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black38, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              customTextWidget(
                  'Transactions', Colors.black, FontWeight.w700, 21),
              customElevetedBtnWid(() {
                showAddDialog(context);
              }, 'Add', 20, 110)
            ],
          ),
          GetBuilder<DashboardController>(builder: (controlle) {
            return FutureBuilder<List<TransactionModel>>(
              future: controlle.fetchAllTransaction(),
              builder:
                  (context, AsyncSnapshot<List<TransactionModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: Get.height * 0.5,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: ColorConstraint.primaryLightColor,
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
                } else if (snapshot.data!.isEmpty) {
                  return Center(
                    child: customTextWidget(
                      'No data available',
                      Colors.black,
                      FontWeight.w500,
                      12,
                    ),
                  );
                } else {
                  final transaction = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: transaction.length,
                    itemBuilder: (context, index) {
                      final trans = transaction[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Card(
                            color: const Color(0xff4F3D56).withOpacity(0.8),
                            child: Obx(
                              () => ListTile(
                                title: customTextWidget(
                                    trans.text ?? '',
                                    ColorConstraint.whiteColor,
                                    FontWeight.w500,
                                    16),
                                subtitle: customTextWidget(
                                    controllerdash.convertToPKR.value
                                        ? "\$${controllerdash.convertPkrToUsd(double.parse(trans.price!)).toStringAsFixed(2)}"
                                        : "Rs.${trans.price}",
                                    ColorConstraint.whiteColor,
                                    FontWeight.w600,
                                    12),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: ColorConstraint.whiteColor,
                                      ),
                                      onPressed: () {
                                        String text = trans.text!;
                                        String price = trans.price!;
                                        showUpdateDialog(
                                            context, index, text, price);
                                      },
                                    ),
                                    Spaces.smallh,
                                    GetBuilder<DashboardController>(
                                        builder: (controller) {
                                      return IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: ColorConstraint.whiteColor,
                                        ),
                                        onPressed: () async {
                                          await controller.deleteData(
                                              index, trans.text!);
                                          controller.fetchIncomeData();
                                          showSuccessSnackBar(
                                              context: context,
                                              label: 'successfully deleted');
                                        },
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            )),
                      );
                    },
                  );
                }
              },
            );
          }),
        ]),
      ));
}
