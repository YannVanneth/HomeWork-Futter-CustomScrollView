import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_level_01/data/exports.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

import '../../models/product_model.dart';
import '../../utils/file_helper.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<ProductModel> wishlist = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadWishlist();
  }

  Future<void> loadWishlist() async {
    wishlist = await FileHelper.readModelsFromFile();
    setState(() {});
  }

  void removeFromWishlist(ProductModel product) async {
    FileHelper.removeModelFromFile(product);

    var wishlist = await CustomWidgets.getfavoriteToggle();

    if (wishlist.contains(product.image)) {
      wishlist.remove(product.image);
    }

    CustomWidgets.favoriteToggle(wishlist);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: wishlist.isNotEmpty
            ? Column(
                children: [
                  Expanded(child: _wishlistItem(wishlist)),
                ],
              )
            : _noWishListData(context),
      ),
    );
  }

  Widget _wishlistItem(List<ProductModel> productss) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView.separated(
        itemBuilder: (context, index) => Dismissible(
          key: Key(productss[index].title),
          direction: DismissDirection.endToStart,
          resizeDuration: const Duration(milliseconds: 400),
          onDismissed: (direction) {
            removeFromWishlist(productss[index]);
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 30),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          child: Bounceable(
            onTap: () {
              var productsss =
                  products.map((e) => ProductModel.fromJSON(e)).toList();

              var product = productsss.firstWhere(
                (item) => item.image == productss[index].image,
              );

              Navigator.pushNamed(context, Routes.detailProduct,
                  arguments: product);
            },
            child: item(context, productss[index]),
          ),
        ),
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: productss.length,
      ),
    );
  }

  Widget _noWishListData(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.file_present_sharp, size: 38),
            SizedBox(width: 5),
            Text(
              "NO DATA",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 10),
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
}

Widget item(BuildContext context, ProductModel product) {
  return SizedBox(
    height: 130,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: CachedNetworkImage(imageUrl: product.image),
        ),
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                '${product.priceSign} ${product.price}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
