import 'package:bytebank/database/dao/dao_factory.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/screens/contacts/form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const _labelAppBar = 'Contacts';
const _messageContactCreated = 'Contact created successfully!';
const _messageContactEdited = 'Contact edited successfully!';
const _messageContactDeleted = 'Contact deleted successfully!';
const _labelButtonEdit = 'Edit';
const _labelButtonDelete = 'Delete';
const _listErroText = 'An error occurred while list contacts!';

class ContactList extends StatefulWidget {
  @override
  _ContactListState createState() {
    return _ContactListState();
  }
}

class _ContactListState extends State<ContactList> {
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
                onEdit: (contact) => _editOrCreate(context, contact),
                onDelete: (contact) => _delete(context, contact),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _editOrCreate(context, null),
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
      ),
    );
  }

  void _editOrCreate(BuildContext context, Contact contact) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContactForm(editing: contact)),
    ).then((value) {
      if (value != null) {
        if (contact == null) {
          setState(() {
            _contacts.add(value);
          });
        }
        _showSnackbar(context, contact == null ? _messageContactCreated : _messageContactEdited);
      }
    });
  }

  void _delete(BuildContext context, Contact contact) {
    if (contact != null) {
      DaoFactory.getContactDao().delete(contact).then((value) {
        setState(() {
          if (_contacts.remove(contact)) {
            _showSnackbar(context, _messageContactDeleted);
          }
        });
      }).catchError((er) {
        debugPrint('$er');
        _showSnackbar(context, 'Ocorreu um erro: $er');
      });
    }
  }
}

class _ContactItem extends StatelessWidget {
  final Contact contact;
  final EdgeInsetsGeometry padding;
  final void Function(Contact value) onEdit;
  final void Function(Contact value) onDelete;

  _ContactItem({
    @required this.contact,
    @required this.padding,
    @required this.onEdit,
    @required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Card(
        child: ListTile(
          title: Text(
            contact.name,
            style: TextStyle(fontSize: 24.0),
          ),
          subtitle: Text(
            contact.accountNumber.toString(),
            style: TextStyle(fontSize: 16.0),
          ),
          trailing: PopupMenuButton<String>(
            onSelected: (result) {
              if (result == 'edit') {
                onEdit(contact);
              } else if (result == 'delete') {
                onDelete(contact);
              }
            },
            itemBuilder: (context) {
              return <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'edit',
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(Icons.edit),
                      ),
                      Text(_labelButtonEdit),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(Icons.delete),
                      ),
                      Text(_labelButtonDelete),
                    ],
                  ),
                ),
              ];
            },
          ),
        ),
      ),
    );
  }
}
