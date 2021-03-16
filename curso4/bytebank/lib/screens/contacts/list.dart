import 'package:bytebank/components/centered_error.dart';
import 'package:bytebank/components/centered_message.dart';
import 'package:bytebank/components/progress.dart';
import 'package:bytebank/dao/dao_factory.dart';
import 'package:bytebank/helper/utils.dart';
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
const _listErrorText = 'Unknown error';
const _listEmptyText = 'No contacts found';

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
        builder: (contextFutureBuilder, snapshot) {
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
            itemBuilder: (contextItemBuilder, index) {
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

  void _editOrCreate(BuildContext context, Contact contact) {
    Utils.pushRoute(context, () => ContactForm(editing: contact)).then((value) {
      if (value != null) {
        if (contact == null) {
          setState(() {
            _contacts.add(value);
          });
        }
        Utils.showSnackbar(context, contact == null ? _messageContactCreated : _messageContactEdited);
      }
    });
  }

  void _delete(BuildContext context, Contact contact) {
    if (contact != null) {
      DaoFactory.getContactDao().delete(contact).then((value) {
        setState(() {
          if (_contacts.remove(contact)) {
            Utils.showSnackbar(context, _messageContactDeleted);
          }
        });
      }).catchError((e, s) {
        Utils.logError(e, s);
        Utils.showSnackbar(context, '$e');
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
            itemBuilder: (contextItemBuilder) {
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
