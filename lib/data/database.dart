import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final todoTable = 'todo_table';

class DatabaseProvider {
  static final DatabaseProvider provder = DatabaseProvider();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await createDatabase();
    return _database!;
  }

  createDatabase() async {
    String test = await getDatabasesPath();
    String path = join(await getDatabasesPath(), 'todo.db');

    var database = await openDatabase(path,
        version: 1, onCreate: initDB, onUpgrade: onUpgrade);
    return database;
  }

  void onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {
      //TODO :: migration
    }
  }

  void initDB(Database database, int version) async {
    await database.execute("CREATE TABLE $todoTable ("
        "id INTEGER PRIMARY KEY, "
        "title TEXT, "
        "description TEXT,"
        "state INTEGER, "
        "created_time INTEGER"
        ")");
  }
}
