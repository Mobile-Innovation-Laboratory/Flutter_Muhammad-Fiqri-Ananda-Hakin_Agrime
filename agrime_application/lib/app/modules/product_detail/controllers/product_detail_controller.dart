import 'package:agrime_application/app/services/auth_service.dart';
import 'package:agrime_application/app/services/cart_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailController extends GetxController {
  var id = Get.arguments['id'];
  TextEditingController amount_controller = TextEditingController();
  RxInt amount = 0.obs;
  var isLoading = false.obs;

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    amount_controller.dispose();
  }

  @override
  void onInit() {
    id = Get.arguments['id'];
    super.onInit();
  }

  Future checkout(int price, String itemName, String image) async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('Token') ?? "";
      FirebaseAuth.instance.setLanguageCode("id");
      final userCredential =
          await FirebaseAuth.instance.signInWithCustomToken(token);
      final key = await userCredential.user!.getIdToken();
      int quantity = int.tryParse(amount_controller.text) ?? 0;
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return AuthService().isTokenValid();
      }
      final response = await CartService()
          .addCart(id, quantity, user.uid, image, price, key, itemName);
      if (response.statusCode == 201) {
        Get.snackbar("Cart", "Sucess Adding to Cart");
        Get.offNamed('/home');
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
