import 'package:finance_track_app/core/utils.dart';
import 'package:finance_track_app/core/widgets/spaces_widget.dart';
import 'package:finance_track_app/ui/bottom_nav/bottom_navcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyBottomNavBar extends StatelessWidget {
  final BottomNavBarController bnc = Get.put(BottomNavBarController());
  MyBottomNavBar({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        body: Obx(() {
          debugPrint("update screen");
          return bnc.pages[ bnc.currentIndex.value];
        }),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),

              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  )), // alignment: Alignment.bottomCenter,
              // color: Colors.red,
              // margin: EdgeInsets.only(top: Get.height - 45),
              height: 65,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: customBottomNavBarChildContainer(
                        controller: bnc,
                        icon: Icons.home,
                        index: 0,
                        text: 'Dashboard'),
                  ),
                  Spaces().midw(),
                  Flexible(
                    child: customBottomNavBarChildContainer(
                      controller: bnc,
                      // icon: FontAwesome.circle_info,
                      icon: Icons.money,
                      index: 1,
                      text: 'Financial Goals',
                    ),
                  ),
                  Spaces().midw(),
                  Flexible(
                    child: customBottomNavBarChildContainer(
                        controller: bnc,
                        icon: Icons.analytics,
                        index: 2,
                        text: 'Expense Analytics'),
                  ),
                  Spaces().midw(),
                  Flexible(
                    child: customBottomNavBarChildContainer(
                        controller: bnc,
                        icon: Icons.person,
                        index: 3,
                        text: 'Profile'),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
// import 'package:flutter_svg/flutter_svg.dart';

Widget customBottomNavBarChildContainer({
  required String text,
  required dynamic icon,
  required int index,
  required BottomNavBarController controller,
}) {
  return GestureDetector(
    onTap: () {
      controller.currentIndex(index);
    },
    child: Obx(
      () {
        bool isSelected = controller.currentIndex.value == index;
        return Container(
          decoration: BoxDecoration(
            color: isSelected
                ? ColorConstraint.primaryLightColor
                : const Color(0xffDBEBF6),
            borderRadius: BorderRadius.circular(16),
          ),
          width: isSelected ? 55 : 55,
          height: isSelected ? 55 : 55,
          child: Center(
            child: Icon(
              icon,
              size: isSelected ? 29 : 29,
              color: isSelected
                  ? ColorConstraint.whiteColor
                  : ColorConstraint.primaryLightColor.withOpacity(.7),
            ),
          ),
        );
      },
    ),
  );
}
