import 'package:bytebank/components/auth_dialog.dart';
import 'package:bytebank/components/response_dialog.dart';
import 'package:bytebank/components/text_editor.dart';
import 'package:bytebank/dao/dao_factory.dart';
import 'package:bytebank/exception/business_exception.dart';
import 'package:bytebank/exception/service_exception.dart';
import 'package:bytebank/helper/utils.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:bytebank/service/service_factory.dart';
import 'package:flutter/material.dart';

import '../../exception/business_exception.dart';

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
const _labelButtonTransfer = 'Transfer';
const _labelButtonCreateContactAndTransfer = 'Create contact and transfer';

class TransactionForm extends StatefulWidget {
  final Contact contact;

  TransactionForm({
    @required this.contact,
  });

  @override
  _TransactionFormState createState() {
    return _TransactionFormState();
  }
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(widget.contact != null ? _labelAppBarCreate : _labelAppBarCreateContactAndTransaction)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ..._getContactForm(context),
              TextEditor(
                labelText: _labelValue,
                controller: _valueController,
                fontSize: 24.0,
                hintText: _hintValue,
                margin: const EdgeInsets.only(top: 16.0),
                keyboardType: TextInputType.number,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    child: Text(widget.contact != null ? _labelButtonTransfer : _labelButtonCreateContactAndTransfer),
                    onPressed: () => _save(context),
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
    if (widget.contact != null) {
      return [
        Text(
          widget.contact.name,
          style: TextStyle(
            fontSize: 24.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            widget.contact.accountNumber.toString(),
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
      ),
      TextEditor(
        labelText: _labelAccountNumber,
        controller: _accountNumberController,
        fontSize: 24.0,
        hintText: _hintAccountNumber,
        keyboardType: TextInputType.number,
        margin: const EdgeInsets.only(top: 16.0),
      )
    ];
  }

  void _save(BuildContext context) {
    FocusScope.of(context).unfocus();
    showDialog(
      context: context,
      builder: (contextDialog) => AuthDialog(
        onConfirm: (password, localAuth) async {
          try {
            if (localAuth) {
              password = '1000';
            }

            final value = await _saveTransaction(context, password);
            Navigator.pop(context, value);
          } catch (e, s) {
            Utils.logError(e, s);

            if (e is BusinessException) {
              Utils.showSnackbar(context, e.message);
            } else {
              String _message = '$e';
              if (e is ServiceException) {
                if (e.reason != null) {
                  _message = e.reason;
                } else if (e.message != null) {
                  _message = e.message;
                } else {
                  _message = 'There was an error';
                }
              }

              showDialog(context: context, builder: (contextDialog) => FailureDialog(_message));
            }
          }
        },
      ),
    );
  }

  Future<Transaction> _saveTransaction(BuildContext context, String password) async {
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

    Transaction transaction = await ServiceFactory.getTransactionService().save(
        Transaction(
          value: valueDouble,
          contact: _contact,
        ),
        password);

    if (transaction != null) {
      /* Esta alteração é feita por conta do mapeamento do banco de dados, para o contato retornado possuir ID */
      transaction.contact = _contact;
    }

    return transaction;
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
