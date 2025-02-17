import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_scroll_view/bloc/wishlist_screen/wishlist_bloc.dart';
import 'package:custom_scroll_view/bloc/wishlist_screen/wishlist_event.dart';
import 'package:custom_scroll_view/bloc/wishlist_screen/wishlist_state.dart';
import 'package:custom_scroll_view/data/exports.dart';
import 'package:custom_scroll_view/databases/databases_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  late WishlistBloc wishlistBloc;

  @override
  void initState() {
    super.initState();
    wishlistBloc = WishlistBloc();
    wishlistBloc.add(LoadWishlist(products
        .map(
          (e) => Product.fromJson(e),
        )
        .toList()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => wishlistBloc,
      child: BlocBuilder<WishlistBloc, WishlistState>(
        builder: (context, state) {
          if (state is WishlistLoaded) {
            var wishlistItems = state.products;

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
              ),
            );
          }

          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    wishlistBloc.close();
    super.dispose();
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
        key: Key(products[index].featureImageUrl),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          context.read<WishlistBloc>().add(RemoveFromWishlist(products[index]));
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
    onTap: () =>
        Navigator.pushNamed(context, Routes.detailProduct, arguments: product),
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
