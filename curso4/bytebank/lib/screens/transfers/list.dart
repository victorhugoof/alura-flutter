import 'package:bytebank/components/centered_error.dart';
import 'package:bytebank/components/centered_message.dart';
import 'package:bytebank/components/progress.dart';
import 'package:bytebank/dao/dao_factory.dart';
import 'package:bytebank/helper/utils.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:bytebank/screens/transfers/form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const _labelAppBar = 'Transactions';
const _messageTransactionCreated = 'Transaction created successfully!';
const _listErrorText = 'Unknown error';
const _listEmptyText = 'No contacts found';

class TransferList extends StatefulWidget {
  @override
  _TransferListState createState() {
    return _TransferListState();
  }
}

class _TransferListState extends State<TransferList> {
  List<Contact> _contacts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_labelAppBar)),
      body: FutureBuilder<void>(
        future: _listContacts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Progress();
          }

          if (snapshot.hasError) {
            return CenteredError(
              error: snapshot.error,
              errorText: _listErrorText,
            );
          }

          if (_contacts == null || _contacts.isEmpty) {
            return CenteredMessage(
              message: _listEmptyText,
              icon: Icons.warning,
            );
          }

          return ListView.builder(
            itemCount: _contacts.length,
            itemBuilder: (context, index) {
              final isLast = index == _contacts.length - 1;
              final contact = _contacts[index];
              return _ContactItem(
                contact: contact,
                padding: EdgeInsets.only(bottom: isLast ? 72 : 0),
                onClick: () => _newTransaction(context, contact),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _newContactAndTransaction(context),
      ),
    );
  }

  Future<void> _listContacts() async {
    if (this._contacts == null) {
      this._contacts = await DaoFactory.getContactDao().findAll();
    }
  }

  void _newTransaction(BuildContext context, Contact contact) {
    Utils.pushRoute<Transaction>(context, () => TransactionForm(contact: contact)).then((value) {
      if (value != null) {
        Utils.showSnackbar(context, _messageTransactionCreated);
      }
    });
  }

  void _newContactAndTransaction(BuildContext context) {
    Utils.pushRoute<Transaction>(context, () => TransactionForm(contact: null)).then((value) {
      if (value != null) {
        setState(() {
          this._contacts.add(value.contact);
          Utils.showSnackbar(context, _messageTransactionCreated);
        });
      }
    });
  }
}

class _ContactItem extends StatelessWidget {
  final Contact contact;
  final EdgeInsetsGeometry padding;
  final void Function() onClick;

  _ContactItem({
    @required this.contact,
    @required this.padding,
    @required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Card(
        child: ListTile(
          onTap: () => onClick(),
          title: Text(
            contact.name,
            style: TextStyle(fontSize: 24.0),
          ),
          subtitle: Text(
            contact.accountNumber.toString(),
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}
