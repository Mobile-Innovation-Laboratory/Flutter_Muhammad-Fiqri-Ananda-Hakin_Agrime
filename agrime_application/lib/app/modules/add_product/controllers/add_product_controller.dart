import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/product_service.dart';
import 'package:agrime_application/app/utils/widget_controllers/image_picker_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:dio/dio.dart';
import 'package:path/path.dart';

class Category {
  final String id;
  final String name;
  Category({required this.id, required this.name});
}

class AddProductController extends GetxController {
  final imgController = Get.find<ImageController>();
  var selectedItem = "".obs;
  var items = <Category>[].obs;
  var isLoading = false.obs;

  TextEditingController product_name_controller = TextEditingController();
  TextEditingController product_price_controller = TextEditingController();
  TextEditingController product_desc_controller = TextEditingController();
  TextEditingController product_stock_controller = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchCategory();
  }

  @override
  void onClose() {
    super.onClose();
    product_name_controller.dispose();
    product_price_controller.dispose();
    product_desc_controller.dispose();
    product_stock_controller.dispose();
  }

  void fetchCategory() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection("categories").get();
      items.value = snapshot.docs
          .map((document) => Category(
                id: document['id'],
                name: document["category"],
              ))
          .toList();
      if (items.isNotEmpty) {
        selectedItem.value = items.first.id;
      }
    } catch (e) {
      print(e);
    }
  }

  Future add_product() async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('Token') ?? "";
      FirebaseAuth.instance.setLanguageCode("id");
      final userCredential =
          await FirebaseAuth.instance.signInWithCustomToken(token);
      final key = await userCredential.user!.getIdToken();
      if (imgController.selectedImage.value == null) {
        Get.snackbar("Add Image", "Image file required");
        return;
      }
      if (product_name_controller.text.isEmpty ||
          product_price_controller.text.isEmpty ||
          product_stock_controller.text.isEmpty ||
          product_desc_controller.text.isEmpty) {
        Get.snackbar(
            "Required Field", "Please complete all field to add product");
        return;
      }
      var imageFile = imgController.selectedImage.value!;
      String fileName = basename(imageFile.path);
      FormData formData = FormData.fromMap({
        "photoproduct":
            await MultipartFile.fromFile(imageFile.path, filename: fileName),
        "name": product_name_controller.text,
        "price": product_price_controller.text,
        "stock": product_stock_controller.text,
        "description": product_desc_controller.text,
        "categoryId": selectedItem.value,
      });

      final response = await ProductService().addingProduct(formData, key);

      if (response.statusCode == 201) {
        Get.snackbar("Success Adding Product", "Product Added");
        Get.offNamed('/home');
      } else {
        Get.snackbar("Failed Adding Product", "You Product Failed to Add");
      }
    } catch (e) {
      Get.snackbar("Server Error", "Server Error");
    } finally {
      isLoading.value = false;
    }
  }

  void selectedCategory(String selected) {
    selectedItem.value = selected;
  }
}
