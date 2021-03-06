import 'package:bytebank/database/app_database.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/screens/contacts/form.dart';
import 'package:flutter/material.dart';

const _labelAppBar = 'Contacts';
const _messageContactCreated = 'Contact created successfully!';
const _messageContactEdited = 'Contact edited successfully!';
const _messageContactDeleted = 'Contact deleted successfully!';
const _labelButtonEdit = 'Edit';
const _labelButtonDelete = 'Delete';

class ContactList extends StatefulWidget {
  final List<Contact> _contacts = <Contact>[];

  @override
  _ContactListState createState() {
    return _ContactListState();
  }
}

class _ContactListState extends State<ContactList> {
  @override
  Widget build(BuildContext context) {
    _loadContacts();

    return Scaffold(
      appBar: AppBar(title: Text(_labelAppBar)),
      body: ListView.builder(
        itemCount: widget._contacts.length,
        itemBuilder: (context, index) => ContactItem(
          contact: widget._contacts[index],
          onEdit: (contact) => _editOrCreate(contact),
          onDelete: (contact) => _delete(contact),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _editOrCreate(null),
      ),
    );
  }

  void _loadContacts() {
    if (widget._contacts.length == 0) {
      listContacts().then((value) {
        setState(() {
          widget._contacts.addAll(value);
        });
      }).catchError((er) {
        debugPrint('$er');
        _showSnackbar(context, 'Ocorreu um erro: $er');
      });
    }
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _editOrCreate(Contact contact) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContactForm(editing: contact)),
    ).then((value) {
      if (value != null) {
        setState(() {
          if (contact == null) {
            widget._contacts.add(value);
          }
          _showSnackbar(context, contact != null ? _messageContactEdited : _messageContactCreated);
        });
      }
    });
  }

  void _delete(Contact contact) {
    if (contact != null) {
      deleteContact(contact).then((value) {
        setState(() {
          widget._contacts.remove(contact);
          _showSnackbar(context, _messageContactDeleted);
        });
      }).catchError((er) {
        debugPrint('$er');
        _showSnackbar(context, 'Ocorreu um erro: $er');
      });
    }
  }
}

class ContactItem extends StatelessWidget {
  final Contact contact;
  final void Function(Contact value) onEdit;
  final void Function(Contact value) onDelete;

  ContactItem({
    @required this.contact,
    @required this.onEdit,
    @required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          contact.name,
          style: TextStyle(
            fontSize: 24.0,
          ),
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
              const PopupMenuItem<String>(
                value: 'edit',
                child: Text(_labelButtonEdit),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text(_labelButtonDelete),
              ),
            ];
          },
        ),
      ),
    );
  }
}
