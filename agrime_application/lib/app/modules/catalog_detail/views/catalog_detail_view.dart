import 'package:agrime_application/app/utils/constanta.dart';
import 'package:agrime_application/app/utils/widget/custom_appbar.dart';
import 'package:agrime_application/app/utils/widget/custom_button.dart';
import 'package:agrime_application/app/utils/widget/custom_textfield.dart';
import 'package:agrime_application/app/utils/widget/image_picker.dart';
import 'package:agrime_application/app/utils/widget_controllers/image_picker_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/catalog_detail_controller.dart';

class CatalogDetailView extends GetView<CatalogDetailController> {
  final imageControl = Get.put(ImageController());
  CatalogDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppbar(),
        body: Column(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .doc(controller.id)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text("Data tidak ditemukan"));
                }

                var data = snapshot.data!.data() as Map<String, dynamic>;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  controller.updateController(
                      data['name'], data['description']);
                });
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          print("object");
                        },
                        child: Center(
                          child: SizedBox(
                            width: 200,
                            height: 200,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                  '$url/uploads/${data['image']}'),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Tittle",
                        style: GoogleFonts.poppins(),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      CustomTextfield(
                        hintText: "Name",
                        editingController: controller.title_controller,
                      ),
                      Text(
                        "Description",
                        style: GoogleFonts.poppins(),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      CustomTextfield(
                        hintText: "Description",
                        editingController: controller.description_controller,
                      ),
                      // PickImage(),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      CustomButtonWidget(
                        buttonText: "Submit",
                        function: () {
                          controller.updateData();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ));
  }
}
