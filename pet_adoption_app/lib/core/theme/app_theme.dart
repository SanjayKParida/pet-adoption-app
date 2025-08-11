import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Light Theme Colors
  static const Color _lightPrimary = Color(0xFF6B4CE3);
  static const Color _lightBackground = Color(0xFFFAFAFA);
  static const Color _lightSurface = Color(0xFFFFFFFF);
  static const Color _lightOnPrimary = Color(0xFFFFFFFF);
  static const Color _lightOnBackground = Color(0xFF1A1A1A);

  // Dark Theme Colors
  static const Color _darkPrimary = Color(0xFF8B5CF6);
  static const Color _darkBackground = Color(0xFF0F0F23);
  static const Color _darkSurface = Color(0xFF1A1A2E);
  static const Color _darkOnPrimary = Color(0xFFFFFFFF);
  static const Color _darkOnBackground = Color(0xFFE2E8F0);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: _lightPrimary,
        surface: _lightSurface,
        background: _lightBackground,
        onPrimary: _lightOnPrimary,
        onSurface: _lightOnBackground,
        onBackground: _lightOnBackground,
      ),
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        bodyLarge: GoogleFonts.poppins(color: _lightOnBackground),
        bodyMedium: GoogleFonts.poppins(color: _lightOnBackground),
        bodySmall: GoogleFonts.poppins(color: _lightOnBackground),
        titleLarge: GoogleFonts.poppins(color: _lightOnBackground),
        titleMedium: GoogleFonts.poppins(color: _lightOnBackground),
        titleSmall: GoogleFonts.poppins(color: _lightOnBackground),
        headlineLarge: GoogleFonts.poppins(color: _lightOnBackground),
        headlineMedium: GoogleFonts.poppins(color: _lightOnBackground),
        headlineSmall: GoogleFonts.poppins(color: _lightOnBackground),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _lightSurface,
        foregroundColor: _lightOnBackground,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: _lightOnBackground,
        ),
      ),
      cardTheme: CardTheme(
        color: _lightSurface,
        elevation: 8,
        shadowColor: _lightPrimary.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: _lightSurface,
        selectedColor: _lightSurface,
        labelStyle: GoogleFonts.poppins(
          color: _lightOnBackground,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: _lightPrimary.withOpacity(0.3)),
        ),
        elevation: 2,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _lightSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: _lightPrimary.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: _lightPrimary.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: _lightPrimary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        hintStyle: GoogleFonts.poppins(
          color: _lightOnBackground.withOpacity(0.6),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _lightSurface,
        selectedItemColor: _lightPrimary,
        unselectedItemColor: _lightOnBackground.withOpacity(0.6),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: _darkPrimary,
        surface: _darkSurface,
        background: _darkBackground,
        onPrimary: _darkOnPrimary,
        onSurface: _darkOnBackground,
        onBackground: _darkOnBackground,
      ),
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        bodyLarge: GoogleFonts.poppins(color: _darkOnBackground),
        bodyMedium: GoogleFonts.poppins(color: _darkOnBackground),
        bodySmall: GoogleFonts.poppins(color: _darkOnBackground),
        titleLarge: GoogleFonts.poppins(color: _darkOnBackground),
        titleMedium: GoogleFonts.poppins(color: _darkOnBackground),
        titleSmall: GoogleFonts.poppins(color: _darkOnBackground),
        headlineLarge: GoogleFonts.poppins(color: _darkOnBackground),
        headlineMedium: GoogleFonts.poppins(color: _darkOnBackground),
        headlineSmall: GoogleFonts.poppins(color: _darkOnBackground),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _darkSurface,
        foregroundColor: _darkOnBackground,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: _darkOnBackground,
        ),
      ),
      cardTheme: CardTheme(
        color: _darkSurface,
        elevation: 8,
        shadowColor: _darkPrimary.withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: _darkSurface,
        selectedColor: _darkSurface,
        labelStyle: GoogleFonts.poppins(
          color: _darkOnBackground,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: _darkPrimary.withOpacity(0.3)),
        ),
        elevation: 2,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: _darkPrimary.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: _darkPrimary.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: _darkPrimary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        hintStyle: GoogleFonts.poppins(
          color: _darkOnBackground.withOpacity(0.6),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _darkSurface,
        selectedItemColor: _darkPrimary,
        unselectedItemColor: _darkOnBackground.withOpacity(0.6),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
