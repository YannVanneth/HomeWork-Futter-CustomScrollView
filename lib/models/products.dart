import 'dart:convert';

import 'package:custom_scroll_view/models/product_model.dart';

class Product {
  late int id;
  late String name;
  late String description;
  late String type;
  late String currencySign;
  late String price;
  late String featureImageUrl;
  late List<String> tagName;
  late List<ProductColor> colors;

  Product({
    this.id = 1,
    this.name = '',
    this.description = '',
    this.type = '',
    this.currencySign = '',
    this.price = '',
    this.featureImageUrl = '',
    this.tagName = const [],
    this.colors = const [],
  });

  Product.fromJson(Map<String, dynamic> data) {
    id = data['id'] ?? 1;
    name = data['name'] ?? "";
    description = data['description'] ?? "";
    type = data['product_type'] ?? "";
    price = data['price'] ?? "";
    featureImageUrl = "https:${data['api_featured_image']}";
    currencySign = data['price_sign'] ?? "";
    tagName = (data['tag_list'] as List).map((e) => e.toString()).toList();
    colors = (data['product_colors'] as List)
        .map((e) => ProductColor.fromJSON(e))
        .toList();
  }

  Product.fromJsonDB(Map<String, dynamic> data) {
    id = data['id'] ?? 1;
    name = data['name'] ?? "";
    description = data['description'] ?? "";
    type = data['product_type'] ?? "";
    price = data['price'] ?? "";
    featureImageUrl = "https:${data['api_featured_image']}";
    currencySign = data['price_sign'] ?? "";
    // tagName = (data['tag_list'] as List).map((e) => e.toString()).toList();
    // colors = (data['product_colors'] as List)
    //     .map((e) => ProductColor.fromJson(e))
    //     .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'product_type': type,
      'price': price.toString(),
      'api_featured_image': featureImageUrl,
      'price_sign': currencySign,
      'tag_list': jsonEncode(tagName),
      'product_colors': jsonEncode(colors.map((e) => e.toJson()).toList()),
    };
  }
}

// class ProductColor {
//   late String colorCode;
//   late String colorName;

//   ProductColor.fromJson(Map<String, dynamic> data) {
//     colorCode = data['hex_value'] ?? "";
//     colorName = data['colour_name'] ?? "";
//   }

// }
