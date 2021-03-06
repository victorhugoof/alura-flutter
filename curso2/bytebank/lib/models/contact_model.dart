import 'package:flutter/material.dart';

class ContactModel {
  String name;
  int accountNumber;

  ContactModel({
    @required this.name,
    @required this.accountNumber,
  });

  @override
  String toString() {
    return 'ContactModel{name: $name, accountNumber: $accountNumber}';
  }
}
