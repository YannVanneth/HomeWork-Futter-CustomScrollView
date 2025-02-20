import 'package:custom_scroll_view/bloc/addToCarts/add_event.dart';
import 'package:custom_scroll_view/bloc/addToCarts/add_state.dart';
import 'package:custom_scroll_view/databases/add_2_cart_helper.dart';
import 'package:custom_scroll_view/models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddToCartsBloc extends Bloc<AddToCartEvent, AddToCartsState> {
  AddToCartsBloc()
      : super(AddToCartsState(product: const [], isSelected: false, price: 1)) {
    on<LoadCartItem>(
      (event, emit) async {
        List<ProductModel> product = [];
        product = await Add2Cart.readModelsFromFile();
        emit(state.copyWith(product: product));
      },
    );

    on<ToggleCheckbox>(
      (event, emit) {
        emit(state.copyWith(isSelected: !state.isSelected));
      },
    );

    on<IncrementQuantity>(
      (event, emit) {
        List<ProductModel> product = state.product;
        product[event.index].qty++;

        Add2Cart.updateCart(product[event.index],
            product[event.index].selectedColor, product[event.index].qty);

        emit(state.copyWith(product: product));
        add(UpdatePriceWithoutDiscount());
      },
    );

    on<DecrementQuantity>(
      (event, emit) {
        List<ProductModel> product = state.product;
        if (product[event.index].qty > 1) {
          product[event.index].qty--;
        }

        Add2Cart.updateCart(product[event.index],
            product[event.index].selectedColor, product[event.index].qty);

        emit(state.copyWith(product: product));
        add(UpdatePriceWithoutDiscount());
      },
    );

    on<UpdatePriceWithoutDiscount>((event, emit) {
      double totalPrice = 0.0;

      for (var item in state.product) {
        totalPrice += (item.qty * double.parse(item.price));
      }

      return emit(state.copyWith(price: totalPrice));
    });
  }
}
