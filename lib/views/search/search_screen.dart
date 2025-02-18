import 'package:custom_scroll_view/data/exports.dart';
import 'package:custom_scroll_view/views/wishlist/wishlist_screen.dart';

// ignore: must_be_immutable
class SearchScreen extends StatelessWidget {
  SearchScreen({super.key, this.productSelector});

  List<Product>? productSelector;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: CustomScrollView(
        slivers: [
          SliverList.separated(
            itemCount: productSelector != null
                ? productSelector!.length
                : products.length,
            itemBuilder: (context, index) {
              var product =
                  productSelector?[index] ?? Product.fromJson(products[index]);
              return item(context, product);
            },
            separatorBuilder: (context, index) => SizedBox(
              height: 15,
            ),
          )
        ],
      )),
    );
  }
}
