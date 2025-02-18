import 'package:custom_scroll_view/data/exports.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../databases/databases_helper.dart';
import './wishlist_state.dart';
import './wishlist_event.dart';

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
    emit(WishlistLoaded(event.wishlist));
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
