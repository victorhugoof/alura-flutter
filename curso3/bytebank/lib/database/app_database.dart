import 'package:bytebank/database/dao/dao_factory.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const _dbName = 'bytebank.db';
const _dbVersion = 1;
bool _deleted = true;

Future<Database> createDatabase() async {
  await Sqflite.setDebugModeOn();
  final String dbPath = await getDatabasesPath();
  final String path = join(dbPath, _dbName);

  try {
    if (!_deleted) {
      await deleteDatabase(path);
      _deleted = true;
    }
  } catch (ignored) {}

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
  for (var dao in DaoFactory.getAll()) {
    await dao.onCreate(database, version);
  }
}

Future<void> onUpgrade(Database database, int oldVersion, int newVersion) async {
  for (var dao in DaoFactory.getAll()) {
    await dao.onUpgrade(database, oldVersion, newVersion);
  }
}

Future<void> onDowngrade(Database database, int oldVersion, int newVersion) async {
  for (var dao in DaoFactory.getAll()) {
    await dao.onDowngrade(database, oldVersion, newVersion);
  }
}

Future<void> onOpen(Database database) async {
  // onOpen event
}
