import 'package:custom_scroll_view/data/exports.dart';

class BuyNowState {
  final String location;
  final String paymentMethod;
  final String phoneNumber;
  final double price;
  final String coupon;
  final List<Product> products;

  BuyNowState({
    this.products = const [],
    this.location = 'unknown',
    this.paymentMethod = 'unknown',
    this.phoneNumber = 'unknown',
    this.price = 0,
    this.coupon = 'unknown',
  });

  BuyNowState copyWith({
    List<Product>? products,
    String? location,
    String? paymentMethod,
    String? phoneNumber,
    double? price,
    String? coupon,
  }) {
    return BuyNowState(
      products: products ?? this.products,
      location: location ?? this.location,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      price: price ?? this.price,
      coupon: coupon ?? this.coupon,
    );
  }
}
