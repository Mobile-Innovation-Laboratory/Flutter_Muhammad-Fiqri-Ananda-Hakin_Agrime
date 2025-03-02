import 'package:agrime_application/app/utils/widget/custom_appbar.dart';
import 'package:agrime_application/app/utils/widget/custom_button.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/setting_controller.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppbar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              ButtonLessWidget(
                icon_button: Icons.logout,
                buttonText: "Log Out",
                function: () {
                  Get.defaultDialog(
                    title: "Log Out",
                    middleText: "Are you sure want to Log Out?",
                    textConfirm: "Yes",
                    textCancel: "Cancel",
                    confirmTextColor: Colors.white,
                    onConfirm: () => controller.logout(),
                    onCancel: () => Get.back(),
                  );
                },
              )
            ],
          ),
        ));
  }
}
