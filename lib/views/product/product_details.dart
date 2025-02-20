import 'package:custom_scroll_view/bloc/addToCarts/add_state.dart';
import 'package:custom_scroll_view/bloc/detail_screen/detail_screen_bloc.dart';
import 'package:custom_scroll_view/bloc/detail_screen/detail_screen_event.dart';
import 'package:custom_scroll_view/bloc/detail_screen/detail_screen_state.dart';
import 'package:custom_scroll_view/databases/add_2_cart_helper.dart';
import 'package:custom_scroll_view/databases/databases_helper.dart';
import 'package:custom_scroll_view/models/detail_product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:custom_scroll_view/data/exports.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  var item = 0;
  bool isFavorite = false;
  @override
  Widget build(BuildContext context) {
    var product = ModalRoute.of(context)?.settings.arguments as Product;
    CustomWidgets.getfavoriteToggle().then((value) {
      setState(() {
        isFavorite = value.contains(product.featureImageUrl);
      });
    });

    return BlocProvider(
      create: (context) => DetailScreenBloc()
        ..add(UpdateTotalQty())
        ..add(LoadDetailScreen(product)),
      child: BlocBuilder<DetailScreenBloc, DetailScreenState>(
        builder: (context, state) {
          context.read<DetailScreenBloc>().add(UpdateTotalQty());

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              actions: [
                Bounceable(
                  onTap: () => Navigator.pushNamed(context, Routes.cartView),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.shopping_cart,
                          size: 28,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircleAvatar(
                            backgroundColor: Colors.red,
                            child: Text(state.qty.toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomWidgets.productImage(context, product),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width * 0.68,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Price: ${product.currencySign}${product.price}",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            Bounceable(
                              onTap: () async {
                                try {
                                  var wishlist =
                                      await CustomWidgets.getfavoriteToggle();

                                  if (wishlist
                                      .contains(product.featureImageUrl)) {
                                    wishlist.remove(product.featureImageUrl);
                                    await DatabasesHelper.dbHelper.db!.delete(
                                      'wishlists',
                                      where: 'api_featured_image = ?',
                                      whereArgs: [product.featureImageUrl],
                                    );
                                  } else {
                                    wishlist.add(product.featureImageUrl);

                                    await DatabasesHelper.dbHelper.db!
                                        .insert('wishlists', {
                                      'product_id': product.id,
                                      'api_featured_image':
                                          product.featureImageUrl,
                                    });
                                  }

                                  CustomWidgets.favoriteToggle(wishlist);

                                  !state.isFavorite
                                      ? QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.success,
                                          text:
                                              "The item has been added to your wishlist",
                                          confirmBtnText: "Okay",
                                          confirmBtnColor: Colors.green,
                                          customAsset:
                                              "assets/gif/Turn Up Dancing GIF by Rosanna Pansino.gif",
                                          title: "Congratulations",
                                        )
                                      : QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.success,
                                          text:
                                              "The item has been removed from your wishlist",
                                          confirmBtnText: "Okay",
                                          confirmBtnColor: Colors.red,
                                          customAsset:
                                              "assets/gif/Turn Up Dancing GIF by Rosanna Pansino.gif",
                                          title: "Congratulations",
                                        );

                                  context
                                      .read<DetailScreenBloc>()
                                      .add(ToggleFavorite(!state.isFavorite));
                                } catch (e) {
                                  CustomWidgets.showMessageSnakeBar(
                                    message: "An error occurred $e",
                                    backgroundColor: Colors.red,
                                    context: context,
                                  );
                                }
                              },
                              child: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 28,
                                color: Colors.red,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 10,
                            children: [
                              Text(
                                "Color: ${state.selectedColor.isEmpty && product.colors.isEmpty ? "Not found" : state.selectedColor.isEmpty ? "Please select color" : state.selectedColor}",
                                style: TextStyle(fontSize: 18),
                              ),
                              if (product.colors.isNotEmpty)
                                SizedBox(
                                  height: 50,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      var color = product.colors[index].hexValue
                                          .replaceFirst("#", "0xFF")
                                          .split(',')[0]
                                          .replaceFirst("#", "0xFF");
                                      return Bounceable(
                                        onTap: () {
                                          context.read<DetailScreenBloc>().add(
                                              ColorSelected(product
                                                  .colors[index].colorName));
                                        },
                                        child: CustomWidgets.colorBox(
                                            border: state.selectedColor ==
                                                product.colors[index].colorName,
                                            color: Color(int.parse(color))),
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        SizedBox(width: 10),
                                    itemCount: product.colors.length,
                                  ),
                                )
                              else
                                CustomWidgets.itemTags(
                                    tagName: "Unknown Color"),
                            ],
                          ),
                        ),
                        CustomWidgets.productTags(product),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            Text("Description:",
                                style: TextStyle(fontSize: 18)),
                            if (product.description.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (!state.isExpanded)
                                    Text(
                                      product.description,
                                      style: TextStyle(fontSize: 16),
                                      textAlign: TextAlign.justify,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  if (state.isExpanded)
                                    Text(
                                      product.description,
                                      style: TextStyle(fontSize: 16),
                                      textAlign: TextAlign.justify,
                                    ),
                                  TextButton(
                                    onPressed: () => context
                                        .read<DetailScreenBloc>()
                                        .add(
                                          ShowDetailScreen(!state.isExpanded),
                                        ),
                                    child: Text(state.isExpanded
                                        ? "See less"
                                        : "See more"),
                                  ),
                                ],
                              )
                            else
                              CustomWidgets.itemTags(
                                  tagName: "Unknown Description"),
                          ],
                        ),
                        CustomWidgets.bottomArea(
                          context,
                          product,
                          state.selectedColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
