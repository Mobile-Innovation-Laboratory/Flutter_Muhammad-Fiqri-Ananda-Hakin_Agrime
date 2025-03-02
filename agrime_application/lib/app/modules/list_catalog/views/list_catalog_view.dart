import 'package:agrime_application/app/utils/constanta.dart';
import 'package:agrime_application/app/utils/widget/custom_appbar.dart';
import 'package:agrime_application/app/utils/widget/wait_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_product_card/flutter_product_card.dart';

import 'package:get/get.dart';

import '../controllers/list_catalog_controller.dart';

class ListCatalogView extends GetView<ListCatalogController> {
  const ListCatalogView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppbar(),
        body: Column(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection("products").where(
                  "categories",
                  arrayContains: {"id": controller.id}).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const WaitWidget();
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No products found"));
                }

                return Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.53,
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final document = snapshot.data!.docs[index];

                      return ProductCard(
                        currency: 'Rp.',
                        imageUrl: "$url/uploads/${document['image']}",
                        categoryName: document['name'],
                        productName: document['name'],
                        price: (document['price'] as num).toDouble(),
                        onTap: () {
                          Get.toNamed('/product-detail',
                              arguments: {'id': document.id});
                        },
                      );
                    },
                  ),
                );
              },
            )
          ],
        ));
  }
}
