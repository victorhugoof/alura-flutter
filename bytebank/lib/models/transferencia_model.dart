import 'package:flutter/material.dart';

class TransferenciaModel {
  int numeroConta;
  String digitoConta;
  double valor;

  TransferenciaModel({
    @required this.numeroConta,
    @required this.digitoConta,
    @required this.valor,
  });

  String get valorStr {
    return valor.toStringAsFixed(2).replaceAll(',', '').replaceAll('.', ',');
  }

  String get contaFormat {
    return numeroConta.toString() + '-' + digitoConta;
  }

  @override
  String toString() {
    return 'Transferencia{numeroConta: $numeroConta, digitoConta: $digitoConta, valor: $valor}';
  }
}
