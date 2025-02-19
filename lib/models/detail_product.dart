// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'products.dart';

class DetailProduct {
  Product products;
  String colorName;
  int quantity;

  DetailProduct({
    this.quantity = 1,
    required this.products,
    required this.colorName,
  });

  DetailProduct copyWith(
      {Product? products, String? colorName, int? quantity}) {
    return DetailProduct(
      products: products ?? this.products,
      colorName: colorName ?? this.colorName,
      quantity: quantity ?? this.quantity,
    );
  }
}
