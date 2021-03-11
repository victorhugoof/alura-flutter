import 'package:flutter/material.dart';

class CenteredMessage extends StatelessWidget {
  final String message;
  final String legend;
  final IconData icon;
  final double iconSize;
  final double fontSize;
  final double legendSize;

  CenteredMessage({
    @required this.message,
    this.legend,
    this.icon,
    this.iconSize = 64,
    this.fontSize = 24,
    this.legendSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Visibility(
            child: Icon(
              icon,
              size: iconSize,
            ),
            visible: icon != null,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Text(
              message,
              style: TextStyle(fontSize: fontSize),
            ),
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
