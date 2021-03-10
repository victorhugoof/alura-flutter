import 'package:bytebank/components/centered_message.dart';
import 'package:flutter/material.dart';

class CenteredError extends StatelessWidget {
  final Object error;
  final String errorText;

  CenteredError({
    @required this.error,
    @required this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return CenteredMessage(
      message: errorText,
      legend: '$error',
      icon: Icons.error,
    );
  }
}
