import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DatabasesHelper {
  DatabasesHelper._();

  static final dbHelper = DatabasesHelper._();
  Database? db;

  void deleteTableData(String tableName) async {
    db = await openDatabase(
      path.join(await getDatabasesPath(), 'product.db'),
      version: 1,
    );

    db!.delete(tableName);
  }

  void init() async {
    db = await openDatabase(
      path.join(await getDatabasesPath(), 'product.db'),
      version: 1,
      onCreate: (db, version) {
        if (version == 1) {
          db.execute('''
            CREATE TABLE wishlists(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              product_id INTEGER,
              api_featured_image TEXT
            )
           ''');

          // db.execute('''
          //   CREATE TABLE wishlists(
          //     id INTEGER PRIMARY KEY AUTOINCREMENT,
          //     name TEXT,
          //     description TEXT,
          //     product_type TEXT,
          //     price TEXT,
          //     api_featured_image TEXT,
          //     price_sign TEXT,
          //     tag_list TEXT,
          //     product_colors TEXT
          //   )
          //  ''');

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
