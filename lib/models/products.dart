// ignore_for_file: public_member_api_docs, sort_constructors_first
class Product {
  late String name;
  late String description;
  late String type;
  late String currencySign;
  late String price;
  late String featureImageUrl;
  late List<String> tagName;
  late List<ProductColor> colors;

  Product.fromJson(Map<String, dynamic> data) {
    name = data['name'] ?? "";
    description = data['description'] ?? "";
    type = data['product_type'] ?? "";
    price = data['price'] ?? "";
    featureImageUrl = "https:${data['api_featured_image']}";
    currencySign = data['price_sign'] ?? "";
    tagName = (data['tag_list'] as List).map((e) => e.toString()).toList();
    colors = (data['product_colors'] as List)
        .map((e) => ProductColor.fromJson(e))
        .toList();
  }
}

class ProductColor {
  late String name;

  ProductColor.fromJson(Map<String, dynamic> data) {
    name = data['hex_value'] ?? "";
  }
}
