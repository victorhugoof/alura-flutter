import 'package:flutter/material.dart';

class Transferencia {
  final int numeroConta;
  final String digitoConta;
  final double valor;

  Transferencia({
    @required this.numeroConta,
    @required this.digitoConta,
    @required this.valor,
  });

  String get valorStr {
    final String doubleFormatted = valor.toStringAsFixed(2).replaceAll(',', '').replaceAll('.', ',');
    return 'R\$ $doubleFormatted';
  }

  String get contaFormat {
    return numeroConta.toString() + '-' + digitoConta;
  }

  @override
  String toString() {
    return '$valorStr -> $contaFormat';
  }
}
