import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  var data = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('userData');

    if (userData != null) {
      data.value = jsonDecode(userData);
    }
  }
}
