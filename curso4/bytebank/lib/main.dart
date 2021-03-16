import 'package:flutter/material.dart';

import 'screens/dashboard/dashboard.dart';

const dbName = 'bytebank.db';
const dbVersion = 1;

void main() {
  runApp(BytebankApp());
}

class BytebankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.green[900];
    final primaryColorLight = Colors.white;
    final accentColor = Colors.blueAccent[700];

    return MaterialApp(
      theme: ThemeData.light().copyWith(
        primaryColor: primaryColor,
        primaryColorLight: primaryColorLight,
        accentColor: accentColor,
        appBarTheme: AppBarTheme(
          brightness: Brightness.dark,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateColor.resolveWith((states) => accentColor),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: accentColor),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateColor.resolveWith((states) => primaryColor),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: primaryColor,
          selectionColor: primaryColor,
          selectionHandleColor: primaryColor,
        ),
      ),
      home: Dashboard(),
    );
  }
}
