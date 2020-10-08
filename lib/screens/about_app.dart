import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.deepPurple
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Center(
              child: Text(
                "This app has been developed by Eng Maged Rashed ;)",
                style: GoogleFonts.aclonica(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
