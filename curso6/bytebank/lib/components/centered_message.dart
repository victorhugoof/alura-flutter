import 'package:flutter/material.dart';

class CenteredMessage extends StatelessWidget {
  final String message;
  final String legend;
  final IconData icon;
  final Color iconColor;
  final double iconSize;
  final double fontSize;
  final double legendSize;

  CenteredMessage({
    @required this.message,
    this.legend,
    this.icon,
    this.iconColor,
    this.iconSize = 96,
    this.fontSize = 32,
    this.legendSize = 16,
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
              color: iconColor,
            ),
            visible: icon != null,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
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
