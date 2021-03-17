import 'package:bytebank/models/transferencias.dart';
import 'package:bytebank/screens/transferencia/formulario.dart';
import 'package:bytebank/screens/transferencia/item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const _labelAppBar = 'Transferências';

class ListaTransferencias extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_labelAppBar),
      ),
      body: Consumer<Transferencias>(
        builder: (builderContext, lista, child) {
          return ListView.builder(
            itemCount: lista.length,
            itemBuilder: (context, index) => ItemTransferencia(transferencia: lista.get(index)),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => FormularioTransferencia()),
          );
        },
      ),
    );
  }
}
