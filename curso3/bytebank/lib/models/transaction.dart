import 'package:bytebank/models/contact.dart';
import 'package:flutter/material.dart';

class Transaction {
  final String id;
  double value;
  Contact contact;
  DateTime dateTime;

  Transaction({
    this.id,
    @required this.value,
    @required this.contact,
    this.dateTime,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      value: json['value'],
      contact: Contact.fromJson(json['contact']),
      dateTime: DateTime.tryParse(json['dateTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
      'contact': contact.toJson(),
      'dateTime': dateTime != null ? dateTime.toIso8601String() : null,
    };
  }

  @override
  String toString() {
    return 'Transaction{id: $id, value: $value, contact: $contact, dateTime: $dateTime}';
  }
}
