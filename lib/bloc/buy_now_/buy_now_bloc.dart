import 'package:custom_scroll_view/bloc/buy_now_/buy_now_event.dart';
import 'package:custom_scroll_view/bloc/buy_now_/buy_now_state.dart';
import 'package:custom_scroll_view/models/detail_product.dart';
import 'package:custom_scroll_view/models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuyNowBloc extends Bloc<BuyNowEvent, BuyNowState> {
  BuyNowBloc()
      : super(BuyNowState(
            coupon: 'unknown',
            location: 'unknown',
            paymentMethod: 'unknown',
            phoneNumber: 'unknown',
            discountRate: 0,
            price: 0,
            products: List.from([]))) {
    on<UpdateDiscountRate>((event, emit) {
      return emit(state.copyWith(discountRate: event.discountRate));
    });

    on<UpdatePriceWithoutDiscount>((event, emit) {
      double totalPrice = 0.0;

      for (var item in state.products) {
        totalPrice += (item.qty * double.parse(item.price));
      }

      return emit(state.copyWith(priceWithoutDiscount: totalPrice));
    });

    on<UpdatePrice>((event, emit) {
      double totalPrice = 0.0;

      for (var item in state.products) {
        totalPrice += (item.qty * double.parse(item.price));
      }

      // find discount
      if (state.discountRate > 0) {
        totalPrice = totalPrice - ((state.discountRate / 100) * totalPrice);
      }

      return emit(state.copyWith(price: totalPrice));
    });

    on<UpdateShippingAddress>(
        (event, emit) => emit(state.copyWith(location: event.address)));

    on<UpdateBillingAddress>((event, emit) =>
        emit(state.copyWith(paymentMethod: event.paymentMethod)));

    on<UpdatePhoneNumber>(
        (event, emit) => emit(state.copyWith(phoneNumber: event.phoneNumber)));

    on<UpdateCoupons>(
        (event, emit) => emit(state.copyWith(coupon: event.coupons)));

    on<LoadProducts>(
        (event, emit) => emit(state.copyWith(products: event.products)));

    on<IncrementQuantity>((event, emit) {
      final List<ProductModel> updatedProducts = List.from(state.products);

      updatedProducts[event.index] = updatedProducts[event.index].copywith(
        qty: updatedProducts[event.index].qty + 1,
      );

      emit(state.copyWith(products: updatedProducts));
      add(UpdatePrice());
      add(UpdatePriceWithoutDiscount());
    });

    on<DecrementQuantity>((event, emit) {
      final List<ProductModel> updatedProducts = List.from(state.products);

      if (updatedProducts[event.index].qty > 1) {
        updatedProducts[event.index] = updatedProducts[event.index].copywith(
          qty: updatedProducts[event.index].qty - 1,
        );

        emit(state.copyWith(products: updatedProducts));
        add(UpdatePrice());
        add(UpdatePriceWithoutDiscount());
      }
    });
  }
}
