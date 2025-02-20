import 'package:custom_scroll_view/models/detail_product.dart';
import 'package:custom_scroll_view/models/product_model.dart';

class AddToCartsState {
  final List<ProductModel> product;
  final bool isSelected;
  final double price;

  AddToCartsState(
      {required this.product, required this.isSelected, required this.price});

  AddToCartsState copyWith(
      {List<ProductModel>? product, bool? isSelected, double? price}) {
    return AddToCartsState(
      price: price ?? this.price,
      product: product ?? this.product,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
