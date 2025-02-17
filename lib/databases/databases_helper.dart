import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DatabasesHelper {
  DatabasesHelper._();

  static final _dbHelper = DatabasesHelper._();
  Database? _db;

  DatabasesHelper get db {
    if (_db != null) {
      return _dbHelper;
    } else {
      init();
      return _dbHelper;
    }
  }

  void init() async {
    _db = await openDatabase(
      path.join(await getDatabasesPath(), 'YannVanneth.db'),
      onCreate: (db, version) {
        if (version == 1) {
          db.execute('''
            CREATE TABLE wishlists(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              product_id INTEGER
            )
           ''');

          db.execute('''
            CREATE TABLE carts(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              product_id INTEGER,
              colour TEXT,
              quantity INTEGER
            )
           ''');

          db.execute('''
            CREATE TABLE users(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              firstName TEXT,
              lastName TEXT,
              username TEXT,
              password TEXT
            )
           ''');
        }
      },
    );
  }
}
