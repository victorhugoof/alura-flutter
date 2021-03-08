import 'package:bytebank/database/app_database.dart';
import 'package:bytebank/database/dao/dao.dart';
import 'package:bytebank/database/dao/dao_factory.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/models/transfer.dart';
import 'package:sqflite/sqflite.dart';

class TransferDao extends Dao {
  @override
  Future<void> onCreate(Database database, int version) async {
    await database.execute(' CREATE TABLE transfers( '
        '                       id INTEGER PRIMARY KEY, '
        '                       value NUMERIC(10, 2), '
        '                       contact_id INTEGER '
        '                    )');
  }

  Future<List<Transfer>> findAll() async {
    final db = await createDatabase();

    try {
      final rs = await db.query('transfers', orderBy: 'id ASC');
      return await _fromMapList(rs);
    } finally {
      await db.close();
    }
  }

  Future<void> save(Transfer transfer) async {
    final db = await createDatabase();

    try {
      if (transfer.id != null) {
        final dbTransfer = (await db.query('transfers', columns: ['id'], where: 'id = ?', whereArgs: [transfer.id]));
        if (dbTransfer.isNotEmpty) {
          await db.update('transfers', _toMap(transfer), where: 'id = ?', whereArgs: [transfer.id]);
          return;
        }
      }

      final id = await db.insert('transfers', _toMap(transfer));
      transfer.id = id;
    } finally {
      await db.close();
    }
  }

  Future<void> delete(Transfer transfer) async {
    final db = await createDatabase();

    try {
      if (transfer.id != null) {
        await db.delete('transfers', where: 'id = ?', whereArgs: [transfer.id]);
      }
    } finally {
      await db.close();
    }
  }

  Future<List<Transfer>> _fromMapList(List<Map<String, dynamic>> maps) async {
    List<Transfer> list = [];
    Map<int, Contact> contactsCache = {};
    for (var map in maps) {
      list.add(await _fromMap(map, contactsCache: contactsCache));
    }
    return list;
  }

  Future<Transfer> _fromMap(Map<String, dynamic> map, {Map<int, Contact> contactsCache}) async {
    final id = map['id'] as int;
    final value = (map['value'] as num).toDouble();
    final contactId = map['contact_id'] as int;

    Contact contact;
    if (contactsCache != null) {
      if (contactsCache.containsKey(contactId)) {
        contact = contactsCache[contactId];
      } else {
        contact = await DaoFactory.getContactDao().findById(contactId);
        contactsCache[contactId] = contact;
      }
    } else {
      contact = await DaoFactory.getContactDao().findById(contactId);
    }

    return Transfer(id: id, value: value, contact: contact);
  }

  Map<String, dynamic> _toMap(Transfer transfer) {
    return {
      'id': transfer.id,
      'value': transfer.value,
      'contact_id': transfer.contact.id,
    };
  }
}
