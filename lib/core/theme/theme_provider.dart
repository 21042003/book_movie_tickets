import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_colors.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.hex000000,
      primaryColor: AppColors.hexFCC434,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.hexFCC434,
        secondary: AppColors.hexFCC434,
        surface: AppColors.hex1C1C1C,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      fontFamily: 'Montserrat',
      useMaterial3: true,
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      primaryColor: AppColors.hexFCC434,
      colorScheme: const ColorScheme.light(
        primary: AppColors.hexFCC434,
        secondary: AppColors.hexFCC434,
        surface: Color(0xFFF5F5F5),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      fontFamily: 'Montserrat',
      useMaterial3: true,
    );
  }
}
