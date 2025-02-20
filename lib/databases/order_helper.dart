// import '../models/products.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

// class OrderSaver {
//   static Database? _database;

//   OrderSaver._();

//   static Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }

//   static Future<Database> _initDatabase() async {
//     String path = join(await getDatabasesPath(), 'orders5.db');
//     return await openDatabase(
//       path,
//       version: 4, // Increment version number
//       onCreate: (Database db, int version) async {
//         // Create orders table
//         await db.execute('''
//           CREATE TABLE orders(
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             user_id INTEGER NOT NULL,
//             invoice_id TEXT NOT NULL,
//             date TEXT NOT NULL,
//             status TEXT NOT NULL
//           )
//         ''');

//         // Create order items table
//         await db.execute('''
//           CREATE TABLE order_items(
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             user_id INTEGER NOT NULL,
//             invoice_id TEXT NOT NULL,
//             product_name TEXT NOT NULL,
//             description TEXT,
//             price REAL NOT NULL,
//             currency TEXT,
//             image_url TEXT,
//             price_sign TEXT,
//             selected_color TEXT,
//             quantity INTEGER NOT NULL,
//             address TEXT
//           )
//         ''');
//       },
//       onUpgrade: (Database db, int oldVersion, int newVersion) async {
//         if (oldVersion < 4) {
//           // Upgrade logic for version 4
//           await db.execute(
//               'ALTER TABLE orders ADD COLUMN user_id INTEGER NOT NULL DEFAULT 0');
//           await db.execute(
//               'ALTER TABLE order_items ADD COLUMN user_id INTEGER NOT NULL DEFAULT 0');
//         }
//       },
//     );
//   }

//   // Save a single cart item as a new order
//   static Future<void> saveOneOrder(ProductClass cartItem, String address,
//       String invoiceId, int userId) async {
//     final db = await database;

//     // Begin transaction
//     await db.transaction((txn) async {
//       try {
//         // Insert order record
//         await txn.insert('orders', {
//           'user_id': userId,
//           'invoice_id': invoiceId,
//           'date': DateTime.now().toIso8601String(),
//           'status': 'process'
//         });

//         // Insert the cart item
//         await txn.insert('order_items', {
//           'user_id': userId,
//           'invoice_id': invoiceId,
//           'product_name': cartItem.title,
//           'description': cartItem.description,
//           'price': cartItem.price,
//           'currency': "USD",
//           'image_url': cartItem.image,
//           'price_sign': cartItem.priceSign,
//           'selected_color': cartItem.selectedColor,
//           'quantity': cartItem.qty,
//           'address': address,
//         });
//       } catch (e) {
//         // Handle any errors during the transaction
//         print("Error while saving one order: $e");
//         rethrow; // Re-throw the error to ensure transaction rollback
//       }
//     });
//   }

//   // Save cart items as a new order (multiple items)
//   static Future<void> saveOrder(List<ProductClass> cartItems, String address,
//       String invoiceId, int userId) async {
//     final db = await database;

//     // Begin transaction
//     await db.transaction((txn) async {
//       try {
//         // Insert order record
//         await txn.insert('orders', {
//           'user_id': userId,
//           'invoice_id': invoiceId,
//           'date': DateTime.now().toIso8601String(),
//           'status': 'process'
//         });

//         // Insert all cart items
//         for (var item in cartItems) {
//           await txn.insert('order_items', {
//             'user_id': userId,
//             'invoice_id': invoiceId,
//             'product_name': item.title,
//             'description': item.description,
//             'price': item.price,
//             'currency': "USD",
//             'image_url': item.image,
//             'price_sign': item.priceSign,
//             'selected_color': item.selectedColor,
//             'quantity': item.qty,
//             'address': address,
//           });
//         }
//       } catch (e) {
//         // Handle any errors during the transaction
//         print("Error while saving order: $e");
//         rethrow; // Re-throw the error to ensure transaction rollback
//       }
//     });
//   }

//   // Get order details by invoice ID and user_id
//   static Future<Map<String, dynamic>> getOrder(
//       String invoiceId, int userId) async {
//     final db = await database;

//     try {
//       // Get order info
//       final List<Map<String, dynamic>> orderResult = await db.query(
//         'orders',
//         where: 'invoice_id = ? AND user_id = ?',
//         whereArgs: [invoiceId, userId],
//       );

//       if (orderResult.isEmpty) {
//         throw Exception("Order not found");
//       }

//       // Get order items
//       final List<Map<String, dynamic>> itemsResult = await db.query(
//         'order_items',
//         where: 'invoice_id = ? AND user_id = ?',
//         whereArgs: [invoiceId, userId],
//       );

//       return {
//         'order': orderResult.first,
//         'items': itemsResult,
//       };
//     } catch (e) {
//       print("Error while getting order: $e");
//       rethrow;
//     }
//   }

//   // Update order status
//   static Future<void> updateOrderStatus(
//       String invoiceId, String newStatus, int userId) async {
//     final db = await database;
//     try {
//       await db.update(
//         'orders',
//         {'status': newStatus},
//         where: 'invoice_id = ? AND user_id = ?',
//         whereArgs: [invoiceId, userId],
//       );
//     } catch (e) {
//       print("Error while updating order status: $e");
//       rethrow;
//     }
//   }

//   // Get all orders for a specific user
//   static Future<List<Map<String, dynamic>>> getAllOrders(int userId) async {
//     final db = await database;
//     try {
//       return await db.query(
//         'orders',
//         where: 'user_id = ?',
//         whereArgs: [userId],
//         orderBy: 'date DESC',
//       );
//     } catch (e) {
//       print("Error while getting all orders: $e");
//       rethrow;
//     }
//   }

//   // Get items for a specific order and user
//   static Future<List<Map<String, dynamic>>> getOrderItems(
//       String invoiceId, int userId) async {
//     final db = await database;
//     try {
//       return await db.query(
//         'order_items',
//         where: 'invoice_id = ? AND user_id = ?',
//         whereArgs: [invoiceId, userId],
//       );
//     } catch (e) {
//       print("Error while getting order items: $e");
//       rethrow;
//     }
//   }

//   // Delete order for a specific user
//   static Future<void> deleteOrder(String invoiceId, int userId) async {
//     final db = await database;
//     try {
//       await db.delete(
//         'orders',
//         where: 'invoice_id = ? AND user_id = ?',
//         whereArgs: [invoiceId, userId],
//       );
//       await db.delete(
//         'order_items',
//         where: 'invoice_id = ? AND user_id = ?',
//         whereArgs: [invoiceId, userId],
//       );
//     } catch (e) {
//       print("Error while deleting order: $e");
//       rethrow;
//     }
//   }
// }
