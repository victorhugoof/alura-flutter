import 'package:bytebank/components/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

const _title = 'Authenticate';
const _cancelText = 'Cancel';
const _confirmText = 'Confirm';

class AuthDialog extends StatefulWidget {
  final Function(String password, bool localAuth) onConfirm;
  AuthDialog({
    this.onConfirm,
  });

  @override
  _AuthDialogState createState() => _AuthDialogState();
}

class _AuthDialogState extends State<AuthDialog> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _localAuth(),
      initialData: false,
      builder: (contextFutureBuilder, snapshot) {
        if (snapshot.connectionState != ConnectionState.done || snapshot.data) {
          if (snapshot.data) {
            _confirm(true);
          }

          return LoadingDialog(title: _title);
        }

        return AlertDialog(
          title: Text(_title),
          content: TextField(
            controller: _passwordController,
            obscureText: true,
            maxLength: 4,
            style: TextStyle(
              fontSize: 64,
              letterSpacing: 24,
            ),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              child: Text(_cancelText),
              onPressed: _cancel,
            ),
            TextButton(
              child: Text(_confirmText),
              onPressed: () => _confirm(false),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _localAuth() async {
    bool success = false;
    try {
      final localAuth = LocalAuthentication();
      success = await localAuth.authenticate(
        localizedReason: _title,
        biometricOnly: true,
      );
    } catch (ignored) {}

    return success;
  }

  void _cancel() {
    Navigator.pop(context);
  }

  void _confirm(bool localAuth) {
    if (this.widget.onConfirm != null) {
      this.widget.onConfirm(_passwordController.value.text, localAuth);
    }
    Navigator.pop(context);
  }
}
