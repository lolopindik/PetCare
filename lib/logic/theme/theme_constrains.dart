import 'package:flutter/material.dart';
import 'package:pet_care/logic/theme/theme.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: LightModeColors.mainColor, // Белый фон
    primary: LightModeColors.primaryColor, // Зеленый #00C4B4
    onPrimary: Colors.white, // Белый текст на зеленом фоне (например, для кнопок)
    secondary: LightModeColors.secondaryColor, // Розовый #FF6F61
    onSecondary: Colors.white, // Белый текст на розовом фоне
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black, fontFamily: 'Poppins',), // Черный текст
    bodyMedium: TextStyle(color: Colors.black, fontFamily: 'Poppins'), // Черный текст
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: DarkModeColors.mainColor, // Темный фон
    primary: DarkModeColors.primaryColor, // Зеленый #00C4B4
    onPrimary: Colors.white, // Белый текст на зеленом фоне
    secondary: DarkModeColors.secondaryColor, // Розовый #FF6F61
    onSecondary: Colors.white, // Белый текст на розовом фоне
    tertiary: Colors.grey, // Оставляем серый как дополнительный цвет
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white, fontFamily: 'Poppins'), // Белый текст
    bodyMedium: TextStyle(color: Colors.white, fontFamily: 'Poppins'), // Белый текст
  ),
);