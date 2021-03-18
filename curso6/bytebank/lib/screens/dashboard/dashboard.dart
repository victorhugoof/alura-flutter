import 'package:bytebank/helper/utils.dart';
import 'package:bytebank/screens/contacts/list.dart';
import 'package:bytebank/screens/name.dart';
import 'package:bytebank/screens/transactions/list.dart';
import 'package:bytebank/screens/transfers/list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _labelAppBar = 'Welcome';
const _assetBytebankImage = 'images/bytebank_logo.png';
const _labelButtonTransaction = 'Transfer';
const _labelButtonTransactionFeed = 'Transaction Feed';
const _labelButtonContacts = 'Contacts';

class DashboardContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NameCubit('Victor Hugo'),
      child: DashboardView(),
    );
  }
}

class DashboardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final name = context.watch<NameCubit>().state;

    return Scaffold(
      appBar: AppBar(
        title: Text('$_labelAppBar $name'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
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
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
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
                  DashboardButton(
                    icon: Icons.person_outline,
                    title: 'Change name',
                    onPressed: () => _showChangeName(context),
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

  _showChangeName(BuildContext context) {
    Utils.pushRoute(context, () {
      return BlocProvider.value(
        value: context.read<NameCubit>(),
        child: NameContainer(),
      );
    });
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
