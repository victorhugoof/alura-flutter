import 'package:bytebank/dao/dao.dart';
import 'package:bytebank/dao/impl/contact_dao.dart';

typedef DaoCreator<T> = T Function();

abstract class DaoFactory {
  static final Map<Type, dynamic> _instances = {};

  static T _getDao<T extends Dao>(DaoCreator<T> _creator) {
    Type type = T;
    if (!_instances.containsKey(type)) {
      _instances[type] = _creator();
    }

    return _instances[type];
  }

  static List<Dao> getAll() {
    return [
      getContactDao(),
    ];
  }

  static ContactDao getContactDao() {
    return _getDao<ContactDao>(() => ContactDao());
  }
}
