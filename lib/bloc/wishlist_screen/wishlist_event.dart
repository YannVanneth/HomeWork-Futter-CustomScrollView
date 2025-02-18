// import 'package:custom_scroll_view/databases/databases_helper.dart';

import '../../models/products.dart';

// Base class for events
abstract class WishlistEvent {}

class LoadWishlist extends WishlistEvent {}

class AddToWishlist extends WishlistEvent {
  final Product product;
  AddToWishlist(this.product);
}

class RemoveFromWishlist extends WishlistEvent {
  final Product product;
  RemoveFromWishlist(this.product);
}
