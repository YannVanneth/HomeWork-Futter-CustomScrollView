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

  final List<Product> _wishlistItems = [];

  void _onLoadWishlist(LoadWishlist event, Emitter<WishlistState> emit) async {
    dynamic data = await DatabasesHelper.dbHelper.db!.rawQuery(
        'SELECT * FROM wishlists w INNER JOIN products p ON w.product_id = p.id');

    if ((data as List<Map<String, dynamic>>).isNotEmpty) {
      data = data
          .map(
            (e) => Product.fromJsonDB(e),
          )
          .toList();

      _wishlistItems.addAll(data);
    }

    emit(WishlistLoaded(List.from(_wishlistItems)));
  }

  void _onAddToWishlist(AddToWishlist event, Emitter<WishlistState> emit) {
    _wishlistItems.add(event.product);

    emit(WishlistLoaded(List.from(_wishlistItems)));
  }

  void _onRemoveFromWishlist(
      RemoveFromWishlist event, Emitter<WishlistState> emit) async {
    var items = await CustomWidgets.getfavoriteToggle();
    items.remove(event.product.featureImageUrl);
    CustomWidgets.favoriteToggle(items);

    await DatabasesHelper.dbHelper.db!.rawDelete(
        'DELETE FROM wishlists WHERE product_id = ? AND api_featured_image = ?',
        [event.product.id, event.product.featureImageUrl]);

    _wishlistItems.removeWhere((p) => p.id == event.product.id);

    emit(WishlistLoaded(List.from(_wishlistItems)));
  }
}
