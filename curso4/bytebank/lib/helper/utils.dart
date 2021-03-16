import 'package:bytebank/exception/service_exception.dart';
import 'package:flutter/material.dart';

import '../exception/business_exception.dart';

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
    if (e is BusinessException || e is ServiceException) {
      debugPrint('ERROR ${e.runtimeType}: ${e.toString()}');
      return;
    }
    debugPrintStack(label: 'ERROR ${e.runtimeType}: ${e.toString()}', stackTrace: s);
  }
}
