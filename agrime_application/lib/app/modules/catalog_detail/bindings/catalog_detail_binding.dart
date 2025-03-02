import 'package:get/get.dart';

import '../controllers/catalog_detail_controller.dart';

class CatalogDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CatalogDetailController>(
      () => CatalogDetailController(),
    );
  }
}
