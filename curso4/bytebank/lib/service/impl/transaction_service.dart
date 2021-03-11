import 'dart:convert';

import 'package:bytebank/models/transaction.dart';
import 'package:bytebank/service/service.dart';
import 'package:http/http.dart';

class TransactionService extends Service {
  Future<List<Transaction>> findAll() async {
    final Response response = await super.get('/transactions');
    final List<dynamic> result = jsonDecode(response.body);
    return result.map((e) => Transaction.fromJson(e)).toList();
  }

  Future<Transaction> save(Transaction transaction) async {
    final Response response = await super.post('/transactions', body: transaction.toJson(), headers: {
      'password': '1000',
    });
    return Transaction.fromJson(jsonDecode(response.body));
  }
}
