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

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'],
      name: json['name'],
      accountNumber: json['accountNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'accountNumber': accountNumber,
    };
  }

  @override
  String toString() {
    return 'Contact{id: $id, name: $name, accountNumber: $accountNumber}';
  }
}
