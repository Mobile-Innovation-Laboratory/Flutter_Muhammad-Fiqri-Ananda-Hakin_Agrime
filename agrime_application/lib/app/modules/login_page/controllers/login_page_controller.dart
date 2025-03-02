import 'dart:convert';

import 'package:agrime_application/app/data/models/user_model.dart';
import 'package:agrime_application/app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPageController extends GetxController {
  //TODO: Implement LoginPageController

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var isLoading = false.obs;
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future givePref() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("is_logged_in", true);
  }

  Future<bool> checkedLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  Future<void> login() async {
    isLoading.value = true;
    update();
    try {
      final UserModel response = await UserService().login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      print("Test");
      if (response.userData != null) {
        final userDataString = jsonEncode(response.userData);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool("is_logged_in", true);
        await prefs.setString('Token', response.token ?? "");
        await prefs.setString('userData', userDataString);
        Get.offNamed('/home');
        Get.snackbar(
          "Login Successfull",
          'Welcome ${response.userData?.username ?? "Guest"}',
        );
      } else {
        print("Error");
      }
    } catch (e) {
      print(e);
      Get.snackbar("Login Failed", e.toString());
    } finally {
      emailController.text = "";
      passwordController.text = "";
      isLoading.value = false;
      update();
    }
  }
}
