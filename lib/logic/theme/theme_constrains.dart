import 'package:flutter/material.dart';
import 'package:pet_care/logic/theme/theme.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: LightModeColors.mainColor, // White background
    primary: LightModeColors.primaryColor, // Green #00C4B4
    onPrimary: Colors.white, // White text on green background (e.g., for buttons)
    secondary: LightModeColors.secondaryColor, // Pink #FF6F61
    onSecondary: Colors.white, // White text on pink background
    tertiary: LightModeColors.gradientTeal, // Teal #26A69A for gradient
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black, fontFamily: 'Poppins'), // Black text
    bodyMedium: TextStyle(color: Colors.black, fontFamily: 'Poppins'), // Black text
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: DarkModeColors.mainColor, // Dark background
    primary: DarkModeColors.primaryColor, // Green #00C4B4
    onPrimary: Colors.white, // White text on green background
    secondary: DarkModeColors.secondaryColor, // Pink #FF6F61
    onSecondary: Colors.white, // White text on pink background
    tertiary: DarkModeColors.gradientTeal, // Teal #26A69A for gradient
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white, fontFamily: 'Poppins'), // White text
    bodyMedium: TextStyle(color: Colors.white, fontFamily: 'Poppins'), // White text
  ),
);