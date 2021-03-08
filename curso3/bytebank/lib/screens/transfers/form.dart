import 'package:bytebank/components/text_editor.dart';
import 'package:bytebank/database/dao/dao_factory.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/models/transfer.dart';
import 'package:flutter/material.dart';

const _labelAppBarCreate = 'New Transfer';
const _labelValue = 'Value';
const _hintValue = '0,00';
const _requiredValue = 'Value is required!';
const _invalidValue = 'Invalid value!';
const _labelButtonCreate = 'Create';

class TransferForm extends StatefulWidget {
  final Contact contact;
  TransferForm({
    @required this.contact,
  });

  @override
  _TransferFormState createState() {
    return _TransferFormState();
  }
}

class _TransferFormState extends State<TransferForm> {
  final TextEditingController _valueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_labelAppBarCreate)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextEditor(
              labelText: _labelValue,
              controller: _valueController,
              fontSize: 24.0,
              hintText: _hintValue,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  child: Text(_labelButtonCreate),
                  onPressed: () => _saveTransfer(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void _saveTransfer(BuildContext context) {
    final String value = _valueController.text;

    if (value == null || value.length == 0) {
      _showSnackbar(context, _requiredValue);
      return;
    }

    final double valueDouble = double.tryParse(value);
    if (valueDouble == null) {
      _showSnackbar(context, _invalidValue);
      return;
    }

    Transfer transfer = Transfer(value: valueDouble, contact: widget.contact);
    _persistTransfer(transfer);
  }

  Future<void> _persistTransfer(Transfer transfer) async {
    try {
      await DaoFactory.getTransferDao().save(transfer);
      Navigator.pop(context, transfer);
    } catch (e) {
      debugPrint('$e');
      _showSnackbar(context, 'Ocorreu um erro: $e');
    }
  }
}
