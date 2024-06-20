import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'reminders.db');
    return openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE reminders(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        campus INTEGER,
        day INTEGER,
        time INTEGER,
        reminderId INTEGER
      )
    ''');
  }

  Future<int> updateReminder(int id, Map<String, dynamic> updatedReminder) async {
    try {
      Database db = await database;
      return await db.update('reminders', updatedReminder, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print("Error updating reminder: $e");
      return -1;
    }
  }

  Future<int> insertReminder(Map<String, dynamic> reminder) async {
    Database db = await database;
    return await db.insert('reminders', {...reminder});
  }

  Future<List<Map<String, dynamic>>> getReminders() async {
    Database db = await database;
    return await db.query('reminders');
  }

  Future<int> deleteReminder(int id) async {
    Database db = await database;
    return await db.delete('reminders', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAllReminders() async {
    try {
      Database db = await database;
      await db.transaction((txn) async {
        await txn.execute('DROP TABLE IF EXISTS reminders');

        await txn.execute('''
        CREATE TABLE reminders(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          campus INTEGER,
          day INTEGER,
          time INTEGER,
          reminderId INTEGER
        )
      ''');
      });
    } catch (e) {
      print("Error deleting all reminders: $e");
    }
  }

  Future<bool> canAddReminder() async {
    Database db = await database;
    int count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM reminders')) ?? 0;
    return count < 10;
  }
}