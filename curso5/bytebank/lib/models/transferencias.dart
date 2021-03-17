import 'package:bytebank/models/transferencia.dart';
import 'package:flutter/material.dart';

class Transferencias extends ChangeNotifier {
  List<Transferencia> _list;

  Transferencias(this._list) : assert(_list != null);

  void add(Transferencia transferencia) {
    this._list.add(transferencia);
    this.notifyListeners();
  }

  int get length {
    return this._list.length;
  }

  bool get isEmpty {
    return this._list.isEmpty;
  }

  Transferencia getReverse(int reversedIndex) {
    return get(length - reversedIndex - 1);
  }

  Transferencia get(int index) {
    if (index < 0 || ((index + 1) > this._list.length)) {
      return null;
    }
    return this._list[index];
  }
}
