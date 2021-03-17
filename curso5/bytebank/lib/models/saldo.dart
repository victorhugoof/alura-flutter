import 'package:flutter/material.dart';

class Saldo extends ChangeNotifier {
  double _valor;
  Saldo(this._valor);

  void add(double valor) {
    this._valor += valor;
    this.notifyListeners();
  }

  void subtract(double valor) {
    this._valor -= valor;
    this.notifyListeners();
  }

  double get valor {
    return this._valor;
  }

  @override
  String toString() {
    final String doubleFormatted = _valor.toStringAsFixed(2).replaceAll(',', '').replaceAll('.', ',');
    return 'R\$ $doubleFormatted';
  }
}
