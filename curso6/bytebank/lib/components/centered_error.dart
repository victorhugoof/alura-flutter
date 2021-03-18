import 'package:bytebank/components/centered_message.dart';
import 'package:bytebank/helper/utils.dart';
import 'package:flutter/material.dart';

class CenteredError extends StatelessWidget {
  final dynamic error;

  CenteredError({
    @required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return CenteredMessage(
      message: Utils.getErrorMessage(error),
      icon: Icons.warning,
      iconColor: Colors.red,
    );
  }
}
