import 'package:agrime_application/app/utils/widget/custom_button.dart';
import 'package:agrime_application/app/utils/widget/custom_textfield.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'AgriMe',
            style: GoogleFonts.sigmar(),
          ),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Create a New account",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, fontSize: 32),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  CustomTextfield(
                    hintText: "Email",
                    editingController: controller.email_controller,
                  ),
                  CustomTextfield(
                    hintText: "Username",
                    editingController: controller.username_controller,
                  ),
                  Row(
                    children: [
                      SizedBox(
                          width: 150,
                          child: CustomTextfield(
                            hintText: "First Name",
                            editingController: controller.firstname_controller,
                          )),
                      const SizedBox(
                        width: 20,
                      ),
                      SizedBox(
                          width: 150,
                          child: CustomTextfield(
                            hintText: "Last Name",
                            editingController: controller.lastname_controller,
                          )),
                    ],
                  ),
                  CustomTextfield(
                    isPasswordField: true,
                    hintText: "Password",
                    editingController: controller.password_controller,
                  ),
                  const SizedBox(
                    height: 240,
                  ),
                  Obx(
                    () => CustomButtonWidget(
                      buttonText: controller.isLoading.value
                          ? "Loading ..."
                          : "Register",
                      function: () {
                        controller.isLoading.value
                            ? null
                            : controller.register();
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
