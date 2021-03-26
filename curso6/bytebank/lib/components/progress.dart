import 'package:flutter/material.dart';

class Progress extends StatelessWidget {
  final String message;
  final String legend;
  final double size;
  double strokeWidth;
  final double fontSize;
  final double legendSize;

  Progress({
    this.message = "",
    this.legend = "",
    this.size = 96,
    this.strokeWidth,
    this.fontSize = 32,
    this.legendSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    if (this.strokeWidth == null) {
      this.strokeWidth = size / 20;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: size,
            width: size,
            child: CircularProgressIndicator(
              strokeWidth: strokeWidth,
              valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),
          ),
          Visibility(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                message,
                style: TextStyle(fontSize: fontSize),
              ),
            ),
            visible: message != null && message.isNotEmpty,
          ),
          Visibility(
            child: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                legend == null ? '' : legend,
                style: TextStyle(fontSize: legendSize),
              ),
            ),
            visible: legend != null && legend.isNotEmpty,
          ),
        ],
      ),
    );
  }
}
