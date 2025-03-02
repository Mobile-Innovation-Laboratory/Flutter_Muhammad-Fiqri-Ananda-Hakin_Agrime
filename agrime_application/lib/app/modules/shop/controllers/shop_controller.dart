import 'package:get/get.dart';

class ShopController extends GetxController {
  var selectedCat = "Buah".obs;

  void selectedCategory(String category) {
    selectedCat.value = category;
  }
}
