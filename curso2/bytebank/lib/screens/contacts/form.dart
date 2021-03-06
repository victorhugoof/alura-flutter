import 'package:bytebank/components/text_editor.dart';
import 'package:bytebank/database/app_database.dart';
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

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _saveContact(BuildContext context) {
    final String name = _nameController.text;
    final String accountNumber = _accountNumberController.text;

    if (name == null || name.length == 0) {
      _showSnackbar(context, _requiredName);
      return;
    }

    if (accountNumber == null || accountNumber.length == 0) {
      _showSnackbar(context, _requiredAccountNumber);
      return;
    }

    final int accountNumberInt = int.tryParse(accountNumber);
    if (accountNumberInt == null) {
      _showSnackbar(context, _invalidAccountNumber);
      return;
    }

    final Contact contact = _createOrChangeContact(name, accountNumberInt);
    saveContact(contact).then((e) => Navigator.pop(context, contact)).catchError((er) {
      debugPrint('$er');
      _showSnackbar(context, 'Ocorreu um erro: $er');
    });
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
