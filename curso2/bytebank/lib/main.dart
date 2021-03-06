import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        brightness: Brightness.dark,
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

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('images/bytebank_logo.png'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 100,
              width: 150,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.people,
                    color: theme.primaryColorLight,
                    size: 24,
                  ),
                  Text(
                    'Contacts',
                    style: TextStyle(
                      color: theme.primaryColorLight,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              color: theme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
