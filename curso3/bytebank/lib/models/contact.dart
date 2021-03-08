import 'package:flutter/material.dart';

class Contact {
  int id;
  String name;
  int accountNumber;

  Contact({
    this.id,
    @required this.name,
    @required this.accountNumber,
  });

  @override
  String toString() {
    return 'Contact{id: $id, name: $name, accountNumber: $accountNumber}';
  }
}
