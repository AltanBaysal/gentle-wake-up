import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color charcoalBg = Color(0xFF121214);
  static const Color charcoalCard = Color(0xFF1C1C1F);
  static const Color charcoalCardHover = Color(0xFF242427);
  static const Color textTime = Color(0xFFB0B5BD);
  static const Color textMuted = Color(0xFF636976);
  static const Color textSubtle = Color(0xFF4B5059);
  static const Color mossGreen = Color(0xFF5D7A60);
  static const Color mossLight = Color(0xFF8DA38F);
  static const Color oliveFab = Color(0xFF6B7C65);
  static const Color toggleOff = Color(0xFF2C2C2E);

  static const Color backgroundDark = Color(0xFF1C1C1E);
  static const Color surfaceDark = Color(0xFF2C2C2E);
  static const Color primary = Color(0xFF5F7161);
  static const Color textHighlight = Color(0xFFD1D1D6);
  static const Color textMid = Color(0xFF8E8E93);
  static const Color textDim = Color(0xFF48484A);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: charcoalBg,
      primaryColor: mossGreen,
      colorScheme: const ColorScheme.dark(
        primary: mossGreen,
        secondary: oliveFab,
        surface: charcoalCard,
        background: charcoalBg,
      ),
      fontFamily: GoogleFonts.inter().fontFamily,
      textTheme: TextTheme(
        displayLarge: GoogleFonts.inter(
          color: textTime,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: GoogleFonts.inter(
          color: textHighlight,
        ),
        bodyMedium: GoogleFonts.inter(
          color: textMid,
        ),
      ),
      cardTheme: CardTheme(
        color: charcoalCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 0,
      ),
    );
  }
}
