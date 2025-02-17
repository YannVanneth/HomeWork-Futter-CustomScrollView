import 'package:custom_scroll_view/views/buy_now/buynow_page.dart';
import 'package:custom_scroll_view/views/home_view.dart';
import 'package:custom_scroll_view/views/product/product_details.dart';
import 'package:custom_scroll_view/views/product/view_category_page.dart';

import '../views/map_screen/map_screen.dart';

class Routes {
  static const String home = '/home_view';
  static const String category = '/category_view';
  static const String detailProduct = '/detail_product_view';
  static const String buyNowPage = '/buy_now_screen_view';
  static const String locationScreen = '/location_screen_view';
}

var routes = {
  Routes.home: (context) => HomeView(),
  Routes.category: (context) => ViewCategoryPage(),
  Routes.detailProduct: (context) => ProductDetailsPage(),
  Routes.buyNowPage: (context) => BuyNowPage(),
  Routes.locationScreen: (context) => MapScreen(),
};
