import 'package:custom_scroll_view/data/exports.dart';
import 'package:custom_scroll_view/models/detail_product.dart';

abstract class AddToCartEvent {}

class LoadCartItem extends AddToCartEvent {}

class AddCarts extends AddToCartEvent {
  Product product;
  AddCarts({required this.product});
}

class RemoveCarts extends AddToCartEvent {
  List<DetailProduct> product;
  RemoveCarts({required this.product});
}

class ToggleCheckbox extends AddToCartEvent {}

class ProductQuantity extends AddToCartEvent {}

class IncrementQuantity extends ProductQuantity {
  final int index;

  IncrementQuantity({required this.index});
}

class DecrementQuantity extends ProductQuantity {
  final int index;

  DecrementQuantity({required this.index});
}

class UpdatePriceWithoutDiscount extends AddToCartEvent {}
