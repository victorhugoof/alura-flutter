import 'package:flutter/material.dart';

typedef PushRouteWidget = Widget Function();

abstract class Utils {
  static void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  static Future<T> pushRoute<T extends Object>(BuildContext context, PushRouteWidget widget) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (contextMaterialPageRoute) => widget()),
    );
  }

  static void logError(dynamic e, StackTrace s) {
    debugPrintStack(label: 'ERROR ${e.runtimeType}: ${e.toString()}', stackTrace: s);
  }
}
