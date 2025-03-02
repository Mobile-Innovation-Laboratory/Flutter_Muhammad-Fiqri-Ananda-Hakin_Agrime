import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextfield extends StatelessWidget {
  final TextEditingController? editingController;
  final String? hintText;
  final String? textValue;
  final TextInputType? keyboardType;
  final bool? isPasswordField;
  const CustomTextfield({
    super.key,
    this.isPasswordField,
    this.keyboardType,
    this.editingController,
    required this.hintText,
    this.textValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          obscureText: isPasswordField ?? false,
          keyboardType: keyboardType,
          controller: editingController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.blue, width: 5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.blue, width: 5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xff344e41),
              ),
            ),
            // prefixIcon: iconData != null ? Icon(iconData) : null,
            hintText: hintText,
            hintStyle:
                GoogleFonts.roboto(fontWeight: FontWeight.w300, fontSize: 14),
          ),
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}
