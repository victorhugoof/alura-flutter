import 'package:bytebank/service/base_service.dart';
import 'package:bytebank/service/impl/transaction_service.dart';

typedef ServiceCreator<T> = T Function();

abstract class ServiceFactory {
  static final Map<Type, dynamic> _instances = {};

  static T _getService<T extends BaseService>(ServiceCreator<T> _creator) {
    Type type = T;
    if (!_instances.containsKey(type)) {
      _instances[type] = _creator();
    }

    return _instances[type];
  }

  static TransactionService getTransactionService() {
    return _getService<TransactionService>(() => TransactionService());
  }
}
