import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomEmpty extends StatelessWidget {
  const CustomEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/empty.png',
          height: 300,
        ),
        Text(
          "Nothing Found In Here",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 30,
          ),
        ),
        Center(
          child: Text(
            "Explore to show here...",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w200,
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
