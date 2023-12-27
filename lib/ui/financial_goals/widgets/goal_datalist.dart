import 'package:finance_track_app/core/Model/goal_model.dart';
import 'package:finance_track_app/core/utils.dart';
import 'package:finance_track_app/core/widgets/spaces_widget.dart';
import 'package:finance_track_app/core/widgets/text_widgets.dart';
import 'package:finance_track_app/ui/financial_goals/dialogs/update_dialog.dart';
import 'package:finance_track_app/ui/financial_goals/goal_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_progress_indicators/simple_progress_indicators.dart';

Widget goalList() {
  return SizedBox(
      height: Get.height,
      width: Get.width,
      child: GetBuilder<GoalController>(builder: (controller) {
        return FutureBuilder<List<GoalModel>?>(
            future: controller.fetchAllGoals(),
            builder: (context, AsyncSnapshot<List<GoalModel>?> snapshot) {
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
                List<GoalModel> goal = snapshot.data!;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: goal.length,
                  itemBuilder: (context, index) {
                    controller.progressval.value = controller.calculateProgress(
                        double.parse(goal[index].curentsaving.toString()),
                        double.parse(goal[index].totalsaving.toString()));
                    controller.percentage.value =
                        double.parse(goal[index].curentsaving.toString()) /
                            double.parse(goal[index].totalsaving.toString()) *
                            100;
                    controller.remainingperc.value =
                        double.parse(100.toStringAsFixed(2)) -
                            controller.percentage.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        color: Colors.grey[100],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        goal[index].goalname ?? '',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        ' : ${goal[index].curentsaving ?? ''} /',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              ColorConstraint.primaryLightColor,
                                        ),
                                      ),
                                      Text(
                                        ' ${goal[index].totalsaving ?? ''}',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              ColorConstraint.primaryLightColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          debugPrint(goal[index].goalname);
                                          showUpdateGoalDialog(
                                              context,
                                              index,
                                              goal[index].curentsaving,
                                              goal[index].goalname);
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          controller.deleteData(index,
                                              goal[index].goalname ?? '');
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: Get.width,
                                height: 20,
                                child: ProgressBar(
                                  value: controller.progressval.value,
                                  backgroundColor: Colors.black12,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color.fromARGB(255, 252, 14, 14),
                                      Color.fromARGB(201, 115, 255, 0),
                                    ],
                                  ),
                                ),
                              ),
                              Spaces.mid,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Goal Completed: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.green[600],
                                        ),
                                      ),
                                      Text(
                                        '${controller.percentage.value.toStringAsFixed(2)}%',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Goal Remaining: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.red[600],
                                        ),
                                      ),
                                      Text(
                                        '${controller.remainingperc.toStringAsFixed(2)}%',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            });
      }));
}
