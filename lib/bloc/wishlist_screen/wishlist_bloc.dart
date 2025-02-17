import 'package:custom_scroll_view/data/exports.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../databases/databases_helper.dart';
import './wishlist_state.dart';
import './wishlist_event.dart';

// class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
//   WishlistBloc() : super(WishlistLoading()) {
//     on<LoadWishlist>(_onLoadWishlist);
//     on<RemoveFromWishlist>(_onRemoveFromWishlist);
//   }

//   Future<void> _onLoadWishlist(
//       LoadWishlist event, Emitter<WishlistState> emit) async {
//     final db = DatabasesHelper.dbHelper.db;
//     final List<Map<String, dynamic>> wishlistData =
//         await db!.query('wishlists');

//     final wishlistItems =
//         wishlistData.map((item) => Product.fromJson(item)).toList();

//     for (var item in wishlistData) {
//       var imageURL = item['ImageURL'];

//       var matchingProducts = event.wishlist.where(
//         (product) => 'https:${product.featureImageUrl}' == imageURL,
//       );

//       for (var matchingProduct in matchingProducts) {
//         wishlistItems.add(matchingProduct);
//       }
//     }

//     emit(WishlistLoaded(wishlistItems));
//   }

//   void _onRemoveFromWishlist(
//       RemoveFromWishlist event, Emitter<WishlistState> emit) {
//     if (state is WishlistLoaded) {
//       final updatedList = List<Product>.from((state as WishlistLoaded).products)
//         ..remove(event.product);
//       emit(WishlistLoaded(updatedList));
//     }
//   }
// }

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  WishlistBloc() : super(WishlistLoading()) {
    on<LoadWishlist>(_onLoadWishlist);
    on<AddToWishlist>(_onAddToWishlist);
    on<RemoveFromWishlist>(_onRemoveFromWishlist);
  }

  final List<Product> _wishlistItems = products
      .map(
        (e) => Product.fromJson(e),
      )
      .toList();

  void _onLoadWishlist(LoadWishlist event, Emitter<WishlistState> emit) {
    emit(WishlistLoaded(_wishlistItems));
  }

  void _onAddToWishlist(AddToWishlist event, Emitter<WishlistState> emit) {
    _wishlistItems.add(event.product);
    emit(WishlistLoaded(List.from(_wishlistItems)));
  }

  void _onRemoveFromWishlist(
      RemoveFromWishlist event, Emitter<WishlistState> emit) {
    _wishlistItems.removeWhere((p) => p.id == event.product.id);
    emit(WishlistLoaded(List.from(_wishlistItems)));
  }
}
