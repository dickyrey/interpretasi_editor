import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interpretasi_editor/src/common/colors.dart';
import 'package:interpretasi_editor/src/common/const.dart';

ThemeData themeLight(BuildContext context) {
  return ThemeData(
    brightness: Brightness.light,
    primaryIconTheme: const IconThemeData(
      color: ColorLight.fontTitle,
      size: 20,
    ),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: ColorLight.primary,
      onPrimary: ColorLight.primary,
      secondary: ColorLight.secondary,
      onSecondary: ColorLight.secondary,
      error: ColorLight.error,
      onError: ColorLight.error,
      background: ColorLight.background,
      onBackground: ColorLight.background,
      surface: ColorLight.background,
      onSurface: ColorLight.background,
    ),
    primaryColor: ColorLight.primary,
    cardColor: ColorLight.card,
    disabledColor: ColorLight.disabled,
    hintColor: ColorLight.hint,
    indicatorColor: ColorLight.primary,
    buttonTheme: ButtonThemeData(
      disabledColor: ColorLight.disabledButton,
      buttonColor: ColorLight.primary,
      height: 45,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Const.radius),
      ),
    ),
    iconTheme: const IconThemeData(color: ColorLight.fontTitle),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: ColorLight.primary,
    ),
    scaffoldBackgroundColor: ColorLight.background,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
    ),
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      headlineLarge: GoogleFonts.poppins(
        color: ColorLight.fontTitle,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      headlineMedium: GoogleFonts.poppins(
        color: ColorLight.fontTitle,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      headlineSmall: GoogleFonts.poppins(
        color: ColorLight.fontTitle,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      labelLarge: GoogleFonts.poppins(
        color: ColorLight.fontTitle,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: GoogleFonts.poppins(
        color: ColorLight.fontTitle,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: GoogleFonts.poppins(
        color: ColorLight.fontTitle,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      titleLarge: GoogleFonts.poppins(
        color: ColorLight.fontTitle,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      titleMedium: GoogleFonts.poppins(
        color: ColorLight.fontTitle,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
      titleSmall: GoogleFonts.poppins(
        color: ColorLight.fontTitle,
        fontSize: 10,
        fontWeight: FontWeight.normal,
      ),
      bodyLarge: GoogleFonts.poppins(
        color: ColorLight.fontSubtitle,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: GoogleFonts.poppins(
        color: ColorLight.fontSubtitle,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
      bodySmall: GoogleFonts.poppins(
        color: ColorLight.fontSubtitle,
        fontSize: 10,
        fontWeight: FontWeight.normal,
      ),
    ),
  );
}

ThemeData themeDark(BuildContext context) {
  return ThemeData(
    brightness: Brightness.dark,
    primaryIconTheme: const IconThemeData(
      color: ColorDark.fontTitle,
      size: 20,
    ),
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: ColorDark.primary,
      onPrimary: ColorDark.primary,
      secondary: ColorDark.secondary,
      onSecondary: ColorDark.secondary,
      error: ColorDark.error,
      onError: ColorDark.error,
      background: ColorDark.background,
      onBackground: ColorDark.background,
      surface: ColorDark.background,
      onSurface: ColorDark.background,
    ),
    primaryColor: ColorDark.primary,
    cardColor: ColorDark.card,
    disabledColor: ColorDark.disabled,
    hintColor: ColorDark.hint,
    indicatorColor: ColorDark.primary,
    buttonTheme: ButtonThemeData(
      disabledColor: ColorDark.disabledButton,
      buttonColor: ColorDark.primary,
      height: 45,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Const.radius),
      ),
    ),
    iconTheme: const IconThemeData(color: ColorDark.fontTitle),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: ColorDark.primary,
    ),
    scaffoldBackgroundColor: ColorDark.background,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
    ),
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      headlineLarge: GoogleFonts.poppins(
        color: ColorDark.fontTitle,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      headlineMedium: GoogleFonts.poppins(
        color: ColorDark.fontTitle,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      headlineSmall: GoogleFonts.poppins(
        color: ColorDark.fontTitle,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      labelLarge: GoogleFonts.poppins(
        color: ColorDark.fontTitle,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: GoogleFonts.poppins(
        color: ColorDark.fontTitle,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: GoogleFonts.poppins(
        color: ColorDark.fontTitle,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      titleLarge: GoogleFonts.poppins(
        color: ColorDark.fontTitle,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      titleMedium: GoogleFonts.poppins(
        color: ColorDark.fontTitle,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
      titleSmall: GoogleFonts.poppins(
        color: ColorDark.fontTitle,
        fontSize: 10,
        fontWeight: FontWeight.normal,
      ),
      bodyLarge: GoogleFonts.poppins(
        color: ColorDark.fontSubtitle,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: GoogleFonts.poppins(
        color: ColorDark.fontSubtitle,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
      bodySmall: GoogleFonts.poppins(
        color: ColorDark.fontSubtitle,
        fontSize: 10,
        fontWeight: FontWeight.normal,
      ),
    ),
  );
}
