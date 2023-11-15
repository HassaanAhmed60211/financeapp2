import 'package:finance_track_app/core/theme.dart';
import 'package:finance_track_app/core/utils.dart';
import 'package:finance_track_app/core/widgets/custom_elevated.dart';
import 'package:finance_track_app/core/widgets/spaces_widget.dart';
import 'package:finance_track_app/core/widgets/text_widgets.dart';
import 'package:finance_track_app/ui/dashboard/dashboard_controller.dart';
import 'package:finance_track_app/ui/dashboard/dialogs/data_dialog.dart';
import 'package:finance_track_app/ui/dashboard/dialogs/update_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

final ThemeController _themeController = Get.put(ThemeController());
final _auth = FirebaseAuth.instance;
DashboardController controllerdash = Get.put(DashboardController());
Widget customTransContainer(context) {
  return Container(
    width: Get.width,
    height: Get.height,
    decoration: BoxDecoration(
      color: _themeController.isDarkMode.value
          ? Colors.grey[200]
          : ColorConstraint().primaryColor,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.black38, width: 1),
    ),
    child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                customTextWidget(
                    'Transactions', Colors.black, FontWeight.w700, 21),
                customElevetedBtn(() {
                  showAddDialog(context);
                }, 'Add', 20)
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controllerdash.textData.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> data = controllerdash.textData[index];

                return Container();
              },
            ),
            GetBuilder<DashboardController>(builder: (controller) {
              return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.textData.length,
                  itemBuilder: (context, index) {
                    return controller.textData.isEmpty
                        ? const Center(
                            child: SizedBox(
                            height: 200,
                            child: Text("No Data"),
                          ))
                        : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Card(
                              color: Colors.blue[900],
                              child: Obx(() => ListTile(
                                    title: Text(controller.textData[index]
                                            ['text'] ??
                                        ''),
                                    subtitle: Text(controller.convertToPKR.value
                                        ? "\$${controller.convertPkrToUsd(double.parse(controller.textData[index]['price'])).toStringAsFixed(2)}"
                                        : "Rs.${controller.textData[index]['price']}"),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () {
                                            String text = controllerdash
                                                .textData[index]['text'];
                                            String price = controllerdash
                                                .textData[index]['price'];
                                            showUpdateDialog(
                                                context, index, text, price);
                                          },
                                        ),
                                        Spaces().smallh(),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () {
                                            controller.deleteData(index);
                                          },
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          );
                  });
            })
          ],
        )),
  );
}
