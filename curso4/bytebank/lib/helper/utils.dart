import 'dart:async';

import 'package:bytebank/exception/business_exception.dart';
import 'package:bytebank/exception/service_exception.dart';
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

  static void showSnackbarError(BuildContext context, dynamic error) {
    showSnackbar(context, getErrorMessage(error));
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

  static String getErrorMessage(dynamic e) {
    if (e is BusinessException) {
      return e.message;
    }

    if (e is ServiceException) {
      if (e.reason != null) {
        return e.reason;
      } else if (e.message != null) {
        return e.message;
      } else {
        return 'Unknow error: ${e.statusCode}';
      }
    }

    if (e is TimeoutException) {
      return 'Request timed out';
    }

    return 'There was an error: $e';
  }
}
