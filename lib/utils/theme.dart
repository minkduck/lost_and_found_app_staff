import 'package:flutter/material.dart';
import 'package:lost_and_found_app_staff/utils/colors.dart';
import 'package:lost_and_found_app_staff/utils/text_theme.dart';

class TAppTheme {
  TAppTheme._();


  static ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.teal,
    brightness: Brightness.light,
    textTheme: TTextTheme.lightTextTheme,
    cardColor: AppColors.cardLightColor,
    iconTheme: IconThemeData(
        color: Colors.black
    ),
    appBarTheme: AppBarTheme(),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.white
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(),
    elevatedButtonTheme:
    ElevatedButtonThemeData(style: ElevatedButton.styleFrom()),
  );


  static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.backgroundDarkTheme,
    primarySwatch: Colors.teal,
    brightness: Brightness.dark,
    textTheme: TTextTheme.darkTextTheme,
    cardColor: AppColors.cardDarkColor,
    iconTheme: IconThemeData(
      color: Colors.white
    ),
    appBarTheme: AppBarTheme(),
    buttonTheme: ButtonThemeData(
        buttonColor: AppColors.cardDarkColor
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(),
    elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom()),
  );
}