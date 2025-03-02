import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductCatalogController extends GetxController {
  var data = <String, dynamic>{}.obs;
  var isLoading = true.obs;
  @override
  void onInit() {
    loadData();
    super.onInit();
  }

  Future loadData() async {
    final prefs = await SharedPreferences.getInstance();
    data.value = jsonDecode(prefs.getString('userData') ?? '');
    update();
  }
}
