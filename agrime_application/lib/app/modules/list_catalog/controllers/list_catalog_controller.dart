import 'package:get/get.dart';

class ListCatalogController extends GetxController {
  var id = Get.arguments['id'];
  @override
  void onInit() {
    id = Get.arguments['id'];
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    id = Get.arguments['id'];
  }
}
