import 'package:flutter/material.dart';

typedef PushRouteWidget = Widget Function();

abstract class Utils {
  static void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  static Future<T> pushRoute<T extends Object>(BuildContext context, PushRouteWidget widget) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => widget()),
    );
  }

  static void pop<T extends Object>(BuildContext context, [T result]) {
    return Navigator.of(context).pop(result);
  }
}
