import 'package:agrime_application/app/modules/category/controllers/category_controller.dart';
import 'package:agrime_application/app/modules/category/views/category_view.dart';
import 'package:agrime_application/app/modules/profile/controllers/profile_controller.dart';
import 'package:agrime_application/app/modules/profile/views/profile_view.dart';
import 'package:agrime_application/app/modules/shop/controllers/shop_controller.dart';
import 'package:agrime_application/app/modules/shop/views/shop_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final List<Widget> _pages = [
    const ShopView(),
    const CategoryView(),
    const ProfileView(),
  ];
  HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ShopController());
    Get.lazyPut(() => ProfileController());
    Get.lazyPut(() => CategoryController());
    return Scaffold(
        body: Obx(() => _pages[controller.currentIndex.value]),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeIndex,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.card_travel_rounded), label: "Category"),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded),
                label: "Profile",
              ),
            ]));
  }
}
