import 'package:bytebank/screens/dashboard/saldo_card.dart';
import 'package:bytebank/screens/deposito/formulario.dart';
import 'package:bytebank/screens/transferencia/formulario.dart';
import 'package:bytebank/screens/transferencia/ultimas.dart';
import 'package:flutter/material.dart';

const _labelAppBar = 'ByteBank';
const _labelButtonReceberDeposito = 'Receber Depósito';
const _labelButtonCriarTransferencia = 'Criar Transferência';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(_labelAppBar),
      ),
      body: ListView(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: SaldoCard(),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text(_labelButtonReceberDeposito),
                style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith((states) => Theme.of(context).primaryColor),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => FormularioDeposito()),
                  );
                },
              ),
              ElevatedButton(
                child: Text(_labelButtonCriarTransferencia),
                style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith((states) => Theme.of(context).primaryColor),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => FormularioTransferencia()),
                  );
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: UltimasTransferencias(),
          ),
        ],
      ),
    );
  }
}
