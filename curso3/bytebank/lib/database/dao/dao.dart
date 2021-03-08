import 'package:sqflite/sqflite.dart';

abstract class Dao {
  Future<void> onCreate(Database database, int version);

  Future<void> onUpgrade(Database database, int oldVersion, int newVersion) async {}

  Future<void> onDowngrade(Database database, int oldVersion, int newVersion) async {}
}
