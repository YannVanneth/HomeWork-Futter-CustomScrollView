import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

import '../data/product.dart';
import '../models/product_model.dart';

class DatabasesHelper {
  DatabasesHelper._();

  static final DatabasesHelper dbHelper = DatabasesHelper._();
  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    String dbPath = path.join(await getDatabasesPath(), 'product.db');
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        // Existing tables
        await db.execute('''
          CREATE TABLE wishlists(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            product_id INTEGER,
            api_featured_image TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE carts(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            product_id INTEGER,
            colour TEXT,
            quantity INTEGER,
            api_featured_image TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            firstName TEXT,
            lastName TEXT,
            username TEXT,
            password TEXT
          )
        ''');
      },
    );
  }

  // Existing methods remain unchanged...

  // New Product Operations
  Future<void> insertProduct(Map<String, dynamic> product) async {
    final db = await database;
    await db.transaction((txn) async {
      // Insert main product
      await txn.insert(
          'products',
          {
            'id': product['id'],
            'brand': product['brand'],
            'name': product['name'],
            'price': double.tryParse(product['price'].toString()),
            'price_sign': product['price_sign'],
            'currency': product['currency'],
            'image_link': product['image_link'],
            'product_link': product['product_link'],
            'website_link': product['website_link'],
            'description': product['description'],
            'rating': product['rating'],
            'category': product['category'],
            'product_type': product['product_type'],
            'created_at': product['created_at'],
            'updated_at': product['updated_at'],
            'product_api_url': product['product_api_url'],
            'api_featured_image': product['api_featured_image'],
          },
          conflictAlgorithm: ConflictAlgorithm.replace);

      // Insert tags
      if (product['tag_list'] != null) {
        for (String tag in product['tag_list']) {
          await txn.insert(
              'product_tags',
              {
                'product_id': product['id'],
                'tag': tag,
              },
              conflictAlgorithm: ConflictAlgorithm.ignore);
        }
      }

      // Insert colors (if any)
      if (product['product_colors'] != null) {
        for (Map<String, dynamic> color in product['product_colors']) {
          await txn.insert('product_colors', {
            'product_id': product['id'],
            'color_name': color['name'],
            'color_value': color['value'],
          });
        }
      }
    });
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await database;
    return await db.query('products');
  }

  Future<Map<String, dynamic>?> getProduct(int productId) async {
    final db = await database;
    final results = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [productId],
    );

    if (results.isEmpty) return null;

    Map<String, dynamic> product = Map.from(results.first);

    // Get tags
    final tags = await db.query(
      'product_tags',
      where: 'product_id = ?',
      whereArgs: [productId],
    );
    product['tag_list'] = tags.map((t) => t['tag']).toList();

    // Get colors
    final colors = await db.query(
      'product_colors',
      where: 'product_id = ?',
      whereArgs: [productId],
    );
    product['product_colors'] = colors
        .map((c) => {
              'name': c['color_name'],
              'value': c['color_value'],
            })
        .toList();

    return product;
  }

  Future<void> deleteProduct(int productId) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('product_tags',
          where: 'product_id = ?', whereArgs: [productId]);
      await txn.delete('product_colors',
          where: 'product_id = ?', whereArgs: [productId]);
      await txn.delete('products', where: 'id = ?', whereArgs: [productId]);
    });
  }

  // Wishlist Operations
  Future<List<Map<String, dynamic>>> readWishlist() async {
    final db = await database;
    return await db.query('wishlists');
  }

  Future<void> addToWishlist(int productId, String imageUrl) async {
    final db = await database;
    await db.insert('wishlists', {
      'product_id': productId,
      'api_featured_image': imageUrl,
    });
  }

  Future<void> removeFromWishlist(int productId) async {
    final db = await database;
    await db.delete(
      'wishlists',
      where: 'product_id = ?',
      whereArgs: [productId],
    );
  }

  // Cart Operations
  Future<List<ProductModel>> readCart() async {
    final db = await database;
    var items = await db.query('carts');

    if (products.isEmpty) return [];

    final getdata = products
        .where((product) =>
            items.any((item) => item['product_id'] == product['id']))
        .toList();

    final productList = getdata.map((product) {
      var cartItem = items.firstWhere(
        (item) => item['product_id'] == product['id'],
        orElse: () => {},
      );

      return ProductModel.fromJSON({
        ...product,
        'quantity': cartItem['quantity'] ?? 1,
        'selected_color': cartItem['colour'] ?? '404',
      });
    }).toList();

    return productList;
  }

  Future<void> addToCart(
      int productId, String colour, int quantity, String imageUrl) async {
    final db = await database;

    await db.insert('carts', {
      'product_id': productId,
      'colour': colour,
      'quantity': quantity,
      'api_featured_image': imageUrl,
    });
  }

  Future<void> removeFromCart(int productId, {String? colour}) async {
    final db = await database;
    if (colour != null) {
      await db.delete(
        'carts',
        where: 'product_id = ? AND colour = ?',
        whereArgs: [productId, colour],
      );
    } else {
      await db.delete(
        'carts',
        where: 'product_id = ?',
        whereArgs: [productId],
      );
    }
  }

  Future<void> updateCartQuantity(
      int productId, String colour, int newQuantity) async {
    final db = await database;
    await db.update(
      'carts',
      {'quantity': newQuantity},
      where: 'product_id = ? AND colour = ?',
      whereArgs: [productId, colour],
    );
  }

  // User Operations
  Future<int> addUser(String firstName, String lastName, String username,
      String password) async {
    final db = await database;
    return await db.insert('users', {
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'password': password, // Note: In production, you should hash passwords
    });
  }

  Future<Map<String, dynamic>?> getUser(String username) async {
    final db = await database;
    final results = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<void> deleteTableData(String tableName) async {
    final db = await database;
    await db.delete(tableName);
  }

  Future<void> init() async {
    await database;
  }
}
