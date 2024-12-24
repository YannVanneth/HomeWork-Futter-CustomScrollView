import 'package:custom_scroll_view/pages/buynow_page.dart';
import 'package:custom_scroll_view/pages/homepages.dart';
import 'package:custom_scroll_view/pages/product_details.dart';
import 'package:custom_scroll_view/pages/view_category_page.dart';

class Routes {
  static const String home = '/home';
  static const String category = '/category_view';
  static const String detailProduct = '/detail_product_view';
  static const String buyNowPage = '/buy_now_page';
}

var routes = {
  Routes.home: (context) => HomePageScreen(),
  Routes.category: (context) => ViewCategoryPage(),
  Routes.detailProduct: (context) => ProductDetailsPage(),
  Routes.buyNowPage: (context) => BuyNowPage(),
};
