import 'package:agrime_application/app/utils/widget/custom_button.dart';
import 'package:agrime_application/app/utils/widget/custom_textfield.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/login_page_controller.dart';

class LoginPageView extends GetView<LoginPageController> {
  const LoginPageView({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: controller.checkedLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.data == true) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.offNamed('/home');
          });
          return const SizedBox();
        }
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
                  'Log in To Your Account',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 32),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: SizedBox(
                  width: 320,
                  child: CustomTextfield(
                    hintText: "Email",
                    editingController: controller.emailController,
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  width: 320,
                  child: CustomTextfield(
                      isPasswordField: true,
                      hintText: "Password",
                      editingController: controller.passwordController),
                ),
              ),
              Text(
                "Forgot Password",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF408308)),
              ),
              const SizedBox(
                height: 320,
              ),
              Obx(
                () => SizedBox(
                  width: 320,
                  child: CustomButtonWidget(
                    buttonText:
                        controller.isLoading.value ? "Loading ..." : "Log In",
                    function: () {
                      controller.login();
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don’t have an account?",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF60655c),
                        fontSize: 15),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Ink(
                    child: InkWell(
                      onTap: () {
                        Get.toNamed('/register');
                      },
                      child: Text(
                        "Sign up",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            color: const Color(0xFF60655c),
                            fontSize: 15),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
