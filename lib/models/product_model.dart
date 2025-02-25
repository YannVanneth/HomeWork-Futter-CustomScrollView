// ignore_for_file: public_member_api_docs, sort_constructors_first
class ProductModel {
  late int id;
  late String title;
  late String description;
  late String image;
  late String priceSign;
  late String price;
  late List<String> tagList;
  late String productType;
  late List<ProductColor> productColors;
  late int qty;
  late String selectedColor;
  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.priceSign,
    required this.price,
    required this.tagList,
    required this.productType,
    required this.productColors,
    required this.qty,
    required this.selectedColor,
  });
  ProductModel.fromJSON(Map<String, dynamic> item) {
    //how to hav from JSON
    id = item['id'] ?? 1;
    title = item['name'] ?? "";
    description = item['description'] ?? "No description";
    image = item['api_featured_image'] != null
        ? (item['api_featured_image'].startsWith('https://')
            ? item['api_featured_image']
            : 'https:${item['api_featured_image']}')
        : ''; // Set empty if image is not available
    priceSign = item['price_sign'] ?? "";
    price = item['price'] ?? "";
    tagList = (item['tag_list'] as List).map((e) => e.toString()).toList();
    productType = item['product_type'] ?? "";
    productColors = (item['product_colors'] as List)
            .map((e) => ProductColor.fromJSON(e))
            .toList() ??
        [];
    selectedColor = item['selected_color'] ?? "";
    qty = item['quantity'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': title,
      'description': description,
      'api_featured_image': image,
      'price_sign': priceSign,
      'price': price,
      'tag_list': tagList,
      'product_type': productType,
      'product_colors': productColors
          .map(
            (e) => e.toJson(),
          )
          .toList(),
      'selected_color': selectedColor,
      'quantity': qty
    };
  }

  ProductModel copywith({
    int? id,
    String? title,
    String? description,
    String? image,
    String? priceSign,
    String? price,
    List<String>? tagList,
    String? productType,
    List<ProductColor>? productColors,
    int? qty,
    String? selectedColor,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      priceSign: priceSign ?? this.priceSign,
      price: price ?? this.price,
      tagList: tagList ?? this.tagList,
      productType: productType ?? this.productType,
      productColors: productColors ?? this.productColors,
      qty: qty ?? this.qty,
      selectedColor: selectedColor ?? this.selectedColor,
    );
  }
}

class ProductColor {
  late String hexValue;
  late String colorName;
  ProductColor({
    required this.hexValue,
    required this.colorName,
  });
  ProductColor.fromJSON(Map<String, dynamic> json) {
    hexValue = json['hex_value'] ?? "";
    colorName = json['colour_name'] ?? "";
  }

  Map<String, dynamic> toJson() {
    return {
      'hex_value': hexValue,
      'colour_name': colorName,
    };
  }
}
