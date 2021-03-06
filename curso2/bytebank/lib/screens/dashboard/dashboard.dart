import 'package:bytebank/screens/contacts/list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const _labelAppBar = 'Dashboard';
const _assetBytebankImage = 'images/bytebank_logo.png';
const _labelButtonContacts = 'Contacts';
const _labelButtonNew = 'New';
const _labelButtonSetttings = 'Settings';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_labelAppBar),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.asset(_assetBytebankImage),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4.0, 8.0, 4.0, 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  DashboardButton(
                    icon: Icons.people,
                    title: _labelButtonContacts,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ContactList()),
                      );
                    },
                  ),
                  DashboardButton(icon: Icons.add, title: _labelButtonNew, onPressed: () {}),
                  DashboardButton(icon: Icons.settings, title: _labelButtonSetttings, onPressed: () {}),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DashboardButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onPressed;

  DashboardButton({
    @required this.icon,
    @required this.title,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4.0),
      child: Material(
        color: theme.primaryColor,
        borderRadius: BorderRadius.circular(5),
        child: InkWell(
          onTap: onPressed,
          child: Container(
            height: 100,
            width: 150,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: theme.primaryColorLight,
                  size: 24,
                ),
                Text(
                  title,
                  style: TextStyle(
                    color: theme.primaryColorLight,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
