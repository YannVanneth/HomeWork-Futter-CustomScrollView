import 'package:custom_scroll_view/data/exports.dart';
import 'package:custom_scroll_view/models/detail_product.dart';
import 'package:custom_scroll_view/models/product_model.dart';

class BuyNowState {
  final String location;
  final String paymentMethod;
  final String phoneNumber;
  final double price;
  final String coupon;
  final List<ProductModel> products;
  final double discountRate;
  final double priceWithoutDiscount;

  BuyNowState({
    this.priceWithoutDiscount = 0.0,
    this.discountRate = 0.0,
    this.products = const [],
    this.location = 'unknown',
    this.paymentMethod = 'unknown',
    this.phoneNumber = 'unknown',
    this.price = 0,
    this.coupon = 'unknown',
  });

  BuyNowState copyWith({
    double? priceWithoutDiscount,
    double? discountRate,
    int? quantity,
    List<ProductModel>? products,
    String? location,
    String? paymentMethod,
    String? phoneNumber,
    double? price,
    String? coupon,
  }) {
    return BuyNowState(
      priceWithoutDiscount: priceWithoutDiscount ?? this.priceWithoutDiscount,
      discountRate: discountRate ?? this.discountRate,
      products: products ?? this.products,
      location: location ?? this.location,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      price: price ?? this.price,
      coupon: coupon ?? this.coupon,
    );
  }
}
