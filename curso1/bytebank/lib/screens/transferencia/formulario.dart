import 'package:bytebank/components/editor.dart';
import 'package:bytebank/models/transferencia_model.dart';
import 'package:flutter/material.dart';

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
const _labelButtonConfirm = 'Confirmar';

class FormularioTransferencia extends StatefulWidget {
  final TransferenciaModel editing;
  FormularioTransferencia({this.editing});

  @override
  _FormularioTransferenciaState createState() {
    return _FormularioTransferenciaState();
  }
}

class _FormularioTransferenciaState extends State<FormularioTransferencia> {
  final TextEditingController _controladorCampoNumeroConta = TextEditingController();
  final TextEditingController _controladorCampoDigitoConta = TextEditingController();
  final TextEditingController _controladorCampoValor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.editing != null) {
      _controladorCampoNumeroConta.text = widget.editing.numeroConta.toString();
      _controladorCampoDigitoConta.text = widget.editing.digitoConta;
      _controladorCampoValor.text = widget.editing.valorStr;
    }

    return Scaffold(
      appBar: AppBar(title: Text(_labelAppBar)),
      body: SingleChildScrollView(
        child: Column(
          children: [
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

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _salvaTransferencia(BuildContext context) {
    final String numeroConta = _controladorCampoNumeroConta.text;
    final String digitoConta = _controladorCampoDigitoConta.text;
    final String valor = _controladorCampoValor.text;

    if (numeroConta == null || numeroConta.length == 0) {
      _showSnackbar(context, _requiredNumeroConta);
      return;
    }

    final int numeroContaInt = int.tryParse(numeroConta);
    if (numeroContaInt == null) {
      _showSnackbar(context, _invalidNumeroConta);
      return;
    }

    if (digitoConta == null || digitoConta.length == 0) {
      _showSnackbar(context, _requiredDigitoConta);
      return;
    }

    final int digitoContaInt = int.tryParse(digitoConta);
    if (digitoContaInt == null && 'x' != digitoConta.toLowerCase()) {
      _showSnackbar(context, _invalidDigitoConta);
      return;
    }

    if (valor == null || numeroConta.length == 0) {
      _showSnackbar(context, _requiredValor);
      return;
    }

    final double valorDouble = double.tryParse(valor.replaceAll('.', '').replaceAll(',', '.'));
    if (valorDouble == null) {
      _showSnackbar(context, _invalidValor);
      return;
    }

    final TransferenciaModel transferencia =
        _persistirTransferencia(numeroContaInt, digitoConta.toLowerCase(), valorDouble);
    Navigator.pop(context, transferencia);
  }

  TransferenciaModel _persistirTransferencia(int numeroConta, String digitoConta, double valor) {
    if (widget.editing == null) {
      return TransferenciaModel(
        numeroConta: numeroConta,
        digitoConta: digitoConta.toLowerCase(),
        valor: valor,
      );
    }

    widget.editing.numeroConta = numeroConta;
    widget.editing.digitoConta = digitoConta;
    widget.editing.valor = valor;
    return widget.editing;
  }
}
