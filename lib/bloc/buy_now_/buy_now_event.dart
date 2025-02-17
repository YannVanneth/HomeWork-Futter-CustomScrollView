import '../../models/products.dart';

abstract class BuyNowEvent {}

class UpdatePrice extends BuyNowEvent {
  final double price;

  UpdatePrice(this.price);
}

abstract class UpdateOrderInformations extends BuyNowEvent {}

class UpdateShippingAddress extends UpdateOrderInformations {
  final String address;

  UpdateShippingAddress(this.address);
}

class UpdateBillingAddress extends UpdateOrderInformations {
  final String address;

  UpdateBillingAddress(this.address);
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
  final List<Product> products;
  LoadProducts(this.products);
}
