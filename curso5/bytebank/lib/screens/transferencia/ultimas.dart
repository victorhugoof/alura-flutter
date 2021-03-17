import 'package:bytebank/models/transferencias.dart';
import 'package:bytebank/screens/transferencia/item.dart';
import 'package:bytebank/screens/transferencia/lista.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const _titulo = 'Últimas Transferências';
const _labelButtonListaTransferencias = 'Visualizar todas transferências';
const _labelSemTransferencias = 'Você ainda não realizou nenhuma transferência!';

class UltimasTransferencias extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          _titulo,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Consumer<Transferencias>(
          builder: (builderContext, lista, child) {
            if (lista.isEmpty) {
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    _labelSemTransferencias,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            final int qtdUltimasTransf = 3;
            return Column(
              children: [
                ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: qtdUltimasTransf,
                  shrinkWrap: true,
                  itemBuilder: (listViewContext, index) {
                    final transferencia = lista.getReverse(index);
                    if (transferencia == null) {
                      return null;
                    }
                    return ItemTransferencia(transferencia: transferencia);
                  },
                ),
                Visibility(
                  visible: lista.length > qtdUltimasTransf,
                  child: ElevatedButton(
                    child: Text(_labelButtonListaTransferencias),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith((states) => Theme.of(context).primaryColor),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => ListaTransferencias()),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
