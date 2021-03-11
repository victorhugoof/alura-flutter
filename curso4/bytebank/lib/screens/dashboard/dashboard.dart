import 'package:bytebank/helper/utils.dart';
import 'package:bytebank/screens/contacts/list.dart';
import 'package:bytebank/screens/transactions/list.dart';
import 'package:bytebank/screens/transfers/list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const _labelAppBar = 'Dashboard';
const _assetBytebankImage = 'images/bytebank_logo.png';
const _labelButtonTransaction = 'Transfer';
const _labelButtonTransactionFeed = 'Transaction Feed';
const _labelButtonContacts = 'Contacts';

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
            padding: const EdgeInsets.all(4.0),
            child: Container(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  DashboardButton(
                    icon: Icons.monetization_on,
                    title: _labelButtonTransaction,
                    onPressed: () => _showTransferList(context),
                  ),
                  DashboardButton(
                    icon: Icons.description,
                    title: _labelButtonTransactionFeed,
                    onPressed: () => _showTransactionFeed(context),
                  ),
                  DashboardButton(
                    icon: Icons.people,
                    title: _labelButtonContacts,
                    onPressed: () => _showContactList(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _showTransferList(BuildContext context) {
    Utils.pushRoute(context, () => TransferList());
  }

  _showTransactionFeed(BuildContext context) {
    Utils.pushRoute(context, () => TransactionList());
  }

  _showContactList(BuildContext context) {
    Utils.pushRoute(context, () => ContactList());
  }
}

class DashboardButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final EdgeInsets padding;
  final VoidCallback onPressed;

  DashboardButton({
    @required this.icon,
    @required this.title,
    this.padding = const EdgeInsets.all(4.0),
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: padding,
      child: Material(
        color: theme.primaryColor,
        borderRadius: BorderRadius.circular(5),
        child: InkWell(
          onTap: onPressed,
          child: Container(
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
