import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButtonWidget extends StatelessWidget {
  final String? buttonText;
  final Function()? function;
  const CustomButtonWidget({super.key, this.buttonText, this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xFF00623B)),
        width: double.infinity,
        child: Center(
          child: Text(
            buttonText!,
            style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ButtonLessWidget extends StatelessWidget {
  IconData icon_button;
  String buttonText;
  final Function()? function;

  ButtonLessWidget(
      {super.key,
      required this.icon_button,
      required this.buttonText,
      required this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                icon_button,
                size: 30,
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Text(
                  buttonText,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(
                width: 130,
              ),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
