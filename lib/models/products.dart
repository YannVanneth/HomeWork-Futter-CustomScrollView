// ignore_for_file: public_member_api_docs, sort_constructors_first
class Product {
  late int id;
  late String name;
  late String description;
  late String type;
  late String currencySign;
  late String price;
  late String featureImageUrl;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.price,
    required this.featureImageUrl,
    required this.currencySign,
  });

  Product.fromJson(Map<String, dynamic> data) {
    id = data['id'] ?? "";
    name = data['name'] ?? "";
    description = data['description'] ?? "";
    type = data['product_type'] ?? "";
    price = data['price'] ?? "";
    featureImageUrl = "https:${data['api_featured_image']}";
    currencySign = data['price_sign'] ?? "";
  }
}
