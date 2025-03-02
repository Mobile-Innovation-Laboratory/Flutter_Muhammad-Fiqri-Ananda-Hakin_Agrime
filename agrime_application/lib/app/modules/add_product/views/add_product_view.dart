import 'package:agrime_application/app/utils/widget/custom_appbar.dart';
import 'package:agrime_application/app/utils/widget/custom_button.dart';
import 'package:agrime_application/app/utils/widget/custom_textfield.dart';
import 'package:agrime_application/app/utils/widget/image_picker.dart';
import 'package:agrime_application/app/utils/widget_controllers/image_picker_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/add_product_controller.dart';

class AddProductView extends GetView<AddProductController> {
  final imageControl = Get.put(ImageController());
  AddProductView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Obx(() {
          if (controller.items.isEmpty) {
            return const CircularProgressIndicator();
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Product Name",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              CustomTextfield(
                hintText: "Product Name",
                editingController: controller.product_name_controller,
              ),
              Text(
                "Price",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              CustomTextfield(
                hintText: "Price",
                keyboardType: TextInputType.number,
                editingController: controller.product_price_controller,
              ),
              Text(
                "Stock",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              CustomTextfield(
                hintText: "Stock",
                keyboardType: TextInputType.number,
                editingController: controller.product_stock_controller,
              ),
              Text(
                "Description",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              CustomTextfield(
                hintText: "description",
                editingController: controller.product_desc_controller,
              ),
              Text(
                "Category",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 20,
              ),
              DropdownButtonFormField<String>(
                value: controller.selectedItem.value,
                decoration: InputDecoration(
                  labelText: "Pilih Kategori",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), // Border radius
                    borderSide: const BorderSide(
                      color: Colors.blue, // Warna border
                      width: 2, // Ketebalan border
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10), // Padding dalam dropdown
                ),
                icon: const Icon(Icons.arrow_drop_down,
                    color: Colors.blue), // Ikon dropdown
                dropdownColor: Colors.white, // Warna background dropdown
                items: controller.items.map((Category item) {
                  return DropdownMenuItem<String>(
                    value: item.id,
                    child: Text(
                      item.name,
                      style: const TextStyle(
                          fontSize: 16), // Styling teks dropdown
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    controller.selectedCategory(value);
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Photo",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 10,
              ),
              PickImage(),
              const SizedBox(
                height: 20,
              ),
              CustomButtonWidget(
                buttonText:
                    controller.isLoading.value ? "Loading... " : "Add Product",
                function: () {
                  controller.isLoading.value ? null : controller.add_product();
                },
              )
            ],
          );
        }),
      ),
    );
  }
}
