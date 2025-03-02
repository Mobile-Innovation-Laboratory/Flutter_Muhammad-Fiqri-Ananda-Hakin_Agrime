import 'package:get/get.dart';

import '../controllers/list_catalog_controller.dart';

class ListCatalogBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListCatalogController>(
      () => ListCatalogController(),
    );
  }
}
