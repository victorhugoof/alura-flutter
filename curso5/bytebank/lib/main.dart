import 'package:bytebank/models/saldo.dart';
import 'package:bytebank/models/transferencias.dart';
import 'package:bytebank/screens/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Saldo(0)),
      ChangeNotifierProvider(create: (_) => Transferencias([])),
    ],
    child: BytebankApp(),
  ));
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
      ),
      home: Dashboard(),
    );
  }
}
