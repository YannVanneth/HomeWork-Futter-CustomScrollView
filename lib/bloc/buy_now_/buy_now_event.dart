import 'package:custom_scroll_view/models/detail_product.dart';

import '../../models/products.dart';

abstract class BuyNowEvent {}

class UpdatePrice extends BuyNowEvent {}

class UpdatePriceWithoutDiscount extends BuyNowEvent {}

class UpdateDiscountRate extends BuyNowEvent {
  final double discountRate;

  UpdateDiscountRate(this.discountRate);
}

abstract class UpdateOrderInformations extends BuyNowEvent {}

class UpdateShippingAddress extends UpdateOrderInformations {
  final String address;

  UpdateShippingAddress(this.address);
}

class UpdateBillingAddress extends UpdateOrderInformations {
  final String paymentMethod;

  UpdateBillingAddress(this.paymentMethod);
}

class UpdatePhoneNumber extends BuyNowEvent {
  final String phoneNumber;
  UpdatePhoneNumber(this.phoneNumber);
}

class UpdateCoupons extends BuyNowEvent {
  final String coupons;
  UpdateCoupons(this.coupons);
}

class LoadProducts extends BuyNowEvent {
  final List<DetailProduct> products;
  LoadProducts(this.products);
}

abstract class ProductQuantity extends BuyNowEvent {}

class IncrementQuantity extends ProductQuantity {
  final int index;
  IncrementQuantity(this.index);
}

class DecrementQuantity extends ProductQuantity {
  final int index;
  DecrementQuantity(this.index);
}
