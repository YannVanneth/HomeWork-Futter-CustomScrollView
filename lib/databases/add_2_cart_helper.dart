import 'dart:convert';
import 'dart:io';

import 'package:custom_scroll_view/data/exports.dart';
import 'package:path_provider/path_provider.dart';

import '../models/product_model.dart';

class Add2Cart {
  Add2Cart._();

  static Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/cart3.json');
  }

  static Future<List<Map<String, dynamic>>> _readRawData() async {
    try {
      final file = await _getFile();

      if (await file.exists()) {
        String content = await file.readAsString();
        if (content.isNotEmpty) {
          return jsonDecode(content).cast<Map<String, dynamic>>();
        }
      }
      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<List<ProductModel>> readModelsFromFile() async {
    try {
      final rawData = await _readRawData();

      return rawData.map((item) {
        ProductModel model = ProductModel.fromJSON(item);
        model.selectedColor = item['selected_color'];
        model.qty = item['quantity'];
        return model;
      }).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<void> addToCart(
      Product newModel, String selectedColor, int qty) async {
    try {
      final rawData = await _readRawData();

      final existingIndex = rawData.indexWhere((item) =>
          item['name'] == newModel.name &&
          item['selected_color'] == selectedColor);

      if (existingIndex != -1) {
        rawData[existingIndex]['quantity'] += qty;
      } else {
        rawData.add({
          'name': newModel.name,
          'description': newModel.description,
          'price': newModel.price,
          'api_featured_image': newModel.featureImageUrl,
          'price_sign': newModel.currencySign,
          'tag_list': newModel.tagName,
          'product_type': newModel.type,
          'product_colors': newModel.colors.map((color) {
            return {
              'hex_value': color.hexValue,
              'colour_name': color.colorName,
            };
          }).toList(),
          'selected_color': selectedColor,
          'quantity': qty,
        });
      }

      final file = await _getFile();
      await file.writeAsString(jsonEncode(rawData));
    } catch (e) {
      print(e);
    }
  }

  static Future<void> removeFromCart(
      ProductModel modelToRemove, String selectedColor) async {
    try {
      final rawData = await _readRawData();

      rawData.removeWhere((item) =>
          item['name'] == modelToRemove.title &&
          item['selected_color'] == selectedColor);

      final file = await _getFile();
      await file.writeAsString(jsonEncode(rawData));
    } catch (e) {
      print(e);
    }
  }

  static Future<void> updateCart(
      ProductModel modelToUpdate, String selectedColor, int qty) async {
    try {
      final rawData = await _readRawData();

      final existingIndex = rawData.indexWhere((item) =>
          item['name'] == modelToUpdate.title &&
          item['selected_color'] == selectedColor);

      if (existingIndex != -1) {
        rawData[existingIndex]['quantity'] = qty;
      }

      final file = await _getFile();
      await file.writeAsString(jsonEncode(rawData));
    } catch (e) {
      print(e);
    }
  }

  static Future<int> countItemsInCart() async {
    List<ProductModel> models = await readModelsFromFile();

    var totalQty = 0;
    for (var model in models) {
      totalQty += model.qty;
    }

    return totalQty;
  }
}
