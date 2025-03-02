import 'package:agrime_application/app/services/product_service.dart';
import 'package:agrime_application/app/utils/widget_controllers/image_picker_controller.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CatalogDetailController extends GetxController {
  TextEditingController title_controller = TextEditingController();
  TextEditingController description_controller = TextEditingController();
  final imgController = Get.find<ImageController>();

  var id = Get.arguments['id'];
  final count = 0.obs;
  @override
  void onInit() {
    id = Get.arguments['id'];
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    id = Get.arguments['id'];
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    Get.delete<CatalogDetailController>();
  }

  void updateController(tittle, desc) {
    title_controller.text = tittle;
    description_controller.text = desc;
  }

  Future updateData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('Token') ?? "";
      FirebaseAuth.instance.setLanguageCode("id");
      final userCredential =
          await FirebaseAuth.instance.signInWithCustomToken(token);
      final key = await userCredential.user!.getIdToken();

      FormData formData = FormData.fromMap({
        "name": title_controller.text,
        "description": description_controller.text,
      });

      if (imgController.selectedImage.value != null) {
        var imageFile = imgController.selectedImage.value!;
        String fileName = basename(imageFile.path);
        formData.files.add(MapEntry(
          "photoproduct",
          await MultipartFile.fromFile(imageFile.path, filename: fileName),
        ));
      }

      final response = await ProductService().updateData(formData, key, id);

      if (response.statusCode == 200) {
        Get.snackbar("Success Update Product", "Product Updated");
        Get.offNamed('/home');
      } else {
        Get.snackbar("Failed Updating Product", "Your Product Update Failed");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
