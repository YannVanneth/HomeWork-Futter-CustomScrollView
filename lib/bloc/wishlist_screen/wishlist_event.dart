import '../../models/products.dart';

// Base class for events
abstract class WishlistEvent {}

// Event to fetch wishlist items
class LoadWishlist extends WishlistEvent {}

// Event to add an item to the wishlist
class AddToWishlist extends WishlistEvent {
  final Product product;
  AddToWishlist(this.product);
}

// Event to remove an item from the wishlist
class RemoveFromWishlist extends WishlistEvent {
  final Product product;
  RemoveFromWishlist(this.product);
}
