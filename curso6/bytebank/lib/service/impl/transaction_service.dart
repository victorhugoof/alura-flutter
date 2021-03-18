import 'dart:convert';

import 'package:bytebank/models/transaction.dart';
import 'package:bytebank/service/base_service.dart';
import 'package:http/http.dart';

class TransactionService extends BaseService {
  Future<List<Transaction>> findAll() async {
    final Response response = await super.get('/transactions');
    final List<dynamic> result = jsonDecode(response.body);
    return result.map((e) => Transaction.fromJson(e)).toList();
  }

  Future<Transaction> save(Transaction transaction, String password) async {
    await Future.delayed(Duration(seconds: 2));
    final Response response = await super.post('/transactions', body: transaction.toJson(), headers: {
      'password': password,
    });
    return Transaction.fromJson(jsonDecode(response.body));
  }
}
