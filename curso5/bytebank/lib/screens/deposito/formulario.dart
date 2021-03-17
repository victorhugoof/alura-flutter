import 'package:bytebank/components/editor.dart';
import 'package:bytebank/models/saldo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const _labelAppBar = 'Depósito';
const _labelValor = 'Valor';
const _hintValor = '0,00';
const _prefixValor = 'R\$ ';
const _requiredValor = 'Valor é obrigatório!';
const _invalidValor = 'Valor inválido! Utilize somente números separados por vírgula';
const _labelButtonConfirm = 'Confirmar';

class FormularioDeposito extends StatelessWidget {
  final TextEditingController _controladorCampoValor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_labelAppBar)),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
              onPressed: () => _salvaDeposito(context),
            ),
          ],
        ),
      ),
    );
  }

  void _salvaDeposito(BuildContext context) {
    try {
      final double valor = _getValor();

      _getSaldo(context).add(valor);
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

  Saldo _getSaldo(BuildContext context) {
    return Provider.of<Saldo>(context, listen: false);
  }

  double _getValor() {
    final String valor = _controladorCampoValor.text;

    if (valor == null || valor.length == 0) {
      throw FormatException(_requiredValor, valor);
    }

    final double valorDouble = double.tryParse(valor.replaceAll('.', '').replaceAll(',', '.'));
    if (valorDouble == null || valorDouble < 0) {
      throw FormatException(_invalidValor, valor);
    }

    return valorDouble;
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
