import 'package:custom_scroll_view/bloc/detail_screen/detail_screen_event.dart';
import 'package:custom_scroll_view/bloc/detail_screen/detail_screen_state.dart';
import 'package:custom_scroll_view/data/exports.dart';
import 'package:custom_scroll_view/databases/add_2_cart_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailScreenBloc extends Bloc<DetailScreenEvent, DetailScreenState> {
  DetailScreenBloc()
      : super(DetailScreenState(
            isExpanded: false,
            isLoading: false,
            // isFavorite: false,
            selectedColor: 'unknown',
            qty: 1)) {
    on<ToggleFavorite>(
      (event, emit) {
        emit(state.copyWith(isFavorite: event.isFavorite));
      },
    );

    on<ColorSelected>(
      (event, emit) {
        emit(state.copyWith(selectedColor: event.colorName));
      },
    );

    on<ShowDetailScreen>(
      (event, emit) {
        emit(state.copyWith(isExpanded: event.isExpanded));
      },
    );

    on<LoadDetailScreen>(
      (event, emit) {
        emit(state.copyWith(product: event.product));
      },
    );

    on<UpdateTotalQty>(
      (event, emit) async {
        emit(state.copyWith(qty: await Add2Cart.countItemsInCart()));
      },
    );

    on<LoadIsWishListItem>((event, emit) async {
      var wishlist = await CustomWidgets.getfavoriteToggle();

      for (var item in wishlist) {
        if (item == state.product.featureImageUrl) {
          emit(state.copyWith(isFavorite: true));
          break;
        }
      }
    });
  }
}
