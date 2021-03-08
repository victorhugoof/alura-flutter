import 'package:bytebank/database/dao/dao_factory.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/screens/transfers/form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const _labelAppBar = 'Transfers';
const _messageTransferCreated = 'Transfer created successfully!';
const _listErroText = 'An error occurred while list contacts!';

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
            final progressWidth = (MediaQuery.of(context).size.width * 0.4).roundToDouble();
            final strokeWidth = progressWidth / 20;

            return Center(
              child: SizedBox(
                height: progressWidth,
                width: progressWidth,
                child: CircularProgressIndicator(
                  strokeWidth: strokeWidth,
                  valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                ),
              ),
            );
          }

          if (snapshot.hasError || _contacts == null) {
            final error = snapshot.error;
            return FractionallySizedBox(
              heightFactor: 1,
              widthFactor: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 96),
                      child: Icon(
                        Icons.error,
                        size: 120,
                      ),
                    ),
                    Text(
                      _listErroText,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Text(
                        '$error',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: _contacts.length,
            itemBuilder: (context, index) {
              final isLast = index == _contacts.length - 1;
              return _ContactItem(
                contact: _contacts[index],
                padding: EdgeInsets.only(bottom: isLast ? 72 : 0),
                onClick: (contact) => _newTransfer(context, contact),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _newContactAndTransfer(context),
      ),
    );
  }

  Future<void> _listContacts() async {
    if (this._contacts == null) {
      this._contacts = await DaoFactory.getContactDao().findAll();
    }
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

  void _newTransfer(BuildContext context, Contact contact) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TransferForm(contact: contact)),
    ).then((value) {
      _showSnackbar(context, _messageTransferCreated);
    });
  }

  void _newContactAndTransfer(BuildContext context) {
    print('new contact and transfer');
  }
}

class _ContactItem extends StatelessWidget {
  final Contact contact;
  final EdgeInsetsGeometry padding;
  final void Function(Contact contact) onClick;

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
          onTap: () => onClick(contact),
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
