import 'package:bytebank/components/response_dialog.dart';
import 'package:bytebank/helper/utils.dart';
import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final dynamic error;
  final IconData icon;

  ErrorDialog({
    this.title = 'Failure',
    this.error,
    this.message,
    this.icon = Icons.warning,
  });

  @override
  Widget build(BuildContext context) {
    bool getErrorMessage = error != null && (message == null || message.isEmpty);

    return ResponseDialog(
      title: title,
      message: getErrorMessage ? Utils.getErrorMessage(error) : message,
      icon: icon,
      colorIcon: Colors.red,
    );
  }
}
