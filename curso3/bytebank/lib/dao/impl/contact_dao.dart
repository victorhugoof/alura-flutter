import 'package:bytebank/dao/dao.dart';
import 'package:bytebank/models/contact.dart';
import 'package:sqflite_common/sqlite_api.dart';

class ContactDao extends Dao {
  @override
  Future<void> onCreate(Database database, int version) async {
    await database.execute(' CREATE TABLE contacts( '
        '                       id INTEGER PRIMARY KEY, '
        '                       name TEXT, '
        '                       account_number INTEGER '
        '                    )');
  }

  Future<List<Contact>> findAll() async {
    final db = await getDb();

    try {
      final rs = await db.query('contacts', orderBy: 'id ASC');
      return rs.map(_fromMap).toList();
    } finally {
      await db.close();
    }
  }

  Future<Contact> findById(int id) async {
    final db = await getDb();

    try {
      final rs = await db.query('contacts', where: 'id = ?', whereArgs: [id], orderBy: 'id ASC');
      if (rs.length > 0) {
        return _fromMap(rs.first);
      }
      return null;
    } finally {
      await db.close();
    }
  }

  Future<void> save(Contact contact) async {
    final db = await getDb();

    try {
      if (contact.id != null) {
        final dbContact = (await db.query('contacts', columns: ['id'], where: 'id = ?', whereArgs: [contact.id]));
        if (dbContact.isNotEmpty) {
          await db.update('contacts', _toMap(contact), where: 'id = ?', whereArgs: [contact.id]);
          return;
        }
      }

      final id = await db.insert('contacts', _toMap(contact));
      contact.id = id;
    } finally {
      await db.close();
    }
  }

  Future<void> delete(Contact contact) async {
    final db = await getDb();

    try {
      if (contact.id != null) {
        await db.delete('contacts', where: 'id = ?', whereArgs: [contact.id]);
      }
    } finally {
      await db.close();
    }
  }

  Contact _fromMap(Map<String, dynamic> map) {
    final id = map['id'] as int;
    final name = map['name'] as String;
    final accountNumber = map['account_number'] as int;

    return Contact(id: id, name: name, accountNumber: accountNumber);
  }

  Map<String, dynamic> _toMap(Contact contact) {
    return {
      'id': contact.id,
      'name': contact.name,
      'account_number': contact.accountNumber,
    };
  }
}
