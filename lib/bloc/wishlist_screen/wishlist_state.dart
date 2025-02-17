import '../../models/products.dart';

abstract class WishlistState {}

class WishlistLoading extends WishlistState {}

class WishlistLoaded extends WishlistState {
  final List<Product> products;
  WishlistLoaded(this.products);
}

class WishlistError extends WishlistState {
  final String message;
  WishlistError(this.message);
}
