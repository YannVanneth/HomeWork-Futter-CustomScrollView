import 'package:flutter_level_01/views/add_carts_/add_to_carts_screen.dart';
import 'package:flutter_level_01/views/buy_now/buynow_page.dart';
import 'package:flutter_level_01/views/home_view.dart';
import 'package:flutter_level_01/views/my_order_details.dart';
import 'package:flutter_level_01/views/product/product_details.dart';
import 'package:flutter_level_01/views/product/view_category_page.dart';
import 'package:flutter_level_01/views/search/search_screen.dart';

import '../views/map_screen/map_screen.dart';
import '../views/my_orders_screen.dart';
import '../views/payment_method/payment_method.dart';

class Routes {
  static const String home = '/home_view';
  static const String category = '/category_view';
  static const String detailProduct = '/detail_product_view';
  static const String buyNowPage = '/buy_now_screen_view';
  static const String locationScreen = '/location_screen_view';
  static const String paymentMethod = '/payment_method_view';
  static const String searchPage = '/search_page';
  static const String cartView = '/cart_view';
  static const String myOrders = '/my_orders';
  static const String myOrdersDetails = '/my_orders/details';
}

var routes = {
  Routes.home: (context) => HomeView(),
  Routes.category: (context) => ViewCategoryPage(),
  Routes.detailProduct: (context) => ProductDetailsPage(),
  Routes.buyNowPage: (context) => BuyNowPage(),
  Routes.locationScreen: (context) => MapScreen(),
  Routes.paymentMethod: (context) => PaymentMethod(),
  Routes.searchPage: (context) => SearchScreen(),
  Routes.cartView: (context) => AddToCartsScreen(),
  Routes.myOrders: (context) => MyOrdersScreen(),
  Routes.myOrdersDetails: (context) => MyOrderDetails(),
};
