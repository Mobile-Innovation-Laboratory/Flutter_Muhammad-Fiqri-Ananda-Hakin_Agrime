import 'package:agrime_application/app/utils/widget/custom_appbar.dart';
import 'package:agrime_application/app/utils/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: controller.loadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Scaffold(
            appBar: const CustomAppbar(),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ProfilePicture(
                        name:
                            "${controller.data['firstname']} ${controller.data['lastname']}",
                        radius: 40,
                        fontsize: 21,
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${controller.data['firstname']} ${controller.data['lastname']}",
                            style: GoogleFonts.poppins(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${controller.data['username']}",
                            style: GoogleFonts.poppins(fontSize: 13),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color(0xFFe8ebe6), width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SizedBox(
                              width: 100,
                              height: 30,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      controller.data['role'] == "admin"
                                          ? Icons.star_rounded
                                          : Icons.person_rounded,
                                      size: 20,
                                      color: controller.data['role'] == 'admin'
                                          ? Colors.amber
                                          : Colors.blue,
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      "${controller.data['role']}",
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF70756b),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    "General",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF70756b)),
                  ),
                  ButtonLessWidget(
                    icon_button: Icons.shopping_basket_outlined,
                    buttonText: "My Order",
                    function: () {
                      Get.toNamed('/order');
                    },
                  ),
                  ButtonLessWidget(
                    icon_button: Icons.settings,
                    buttonText: "Settings",
                    function: () {
                      Get.toNamed('/setting');
                    },
                  ),
                  if (controller.data['role'] == 'petani')
                    ButtonLessWidget(
                      icon_button: Icons.shopping_basket_outlined,
                      buttonText: "Open Shop",
                      function: () {
                        Get.toNamed('/product-catalog');
                      },
                    ),
                ],
              ),
            ),
          );
        });
  }
}
