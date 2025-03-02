import 'package:agrime_application/app/utils/constanta.dart';
import 'package:agrime_application/app/utils/widget/custom_appbar.dart';
import 'package:agrime_application/app/utils/widget/custom_button.dart';
import 'package:agrime_application/app/utils/widget/custom_textfield.dart';
import 'package:agrime_application/app/utils/widget/wait_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';

import '../controllers/product_detail_controller.dart';

class ProductDetailView extends GetView<ProductDetailController> {
  const ProductDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppbar(),
        body: Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("products")
                        .doc(controller.id)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const WaitWidget();
                      }
                      if (!snapshot.hasData || !snapshot.data!.exists) {
                        return const Center(child: Text("No categories found"));
                      }
                      var data = snapshot.data!.data();
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                "$imgurl/${data?['image']}",
                                width: 340,
                                height: 350,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: pillWidget(
                              stock: data?['stock'],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  child: Text(
                                    data?['name'],
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30),
                                  ),
                                ),
                                SizedBox(
                                  width: 290,
                                  child: ReadMoreText(
                                    data?['description'],
                                    trimMode: TrimMode.Line,
                                    trimLines: 2,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                CustomTextfield(
                                  hintText: "Amount /Kilogram",
                                  keyboardType: TextInputType.number,
                                  editingController:
                                      controller.amount_controller,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Rp. ${data?['price']}",
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24),
                                    ),
                                    Obx(() {
                                      return SizedBox(
                                        width: 200,
                                        child: CustomButtonWidget(
                                          buttonText: controller.isLoading.value
                                              ? "Loading..."
                                              : "Add To Cart",
                                          function: () {
                                            controller.isLoading.value
                                                ? null
                                                : controller.checkout(
                                                    data?['price'],
                                                    data?['name'],
                                                    data?['image']);
                                          },
                                        ),
                                      );
                                    })
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    })
              ],
            ),
          ),
        ));
  }
}

class pillWidget extends StatelessWidget {
  final int stock;
  const pillWidget({super.key, required this.stock});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: const Color(0xFFe8ebe6)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_cart_checkout_rounded),
            Text(
              "Stock : $stock",
              style: GoogleFonts.poppins(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
