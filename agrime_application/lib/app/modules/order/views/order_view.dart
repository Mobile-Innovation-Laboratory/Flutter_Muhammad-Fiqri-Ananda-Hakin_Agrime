import 'package:agrime_application/app/utils/constanta.dart';
import 'package:agrime_application/app/utils/widget/custom_appbar.dart';
import 'package:agrime_application/app/utils/widget/custom_button.dart';
import 'package:agrime_application/app/utils/widget/custom_empty.dart';
import 'package:agrime_application/app/utils/widget/wait_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/order_controller.dart';

class OrderView extends GetView<OrderController> {
  const OrderView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Obx(() {
            if (controller.userId.value.isEmpty) {
              return const WaitWidget();
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('order')
                        .where("userId", isEqualTo: controller.userId.value)
                        .where("status", isEqualTo: "pending")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const WaitWidget();
                      }
                      return Expanded(
                        child: SingleChildScrollView(
                          child: Column(children: [
                            for (final document in snapshot.data!.docs)
                              Column(
                                children: [
                                  OrderCard(
                                    textController: controller.textControllers
                                        .putIfAbsent(
                                            document.id,
                                            () => TextEditingController(
                                                text: document["items"]
                                                        ["quantity"]
                                                    .toString())),
                                    image:
                                        "$imgurl/${document["items"]?["image"]}",
                                    name: document["items"]?["item_name"],
                                    amount: document["items"]?["quantity"],
                                    price: document["items"]?["price"],
                                    docId: document.id,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  )
                                ],
                              ),
                          ]),
                        ),
                      );
                    }),
              ],
            );
          })),
      bottomNavigationBar: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('order')
            .where("userId", isEqualTo: controller.userId.value)
            .where("status", isEqualTo: "pending")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox();
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const CustomEmpty();
          }

          // Jika ada data, tampilkan tombol checkout
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 60,
              child: CustomButtonWidget(
                buttonText: "Checkout",
                function: () {
                  controller.checkout();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class OrderCard extends StatelessWidget {
  final OrderController controller = Get.put(OrderController());
  String image;
  String name;
  int price;
  int amount;
  String docId;
  TextEditingController textController;

  OrderCard(
      {super.key,
      required this.image,
      required this.name,
      required this.docId,
      required this.price,
      required this.amount,
      required this.textController});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 120,
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFe8ebe6)),
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              image,
              width: 100,
              height: 200,
              fit: BoxFit.fitWidth,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 140,
                child: Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Rp. $price",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  controller.deleteItemCart(docId);
                },
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 60, 46),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.transparent)),
                  child: const Center(child: Icon(Icons.close)),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: SizedBox(
              width: 60,
              height: 50,
              child: TextField(
                onChanged: (newValue) {
                  controller.updateQuantity(docId, newValue);
                },
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                controller: textController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
