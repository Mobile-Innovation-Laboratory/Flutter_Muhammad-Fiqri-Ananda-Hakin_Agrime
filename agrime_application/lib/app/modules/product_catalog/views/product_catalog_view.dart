import 'package:agrime_application/app/utils/constanta.dart';
import 'package:agrime_application/app/utils/widget/custom_appbar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/product_catalog_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductCatalogView extends GetView<ProductCatalogController> {
  const ProductCatalogView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(),
      body: Obx(() {
        if (controller.data['username'] == null ||
            controller.data['username'].isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('products')
                        .where('store', isEqualTo: controller.data['username'])
                        .snapshots(includeMetadataChanges: true),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Column(
                        children: [
                          for (final document in snapshot.data!.docs)
                            productCard(
                              name: document['name'],
                              stock: document['stock'],
                              imageName: document['image'],
                              id: document.id,
                            ),
                        ],
                      );
                    })
              ],
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/add-product');
        },
        backgroundColor: Colors.yellow,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class productCard extends StatelessWidget {
  final String name;
  final int stock;
  final String imageName;
  final String id;
  const productCard({
    super.key,
    required this.name,
    required this.stock,
    required this.imageName,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          leading: SizedBox(
            width: 50,
            height: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network('$url/uploads/$imageName'),
            ),
          ),
          tileColor: Colors.amber,
          splashColor: Colors.amber[300],
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name),
              Text(stock.toString()),
            ],
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            print(id);
            Get.toNamed('/catalog-detail', arguments: {
              'id': id,
            });
          },
        ),
      ),
    );
  }
}
