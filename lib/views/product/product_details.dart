import 'package:flutter_level_01/data/exports.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../models/product_model.dart';
import '../../utils/add_2_cart_helper.dart';
import '../../utils/file_helper.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  var item = 0;
  bool isFavorite = false;
  String selectedColor = '';
  bool isExpanded = false;
  int qty = 0;
  bool isLoading = true;

  @override
  void initState() {
    _loadInitialData(context);
    super.initState();
  }

  Future<void> loadQty() async {
    int cartQty = await Add2Cart.countItemsInCart();
    setState(() {});
  }

  Future<void> _loadInitialData(BuildContext context) async {
    try {
      final wishlist = await CustomWidgets.getfavoriteToggle();
      final product =
          ModalRoute.of(context)?.settings.arguments as ProductModel;
      int cartQty = await Add2Cart.countItemsInCart();

      bool tempIsFavorite = false;

      tempIsFavorite = wishlist.contains(product.image);

      setState(() {
        isFavorite = tempIsFavorite;
        qty = cartQty;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var product = ModalRoute.of(context)?.settings.arguments as ProductModel;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          Bounceable(
            onTap: () {
              Navigator.pushNamed(context, Routes.cartView).then(
                (value) {
                  if (value is int) {
                    qty = value;
                  }
                },
              );
            },
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
                      child: Text(
                        qty.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
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
                                    product.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Price: ${product.priceSign}${product.price}",
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
                                  List<String> wishlist =
                                      await CustomWidgets.getfavoriteToggle();

                                  if (wishlist.contains(product.image)) {
                                    wishlist.remove(product.image);
                                    await FileHelper.removeModelFromFile(
                                        product);
                                  } else {
                                    wishlist.add(product.image);
                                    await FileHelper.addModelToFile(product);
                                  }

                                  CustomWidgets.favoriteToggle(wishlist);

                                  setState(() {
                                    isFavorite = !isFavorite;
                                  });

                                  isFavorite
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
                                "Color: ${selectedColor.isEmpty && product.productColors.isEmpty ? "Not found" : selectedColor.isEmpty ? "Please select color" : selectedColor}",
                                style: TextStyle(fontSize: 18),
                              ),
                              if (product.productColors.isNotEmpty)
                                SizedBox(
                                  height: 50,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      var color = product
                                          .productColors[index].hexValue
                                          .replaceFirst("#", "0xFF")
                                          .split(',')[0]
                                          .replaceFirst("#", "0xFF");
                                      return Bounceable(
                                        onTap: () {
                                          setState(() {
                                            selectedColor = product
                                                .productColors[index].colorName;
                                            product.selectedColor =
                                                selectedColor;
                                          });
                                        },
                                        child: CustomWidgets.colorBox(
                                            border: selectedColor ==
                                                product.productColors[index]
                                                    .colorName,
                                            color: Color(int.parse(color))),
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        SizedBox(width: 10),
                                    itemCount: product.productColors.length,
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
                                  if (!isExpanded)
                                    Text(
                                      product.description,
                                      style: TextStyle(fontSize: 16),
                                      textAlign: TextAlign.justify,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  if (isExpanded)
                                    Text(
                                      product.description,
                                      style: TextStyle(fontSize: 16),
                                      textAlign: TextAlign.justify,
                                    ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        isExpanded = !isExpanded;
                                      });
                                    },
                                    child: Text(
                                        isExpanded ? "See less" : "See more"),
                                  ),
                                ],
                              )
                            else
                              CustomWidgets.itemTags(
                                  tagName: "Unknown Description"),
                          ],
                        ),
                        bottomArea(context, product, selectedColor),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget bottomArea(
      BuildContext context, ProductModel item, String isSelectedColor,
      {int quantity = 1}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.60,
          child: OutlinedButton(
            onPressed: () async {
              try {
                if ((isSelectedColor.isEmpty &&
                    item.productColors.isNotEmpty)) {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.warning,
                    text: "Please Select The Color First!",
                    confirmBtnText: "Okay",
                    confirmBtnColor: Colors.red,
                    customAsset:
                        "assets/gif/Warning Anthony Anderson GIF by HULU.gif",
                    title: "Warning",
                  );
                } else {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.success,
                    text: "The item has been added to the cart",
                    confirmBtnText: "Okay",
                    confirmBtnColor: Colors.green,
                    customAsset:
                        "assets/gif/Turn Up Dancing GIF by Rosanna Pansino.gif",
                    title: "Congratulations",
                  );
                  await Add2Cart.addToCart(item, isSelectedColor, quantity);
                }
              } catch (e) {
                print(e);
              }
              qty = await Add2Cart.countItemsInCart();
              setState(() {});
            },
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(),
              backgroundColor: Colors.white,
            ),
            child: Text(
              "Add to cart",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.30,
          child: OutlinedButton(
            onPressed: () async {
              if ((isSelectedColor.isNotEmpty &&
                      isSelectedColor != "unknown") ||
                  item.productColors.isEmpty) {
                var data = await Add2Cart.readModelsFromFile();

                if (data.isNotEmpty) {
                  if (item.productColors.isEmpty) {
                    var temp = data.where(
                      (element) => element.image != item.image,
                    );

                    if (temp.isEmpty) {
                      await Add2Cart.addToCart(item, item.selectedColor, 1);

                      data = await Add2Cart.readModelsFromFile();
                    }
                  } else {
                    var temp = data.where(
                      (element) => (element.title == item.title &&
                          element.selectedColor != item.selectedColor),
                    );

                    if (temp.isEmpty) {
                      await Add2Cart.addToCart(item, item.selectedColor, 1);
                    }

                    data = await Add2Cart.readModelsFromFile();
                  }
                } else {
                  await Add2Cart.addToCart(item, item.selectedColor, 1);
                  data = await Add2Cart.readModelsFromFile();
                }

                Navigator.pushNamed(context, Routes.buyNowPage,
                    arguments: data);
              } else {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.warning,
                  text: "Please Select The Color First!",
                  confirmBtnText: "Okay",
                  confirmBtnColor: Colors.red,
                  customAsset:
                      "assets/gif/Warning Anthony Anderson GIF by HULU.gif",
                  title: "Warning",
                );
              }
            },
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(),
              backgroundColor: Colors.black,
            ),
            child: Text(
              "Buy Now",
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
