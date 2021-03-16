import 'package:bytebank/components/centered_error.dart';
import 'package:bytebank/components/centered_message.dart';
import 'package:bytebank/components/progress.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:bytebank/service/service_factory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const _labelAppBar = 'Transaction Feed';
const _listErrorText = 'Unknown error';
const _listEmptyText = 'No transactions found';

class TransactionList extends StatefulWidget {
  @override
  _TransactionListState createState() {
    return _TransactionListState();
  }
}

class _TransactionListState extends State<TransactionList> {
  List<Transaction> _transactions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_labelAppBar)),
      body: FutureBuilder<void>(
        future: _listTransactions(),
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

          if (_transactions == null || _transactions.isEmpty) {
            return CenteredMessage(
              message: _listEmptyText,
              icon: Icons.warning,
            );
          }

          return ListView.builder(
            itemCount: _transactions.length,
            itemBuilder: (contextItemBuilder, index) {
              return _TransactionItem(transaction: _transactions[index]);
            },
          );
        },
      ),
    );
  }

  Future<void> _listTransactions() async {
    if (this._transactions == null) {
      this._transactions = await ServiceFactory.getTransactionService().findAll();
    }
  }
}

class _TransactionItem extends StatelessWidget {
  final Transaction transaction;

  _TransactionItem({
    @required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.monetization_on),
        title: Text(
          transaction.value.toStringAsFixed(2),
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          transaction.contact.accountNumber.toString(),
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
