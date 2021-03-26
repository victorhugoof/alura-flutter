import 'package:bytebank/components/progress.dart';
import 'package:flutter/material.dart';

class CenteredProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final progressSize = (MediaQuery.of(context).size.width * 0.3).roundToDouble();

    return Center(
      child: Progress(
        size: progressSize,
      ),
    );
  }
}
