import 'package:flutter/material.dart';

class Progress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final progressWidth = (MediaQuery.of(context).size.width * 0.4).roundToDouble();
    final strokeWidth = progressWidth / 20;

    return Center(
      child: SizedBox(
        height: progressWidth,
        width: progressWidth,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
        ),
      ),
    );
  }
}
