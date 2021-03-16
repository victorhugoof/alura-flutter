import 'package:bytebank/components/text_editor.dart';
import 'package:bytebank/dao/dao_factory.dart';
import 'package:bytebank/helper/utils.dart';
import 'package:bytebank/models/contact.dart';
import 'package:flutter/material.dart';

const _labelAppBarCreate = 'New Contact';
const _labelAppBarChange = 'Edit Contact';
const _labelName = 'Full name';
const _requiredName = 'Name is required!';
const _hintName = 'Full name';
const _labelAccountNumber = 'Account number';
const _hintAccountNumber = '0000';
const _requiredAccountNumber = 'Account number is required!';
const _invalidAccountNumber = 'Invalid account number! Use only numbers';
const _labelButtonCreate = 'Create';
const _labelButtonEdit = 'Save';

class ContactForm extends StatefulWidget {
  final Contact editing;

  ContactForm({this.editing});

  @override
  _ContactFormState createState() {
    return _ContactFormState();
  }
}

class _ContactFormState extends State<ContactForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.editing != null) {
      _nameController.text = widget.editing.name;
      _accountNumberController.text = widget.editing.accountNumber.toString();
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.editing != null ? _labelAppBarChange : _labelAppBarCreate)),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  child: Text(widget.editing != null ? _labelButtonEdit : _labelButtonCreate),
                  onPressed: () => _saveContact(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveContact(BuildContext context) {
    final String name = _nameController.text;
    final String accountNumber = _accountNumberController.text;

    if (name == null || name.length == 0) {
      Utils.showSnackbar(context, _requiredName);
      return;
    }

    if (accountNumber == null || accountNumber.length == 0) {
      Utils.showSnackbar(context, _requiredAccountNumber);
      return;
    }

    final int accountNumberInt = int.tryParse(accountNumber);
    if (accountNumberInt == null) {
      Utils.showSnackbar(context, _invalidAccountNumber);
      return;
    }

    _persistContact(context, _createOrChangeContact(name, accountNumberInt));
  }

  Future<void> _persistContact(BuildContext context, Contact contact) async {
    try {
      await DaoFactory.getContactDao().save(contact);
      Navigator.pop(context, contact);
    } catch (e, s) {
      Utils.logError(e, s);
      Utils.showSnackbar(context, '$e');
    }
  }

  Contact _createOrChangeContact(String name, int accoutNumber) {
    if (widget.editing == null) {
      return Contact(
        name: name,
        accountNumber: accoutNumber,
      );
    }

    widget.editing.name = name;
    widget.editing.accountNumber = accoutNumber;
    return widget.editing;
  }
}
