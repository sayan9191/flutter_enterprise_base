import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography tokens using Google Fonts Inter.
abstract final class AppTypography {
  static TextTheme textTheme = TextTheme(
    displayLarge: GoogleFonts.inter(fontSize: 57, fontWeight: FontWeight.w400),
    displayMedium: GoogleFonts.inter(fontSize: 45, fontWeight: FontWeight.w400),
    displaySmall: GoogleFonts.inter(fontSize: 36, fontWeight: FontWeight.w400),
    headlineLarge: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w600),
    headlineMedium: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w600),
    headlineSmall: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w600),
    titleLarge: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w600),
    titleMedium: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
    titleSmall: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
    bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400),
    bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400),
    bodySmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400),
    labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
    labelMedium: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
    labelSmall: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500),
  );
}
