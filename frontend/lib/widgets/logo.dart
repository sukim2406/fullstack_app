import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.dosis(
          fontSize: 45,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: 'MUSK',
            style: GoogleFonts.dosis(
              color: Colors.red,
            ),
          ),
          TextSpan(
            text: '-',
            style: GoogleFonts.dosis(
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: 'AT',
            style: GoogleFonts.dosis(
              color: Colors.grey,
            ),
          ),
          TextSpan(
            text: '-',
            style: GoogleFonts.dosis(
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: 'TWEETER',
            style: GoogleFonts.dosis(
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
