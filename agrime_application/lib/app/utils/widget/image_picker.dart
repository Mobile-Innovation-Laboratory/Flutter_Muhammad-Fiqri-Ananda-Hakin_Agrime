import 'package:agrime_application/app/utils/widget_controllers/image_picker_controller.dart';
import 'package:get/get.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PickImage extends StatelessWidget {
  final ImageController controller = Get.put(ImageController());
  PickImage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.pickImage();
      },
      child: SizedBox(
        width: 350,
        height: 100,
        child: DottedBorder(
            borderType: BorderType.RRect,
            radius: const Radius.circular(12),
            color: Colors.grey,
            child: Obx(() {
              return controller.status.value
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                            child: Text(
                          "Image Uploaded",
                          style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey),
                        )),
                        const Icon(
                          Icons.check,
                          size: 40,
                          color: Colors.grey,
                        )
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                            child: Text(
                          "Change Images",
                          style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey),
                        )),
                        const Icon(
                          Icons.add_circle_outline,
                          size: 40,
                          color: Colors.grey,
                        )
                      ],
                    );
            })),
      ),
    );
  }
}
