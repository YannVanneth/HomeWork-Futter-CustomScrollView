import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_scroll_view/data/exports.dart';
import 'package:custom_scroll_view/databases/databases_helper.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<Product> wishlistItems = [];

  @override
  void initState() {
    super.initState();
    loadWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: wishlistItems.isNotEmpty
            ? Column(
                children: [
                  Expanded(child: _wishlistItem(wishlistItems)),
                ],
              )
            : _noWishListData(context),
        // : _noWishListData(context),
      ),
    );
  }

  Future<void> loadWishlist() async {
    var items = await DatabasesHelper.dbHelper.db!.rawQuery(
        'SELECT * FROM wishlists w INNER JOIN products p ON w.product_id = p.id');

    if (items != null) {
      setState(() {
        wishlistItems = items.map((e) => Product.fromJson(e)).toList();
      });
    }
  }

  Widget _noWishListData(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.file_present_sharp, size: 38),
            const SizedBox(width: 5), // Fixed spacing
            const Text(
              "NO DATA",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 10), // Fixed spacing
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            backgroundColor: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, Routes.home);
          },
          child: const Text(
            "Back to homepage",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _wishlistItem(List<Product> products) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView.separated(
        itemBuilder: (context, index) => Dismissible(
          key: Key(products[index].name),
          direction: DismissDirection.endToStart,
          resizeDuration: Duration(milliseconds: 400),
          onDismissed: (direction) async {
            setState(() {
              wishlistItems.removeAt(index); // Remove item from the list
            });
            var items = await CustomWidgets.getfavoriteToggle() as List<String>;
            items.remove(products[index].name);
            CustomWidgets.favoriteToggle(items);
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 30),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          child: _item(context, products[index]),
        ),
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: products.length,
      ),
    );
  }

  Widget _item(BuildContext context, Product product) {
    return Bounceable(
      onTap: () => Navigator.pushNamed(context, Routes.detailProduct,
          arguments: product),
      child: SizedBox(
        height: 130,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: CachedNetworkImage(imageUrl: product.featureImageUrl),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: Text(
                      product.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  Text(
                    '${product.currencySign} ${product.price}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
