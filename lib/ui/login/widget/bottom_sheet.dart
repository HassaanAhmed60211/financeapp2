import 'package:finance_track_app/core/utils.dart';
import 'package:finance_track_app/ui/profile/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

ProfileController profileController = Get.put(ProfileController());
TextEditingController textController = TextEditingController();

void showBottomInfoProfile(context, val) {
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                child: SizedBox(
                  height: 40,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                child: Container(
                  height: 60,
                  child: TextField(
                    controller: textController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        hintText: 'update your name',
                        hintStyle: TextStyle(color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(width: 1),
                        )),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          profileController.updateName(textController.text);
                          Get.back();
                        },
                        child: Text('Update'))),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      );
    },
  );
}
