import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/product_model.dart';

class FileHelper {
  FileHelper._();

  static Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/wishlist.json');
  }

  static Future<List<ProductModel>> readModelsFromFile() async {
    final file = await _getFile(); // open file
    if (await file.exists()) {
      String content = await file.readAsString();
      if (content.isNotEmpty) {
        List<dynamic> jsonData = jsonDecode(content);
        return jsonData.map((item) => ProductModel.fromJSON(item)).toList();
      }
    }
    return [];
  }

  static Future<void> addModelToFile(ProductModel newModel) async {
    List<ProductModel> models =
        await readModelsFromFile(); // read existing data
    models.add(newModel); // add new data

    // List<Map<String, dynamic>> jsonData = models.map((data) {
    //   return {
    //     'name': data.title,
    //     'description': data.description,
    //     'price': data.price,
    //     'api_featured_image': data.image,
    //     'price_sign': data.priceSign,
    //     'tag_list': data.tagList,
    //     'product_type': data.productType,
    //     'product_colors': data.productColors.map((color) {
    //       return {
    //         'hex_value': color.hexValue,
    //         'colour_name': color.colorName,
    //       };
    //     }).toList()
    //   };
    // }).toList();

    List<Map<String, dynamic>> jsonData =
        models.map((e) => e.toJson()).toList();

    final file = await _getFile(); // open file
    await file.writeAsString(jsonEncode(jsonData)); // write data to file
  }

  static Future<void> removeModelFromFile(ProductModel modelToRemove) async {
    List<ProductModel> models = await readModelsFromFile();
    models.removeWhere((model) => model.title == modelToRemove.title);

    // List<Map<String, dynamic>> jsonData = models.map((model) {
    //   return {
    //     'name': model.title,
    //     'description': model.description,
    //     'price': model.price,
    //     'api_featured_image': model.image,
    //     'price_sign': model.priceSign,
    //     'tag_list': model.tagList,
    //     'product_type': model.productType,
    //     'product_colors': model.productColors.map((color) {
    //       return {
    //         'hex_value': color.hexValue,
    //         'colour_name': color.colorName,
    //       };
    //     }).toList(),
    //   };
    // }).toList();

    List<Map<String, dynamic>> jsonData =
        models.map((e) => e.toJson()).toList();

    final file = await _getFile();
    await file.writeAsString(jsonEncode(jsonData));
  }
}
