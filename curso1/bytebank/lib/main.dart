import 'package:bytebank/screens/transferencia/lista.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(BytebankApp());
}

class BytebankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.green[900];
    final accentColor = Colors.blueAccent[700];

    return MaterialApp(
      theme: ThemeData(
        primaryColor: primaryColor,
        accentColor: accentColor,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateColor.resolveWith((states) => accentColor),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: accentColor),
      ),
      home: ListaTransferencia(),
    );
  }
}
