import 'package:agrime_application/app/services/auth_service.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  var currentIndex = 0.obs;
  final authService = Get.put(AuthService());
  @override
  void onInit() {
    authService.isTokenValid();
    super.onInit();
  }

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}
