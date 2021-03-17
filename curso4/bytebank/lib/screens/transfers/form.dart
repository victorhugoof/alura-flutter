import 'package:bytebank/components/auth_dialog.dart';
import 'package:bytebank/components/error_dialog.dart';
import 'package:bytebank/components/progress.dart';
import 'package:bytebank/components/text_editor.dart';
import 'package:bytebank/dao/dao_factory.dart';
import 'package:bytebank/exception/business_exception.dart';
import 'package:bytebank/helper/utils.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:bytebank/service/service_factory.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

const _labelAppBarCreate = 'New Transaction';
const _labelAppBarCreateContactAndTransaction = 'New Contact and Transaction';
const _labelName = 'Full name';
const _requiredName = 'Name is required!';
const _hintName = 'Full name';
const _labelAccountNumber = 'Account number';
const _hintAccountNumber = '0000';
const _requiredAccountNumber = 'Account number is required!';
const _invalidAccountNumber = 'Invalid account number! Use only numbers';
const _labelValue = 'Value';
const _hintValue = '0.00';
const _requiredValue = 'Value is required!';
const _invalidValue = 'Invalid value!';
const _labelButtonSending = 'Sending...';
const _labelButtonTransfer = 'Transfer';
const _labelButtonCreateContactAndTransfer = 'Create contact and transfer';

class TransactionForm extends StatefulWidget {
  final Contact contact;

  TransactionForm({
    @required this.contact,
  });

  @override
  _TransactionFormState createState() {
    return _TransactionFormState(this.contact);
  }
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  final String uuid = Uuid().v4();
  bool _sending = false;
  Contact _contact;

  _TransactionFormState(this._contact);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_contact != null ? _labelAppBarCreate : _labelAppBarCreateContactAndTransaction)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: _sending,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Progress(),
                ),
              ),
              ..._getContactForm(context),
              TextEditor(
                labelText: _labelValue,
                controller: _valueController,
                fontSize: 24.0,
                hintText: _hintValue,
                margin: const EdgeInsets.only(top: 16.0),
                keyboardType: TextInputType.number,
                readOnly: _sending,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    child: Text(_sending
                        ? _labelButtonSending
                        : (_contact != null ? _labelButtonTransfer : _labelButtonCreateContactAndTransfer)),
                    onPressed: _sending ? null : () => _save(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _getContactForm(BuildContext context) {
    if (_contact != null) {
      return [
        Text(
          _contact.name,
          style: TextStyle(
            fontSize: 24.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            _contact.accountNumber.toString(),
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ];
    }

    return [
      TextEditor(
        labelText: _labelName,
        controller: _nameController,
        fontSize: 24.0,
        hintText: _hintName,
        margin: const EdgeInsets.only(),
        readOnly: _sending,
      ),
      TextEditor(
        labelText: _labelAccountNumber,
        controller: _accountNumberController,
        fontSize: 24.0,
        hintText: _hintAccountNumber,
        keyboardType: TextInputType.number,
        margin: const EdgeInsets.only(top: 16.0),
        readOnly: _sending,
      )
    ];
  }

  void _save(BuildContext context) {
    FocusScope.of(context).unfocus();

    if (_validateForm()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (contextDialog) => AuthDialog(
          onConfirm: (password, localAuth) async {
            try {
              if (localAuth) {
                password = '1000';
              }

              _showLoading();
              final value = await _saveTransaction(context, password);
              Navigator.pop(context, value);
            } catch (e, s) {
              Utils.logError(e, s);
              _hideLoading();
              showDialog(context: context, builder: (contextDialog) => ErrorDialog(error: e));
            }
          },
        ),
      );
    }
  }

  void _showLoading() {
    setState(() {
      _sending = true;
    });
  }

  void _hideLoading() {
    setState(() {
      _sending = false;
    });
  }

  Future<Transaction> _saveTransaction(BuildContext context, String password) async {
    if (_contact == null) {
      _contact = await _saveContact(context);
    }

    final double value = double.tryParse(_valueController.text);

    Transaction transaction = await ServiceFactory.getTransactionService().save(
        Transaction(
          id: uuid,
          value: value,
          contact: _contact,
        ),
        password);

    if (transaction != null) {
      transaction.contact.id = _contact.id;
    }

    return transaction;
  }

  Future<Contact> _saveContact(BuildContext context) async {
    final String name = _nameController.text;
    final int accountNumber = int.tryParse(_accountNumberController.text);

    Contact contact = Contact(name: name, accountNumber: accountNumber);
    await DaoFactory.getContactDao().save(contact);
    return contact;
  }

  bool _validateForm() {
    try {
      if (_contact == null) {
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
      }

      final String value = _valueController.text;
      if (value == null || value.length == 0) {
        throw BusinessException(_requiredValue);
      }

      final double valueDouble = double.tryParse(value);
      if (valueDouble == null) {
        throw BusinessException(_invalidValue);
      }
    } catch (e, s) {
      Utils.logError(e, s);
      Utils.showSnackbarError(context, e);
      return false;
    }
    return true;
  }
}
