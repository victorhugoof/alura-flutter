import 'package:bytebank/models/transferencia.dart';
import 'package:flutter/material.dart';

class ItemTransferencia extends StatelessWidget {
  final Transferencia transferencia;

  ItemTransferencia({
    @required this.transferencia,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          Icons.monetization_on,
          color: Theme.of(context).primaryColor,
          size: 36,
        ),
        title: Text(transferencia.valorStr),
        subtitle: Text('Conta: ${transferencia.contaFormat}'),
      ),
    );
  }
}
