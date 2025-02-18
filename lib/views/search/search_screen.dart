import 'package:custom_scroll_view/data/exports.dart';
import 'package:custom_scroll_view/views/wishlist/wishlist_screen.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

// ignore: must_be_immutable
class SearchScreen extends StatelessWidget {
  SearchScreen({super.key, this.listProducts});
  List<Product>? listProducts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: CustomScrollView(
          slivers: [
            SliverList.separated(
              itemCount: listProducts!.length,
              itemBuilder: (context, index) {
                var product = listProducts![index];
                return Bounceable(
                    onTap: () => Navigator.pushNamed(
                        context, Routes.detailProduct,
                        arguments: product),
                    child: item(context, product));
              },
              separatorBuilder: (context, index) => SizedBox(
                height: 15,
              ),
            )
          ],
        )));
  }
}
