import 'package:flutter_level_01/data/exports.dart';
import 'package:flutter_level_01/views/wishlist/wishlist_screen.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

import '../../models/product_model.dart';

// ignore: must_be_immutable
class SearchScreen extends StatefulWidget {
  SearchScreen({super.key, this.listProducts = const []});
  List<ProductModel> listProducts;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: CustomScrollView(
          slivers: [
            SliverList.separated(
              itemCount: widget.listProducts.length,
              itemBuilder: (context, index) {
                var product = widget.listProducts[index];
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
