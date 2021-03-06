import 'package:bytebank/models/contact.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const _dbName = 'bytebank.db';
const _dbVersion = 1;

Future<Database> createDatabase() async {
  final String dbPath = await getDatabasesPath();
  final String path = join(dbPath, _dbName);

  return await openDatabase(
    path,
    version: _dbVersion,
    onConfigure: onConfigure,
    onCreate: onCreate,
    onUpgrade: onUpgrade,
    onDowngrade: onDowngrade,
    onOpen: onOpen,
  );
}

Future<void> onConfigure(Database database) async {
  // onConfigure event
}

Future<void> onCreate(Database database, int version) async {
  // onCreate event
  await createContactsTable(database);
}

Future<void> onUpgrade(Database database, int oldVersion, int newVersion) async {
  // onUpgrade event
}

Future<void> onDowngrade(Database data, int oldVersion, int newVersion) async {
  // onDowngrade event
}

Future<void> onOpen(Database database) async {
  // onOpen event
}

Future<void> createContactsTable(Database database) async {
  await database.execute(' CREATE TABLE contacts( '
      '                       id INTEGER PRIMARY KEY, '
      '                       name TEXT, '
      '                       account_number INTEGER '
      '                    )');
}

Future<List<Contact>> listContacts() async {
  final db = await createDatabase();

  try {
    final rs = await db.query('contacts');

    return rs.map((e) {
      final id = e['id'] as int;
      final name = e['name'] as String;
      final accountNumber = e['account_number'] as int;

      return Contact(id: id, name: name, accountNumber: accountNumber);
    }).toList();
  } finally {
    await db.close();
  }
}

Future<void> saveContact(Contact contact) async {
  final db = await createDatabase();

  try {
    if (contact.id != null) {
      final dbContact = (await db.query('contacts', columns: ['id'], where: 'id = ?', whereArgs: [contact.id]));
      if (dbContact.isNotEmpty) {
        await db.update('contacts', _getContactMap(contact), where: 'id = ?', whereArgs: [contact.id]);
        return;
      }
    }

    final id = await db.insert('contacts', _getContactMap(contact));
    contact.id = id;
  } finally {
    await db.close();
  }
}

Future<void> deleteContact(Contact contact) async {
  final db = await createDatabase();

  try {
    if (contact.id != null) {
      await db.delete('contacts', where: 'id = ?', whereArgs: [contact.id]);
    }
  } finally {
    await db.close();
  }
}

Map<String, dynamic> _getContactMap(Contact contact) {
  return {
    'id': contact.id,
    'name': contact.name,
    'account_number': contact.accountNumber,
  };
}
