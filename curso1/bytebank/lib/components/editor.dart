import 'package:flutter/material.dart';

class Editor extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final String errorText;
  final double fontSize;
  final String hintText;
  final Icon icon;
  final TextInputType keyboardType;
  final EdgeInsets margin;
  final int maxLength;
  final String prefixText;

  Editor({
    @required this.labelText,
    this.controller,
    this.errorText,
    this.fontSize = 16.0,
    this.hintText,
    this.icon,
    this.keyboardType,
    this.margin = const EdgeInsets.all(16.0),
    this.maxLength,
    this.prefixText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          icon: icon,
          errorText: errorText,
          labelText: labelText,
          hintText: hintText,
          prefixText: prefixText,
          isDense: true,
          counterText: '',
        ),
        keyboardType: keyboardType,
        maxLength: maxLength,
        style: TextStyle(fontSize: fontSize),
      ),
    );
  }
}
