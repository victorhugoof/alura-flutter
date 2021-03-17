import 'package:bytebank/components/editor.dart';
import 'package:bytebank/models/saldo.dart';
import 'package:bytebank/models/transferencia.dart';
import 'package:bytebank/models/transferencias.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const _labelAppBar = 'Criando Transferência';
const _labelNumeroConta = 'Número Conta';
const _hintNumeroConta = '0000';
const _requiredNumeroConta = 'Número da Conta é obrigatório!';
const _invalidNumeroConta = 'Número da Conta inválido! Utilize somente números';
const _labelDigitoConta = 'Dígito';
const _hintDigitoConta = '1';
const _requiredDigitoConta = 'Dígito da Conta é obrigatório!';
const _invalidDigitoConta = 'Dígito da Conta inválido! Utilize somente números ou \'x\'';
const _labelValor = 'Valor';
const _hintValor = '0,00';
const _prefixValor = 'R\$ ';
const _requiredValor = 'Valor é obrigatório!';
const _invalidValor = 'Valor inválido! Utilize somente números separados por vírgula';
const _invalidSaldo = 'Saldo insuficiente!';
const _labelButtonConfirm = 'Confirmar';
const _messageTransfSalva = 'Transferência salva com sucesso!';
const _labelSaldo = 'Saldo: ';

class FormularioTransferencia extends StatelessWidget {
  final TextEditingController _controladorCampoNumeroConta = TextEditingController();
  final TextEditingController _controladorCampoDigitoConta = TextEditingController();
  final TextEditingController _controladorCampoValor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_labelAppBar)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 8, left: 16, right: 16),
                child: Row(
                  children: [
                    Text(
                      _labelSaldo,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Consumer<Saldo>(
                      builder: (builderContext, saldo, child) {
                        return Text(
                          '$saldo',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 7,
                  child: Editor(
                    controller: _controladorCampoNumeroConta,
                    labelText: _labelNumeroConta,
                    hintText: _hintNumeroConta,
                    keyboardType: TextInputType.number,
                    margin: EdgeInsets.fromLTRB(16, 16, 0, 16),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Editor(
                    labelText: _labelDigitoConta,
                    controller: _controladorCampoDigitoConta,
                    hintText: _hintDigitoConta,
                    maxLength: 1,
                  ),
                ),
              ],
            ),
            Editor(
              labelText: _labelValor,
              controller: _controladorCampoValor,
              icon: Icon(Icons.monetization_on),
              hintText: _hintValor,
              prefixText: _prefixValor,
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              child: Text(_labelButtonConfirm),
              onPressed: () => _salvaTransferencia(context),
            ),
          ],
        ),
      ),
    );
  }

  void _salvaTransferencia(BuildContext context) {
    try {
      final numeroConta = _getNumeroConta();
      final digitoConta = _getDigitoConta();
      final valor = _getValor(context);

      final Transferencia transferencia = Transferencia(
        numeroConta: numeroConta,
        digitoConta: digitoConta.toLowerCase(),
        valor: valor,
      );

      _getSaldo(context).subtract(valor);
      _getTransferencias(context).add(transferencia);
      _showSnackbar(context, _messageTransfSalva);
      Navigator.pop(context);
    } catch (e, s) {
      if (e is FormatException) {
        _showSnackbar(context, e.message);
      } else {
        _showSnackbar(context, '$e');
        debugPrintStack(label: e, stackTrace: s);
      }
    }
  }

  int _getNumeroConta() {
    final String numeroConta = _controladorCampoNumeroConta.text;

    if (numeroConta == null || numeroConta.length == 0) {
      throw FormatException(_requiredNumeroConta, numeroConta);
    }

    final int numeroContaInt = int.tryParse(numeroConta);
    if (numeroContaInt == null || numeroContaInt < 0) {
      throw FormatException(_invalidNumeroConta, numeroConta);
    }

    return numeroContaInt;
  }

  String _getDigitoConta() {
    final String digitoConta = _controladorCampoDigitoConta.text;

    if (digitoConta == null || digitoConta.length == 0) {
      throw FormatException(_requiredDigitoConta, digitoConta);
    }

    final int digitoContaInt = int.tryParse(digitoConta);
    if ((digitoContaInt == null || digitoContaInt < 0) && 'x' != digitoConta.toLowerCase()) {
      throw FormatException(_invalidDigitoConta, digitoConta);
    }

    return digitoConta.toLowerCase();
  }

  double _getValor(BuildContext context) {
    final String valor = _controladorCampoValor.text;

    if (valor == null || valor.length == 0) {
      throw FormatException(_requiredValor, valor);
    }

    final double valorDouble = double.tryParse(valor.replaceAll('.', '').replaceAll(',', '.'));
    if (valorDouble == null || valorDouble < 0) {
      throw FormatException(_invalidValor, valor);
    }

    final double saldo = _getSaldo(context).valor;
    if (valorDouble > saldo) {
      throw FormatException(_invalidSaldo);
    }
    return valorDouble;
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Saldo _getSaldo(BuildContext context) {
    return Provider.of<Saldo>(context, listen: false);
  }

  Transferencias _getTransferencias(BuildContext context) {
    return Provider.of<Transferencias>(context, listen: false);
  }
}
