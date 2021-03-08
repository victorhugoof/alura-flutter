import 'package:bytebank/database/dao/contact_dao.dart';
import 'package:bytebank/database/dao/dao.dart';
import 'package:bytebank/database/dao/transfer_dao.dart';

abstract class DaoFactory {
  static final Map<Type, dynamic> _instances = {};

  static T _getDao<T extends Dao>() {
    Type type = T;
    if (!_instances.containsKey(type)) {
      _instances[type] = _createInstance(type);
    }

    return _instances[type];
  }

  static List<Dao> getAll() {
    return [
      getContactDao(),
      getTransferDao(),
    ];
  }

  static ContactDao getContactDao() {
    return _getDao<ContactDao>();
  }

  static TransferDao getTransferDao() {
    return _getDao<TransferDao>();
  }

  static Dao _createInstance(Type type) {
    switch (type) {
      case ContactDao:
        return ContactDao();
      case TransferDao:
        return TransferDao();
    }
    throw new Exception('Instantiate exception!');
  }
}
