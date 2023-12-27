import 'package:finance_track_app/core/widgets/custom_elevated.dart';
import 'package:finance_track_app/ui/profile/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showBottomInfoProfile(context, val) {
  ProfileController profileController = Get.put(ProfileController());
  TextEditingController textController = TextEditingController();
  textController.text = val;
  showModalBottomSheet<void>(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.white,
    builder: (BuildContext context) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(21)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                child: SizedBox(
                  height: 40,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                child: SizedBox(
                  height: 60,
                  child: TextField(
                    controller: textController,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        hintText: 'update your name',
                        hintStyle: const TextStyle(color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(width: 1),
                        )),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: customElevetedBtnWid(() {
                      profileController.updateName(textController.text);
                      Get.back();
                    }, 'Update', 19, Get.width * 0.4)),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      );
    },
  );
}
