import 'package:bytebank/dao/dao_factory.dart';
import 'package:bytebank/main.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class BaseDao {
  Future<void> onCreate(Database dao, int version);

  Future<void> onUpgrade(Database dao, int oldVersion, int newVersion) async {}

  Future<void> onDowngrade(Database dao, int oldVersion, int newVersion) async {}

  Future<Database> getDb() async {
    return _AppDatabase.createDatabase();
  }
}

class _AppDatabase {
  static Future<Database> createDatabase() async {
    await Sqflite.setDebugModeOn();
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, dbName);

    return await openDatabase(
      path,
      version: dbVersion,
      onConfigure: onConfigure,
      onCreate: onCreate,
      onUpgrade: onUpgrade,
      onDowngrade: onDowngrade,
      onOpen: onOpen,
    );
  }

  static Future<void> onConfigure(Database dao) async {
    // onConfigure event
  }

  static Future<void> onCreate(Database database, int version) async {
    for (var dao in DaoFactory.getAll()) {
      await dao.onCreate(database, version);
    }
  }

  static Future<void> onUpgrade(Database database, int oldVersion, int newVersion) async {
    for (var dao in DaoFactory.getAll()) {
      await dao.onUpgrade(database, oldVersion, newVersion);
    }
  }

  static Future<void> onDowngrade(Database database, int oldVersion, int newVersion) async {
    for (var dao in DaoFactory.getAll()) {
      await dao.onDowngrade(database, oldVersion, newVersion);
    }
  }

  static Future<void> onOpen(Database dao) async {
    // onOpen event
  }
}
