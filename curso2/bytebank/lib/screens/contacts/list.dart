import 'package:bytebank/database/app_database.dart';
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

class ContactList extends StatefulWidget {
  @override
  _ContactListState createState() {
    return _ContactListState();
  }
}

class _ContactListState extends State<ContactList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_labelAppBar)),
      body: FutureBuilder<List<Contact>>(
        future: listContacts(),
        builder: (context, snapshot) {
          print(snapshot.connectionState);
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

          if (snapshot.hasError) {
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
                      'Ocorreu um erro ao tentar listar os contatos!',
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

          final List<Contact> contacts = snapshot.hasData ? snapshot.data : [];
          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final isLast = index == contacts.length - 1;
              return _ContactItem(
                contact: contacts[index],
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

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _editOrCreate(BuildContext context, Contact contact) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContactForm(editing: contact)),
    ).then((value) {
      if (value != null) {
        if (contact == null) {
          setState(() {});
        }
        _showSnackbar(context, contact == null ? _messageContactCreated : _messageContactEdited);
      }
    });
  }

  void _delete(BuildContext context, Contact contact) {
    if (contact != null) {
      deleteContact(contact).then((value) {
        setState(() {});
        _showSnackbar(context, _messageContactDeleted);
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
                const PopupMenuItem<String>(value: 'edit', child: Text(_labelButtonEdit)),
                const PopupMenuItem<String>(value: 'delete', child: Text(_labelButtonDelete)),
              ];
            },
          ),
        ),
      ),
    );
  }
}
