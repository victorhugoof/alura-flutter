import 'package:bytebank/database/dao/dao_factory.dart';
import 'package:bytebank/models/transfer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const _labelAppBar = 'Transaction Feed';
const _listErrorText = 'An error occurred while listing transactions';

class TransactionList extends StatefulWidget {
  @override
  _TransactionListState createState() {
    return _TransactionListState();
  }
}

class _TransactionListState extends State<TransactionList> {
  List<Transfer> _transfers;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_labelAppBar)),
      body: FutureBuilder<void>(
        future: _listTransfers(),
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

          if (snapshot.hasError || _transfers == null) {
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
                      _listErrorText,
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
            itemCount: _transfers.length,
            itemBuilder: (context, index) {
              return _TransferItem(transfer: _transfers[index]);
            },
          );
        },
      ),
    );
  }

  Future<void> _listTransfers() async {
    if (this._transfers == null) {
      this._transfers = await DaoFactory.getTransferDao().findAll();
    }
  }
}

class _TransferItem extends StatelessWidget {
  final Transfer transfer;

  _TransferItem({
    @required this.transfer,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.monetization_on),
        title: Text(
          transfer.value.toStringAsFixed(2),
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          transfer.contact.accountNumber.toString(),
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
