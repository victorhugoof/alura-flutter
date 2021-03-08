import 'package:bytebank/components/text_editor.dart';
import 'package:bytebank/database/dao/dao_factory.dart';
import 'package:bytebank/exception/business_exception.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/models/transfer.dart';
import 'package:flutter/material.dart';

const _labelAppBarCreate = 'New Transfer';
const _labelName = 'Full name';
const _requiredName = 'Name is required!';
const _hintName = 'Full name';
const _labelAccountNumber = 'Account number';
const _hintAccountNumber = '0000';
const _requiredAccountNumber = 'Account number is required!';
const _invalidAccountNumber = 'Invalid account number! Use only numbers';
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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_labelAppBarCreate)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ..._getContactForm(context),
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
                  onPressed: () => _save(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _getContactForm(BuildContext context) {
    if (widget.contact != null) {
      return [];
    }

    return [
      TextEditor(
        labelText: _labelName,
        controller: _nameController,
        fontSize: 24.0,
        hintText: _hintName,
      ),
      TextEditor(
        labelText: _labelAccountNumber,
        controller: _accountNumberController,
        fontSize: 24.0,
        hintText: _hintAccountNumber,
        keyboardType: TextInputType.number,
      )
    ];
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _save(BuildContext context) {
    _saveTransfer(context).then((value) {
      Navigator.pop(context, value);
    }).catchError((e) {
      debugPrint('$e');
      _showSnackbar(context, '$e');
    });
  }

  Future<Transfer> _saveTransfer(BuildContext context) async {
    Contact _contact = widget.contact;
    if (_contact == null) {
      _contact = await _saveContact(context);
    }

    final String value = _valueController.text;
    if (value == null || value.length == 0) {
      throw BusinessException(_requiredValue);
    }

    final double valueDouble = double.tryParse(value);
    if (valueDouble == null) {
      throw BusinessException(_invalidValue);
    }

    Transfer transfer = Transfer(value: valueDouble, contact: _contact);
    await DaoFactory.getTransferDao().save(transfer);
    return transfer;
  }

  Future<Contact> _saveContact(BuildContext context) async {
    final String name = _nameController.text;
    final String accountNumber = _accountNumberController.text;

    if (name == null || name.length == 0) {
      throw BusinessException(_requiredName);
    }

    if (accountNumber == null || accountNumber.length == 0) {
      throw BusinessException(_requiredAccountNumber);
    }

    final int accountNumberInt = int.tryParse(accountNumber);
    if (accountNumberInt == null) {
      throw BusinessException(_invalidAccountNumber);
    }

    Contact contact = Contact(name: name, accountNumber: accountNumberInt);
    await DaoFactory.getContactDao().save(contact);
    return contact;
  }
}
