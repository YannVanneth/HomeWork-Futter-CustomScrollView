import 'package:custom_scroll_view/bloc/buy_now_/buy_now_event.dart';
import 'package:custom_scroll_view/bloc/buy_now_/buy_now_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuyNowBloc extends Bloc<BuyNowEvent, BuyNowState> {
  BuyNowBloc()
      : super(BuyNowState(
            coupon: 'unknown',
            location: 'unknown',
            paymentMethod: 'unknown',
            phoneNumber: 'unknown',
            price: 0,
            products: List.from([]))) {
    on<UpdatePrice>((event, emit) => emit(state.copyWith(price: event.price)));

    on<UpdateShippingAddress>(
        (event, emit) => emit(state.copyWith(location: event.address)));

    on<UpdateBillingAddress>(
        (event, emit) => emit(state.copyWith(location: event.address)));

    on<UpdatePhoneNumber>(
        (event, emit) => emit(state.copyWith(phoneNumber: event.phoneNumber)));

    on<UpdateCoupons>(
        (event, emit) => emit(state.copyWith(coupon: event.coupons)));

    on<LoadProducts>(
        (event, emit) => emit(state.copyWith(products: event.products)));
  }
}
