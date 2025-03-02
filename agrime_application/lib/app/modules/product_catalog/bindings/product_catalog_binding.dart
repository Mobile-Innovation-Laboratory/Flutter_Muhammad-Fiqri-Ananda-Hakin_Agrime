import 'package:get/get.dart';

import '../controllers/product_catalog_controller.dart';

class ProductCatalogBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductCatalogController>(
      () => ProductCatalogController(),
    );
  }
}
