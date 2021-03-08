import 'package:bytebank/models/contact.dart';
import 'package:flutter/material.dart';

class Transfer {
  int id;
  double value;
  Contact contact;

  Transfer({
    this.id,
    @required this.value,
    @required this.contact,
  });

  @override
  String toString() {
    return 'Transfer{id: $id, value: $value, contact: $contact}';
  }
}
