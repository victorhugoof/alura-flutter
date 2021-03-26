import 'package:bytebank/components/progress.dart';
import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  final String title;
  final String message;

  LoadingDialog({
    this.title = "",
    this.message = "",
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Visibility(
        child: Text(title),
        visible: title != null && title.isNotEmpty,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Progress(
              size: 64,
              message: message,
              fontSize: 20,
            ),
          )
        ],
      ),
    );
  }
}
