import 'package:flutter_level_01/data/exports.dart';
import 'package:flutter_level_01/utils/add_2_cart_helper.dart';
import 'package:flutter_level_01/models/product_model.dart';
import 'package:flutter_level_01/views/buy_now/buynow_page.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class AddToCartsScreen extends StatefulWidget {
  const AddToCartsScreen({super.key});

  @override
  State<AddToCartsScreen> createState() => _AddToCartsScreenState();
}

class _AddToCartsScreenState extends State<AddToCartsScreen> {
  List<ProductModel> productsa = [];
  double price = 0.0;
  Map<int, bool> selectedItems = {};

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final cartItems = await Add2Cart.readModelsFromFile();

    final totalPrice = await _calculateTotalPrice();
    setState(() {
      productsa = cartItems;
      price = totalPrice;
      selectedItems = {for (var i = 0; i < cartItems.length; i++) i: false};
    });
  }

  Future<double> _calculateTotalPrice() async {
    double total = 0;

    var selectedProduct = productsa
        .where((item) => selectedItems[productsa.indexOf(item)] == true)
        .toList();

    for (var product in selectedProduct) {
      total += (double.tryParse(product.price) ?? 0) * product.qty;
    }

    setState(() {
      price = total;
    });

    return total;
  }

  int _countSelectedItems(Map<int, bool> data) {
    int count = 0;

    for (var item in data.values) {
      if (item == true) {
        count++;
      }
    }

    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Carts",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: Bounceable(
            onTap: () async =>
                Navigator.pop(context, await Add2Cart.countItemsInCart()),
            child: Icon(Icons.arrow_back)),
        actions: [
          Bounceable(
            onTap: () {
              if (_countSelectedItems(selectedItems) == 0) {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.warning,
                  text: "Please Select The Product to delete first!",
                  confirmBtnText: "Okay",
                  confirmBtnColor: Colors.red,
                  customAsset:
                      "assets/gif/Warning Anthony Anderson GIF by HULU.gif",
                  title: "Warning",
                );
              } else {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.confirm,
                  text:
                      "Do you want to remove ${_countSelectedItems(selectedItems) > 1 ? "these items" : "this item"} ?",
                  confirmBtnText: "Yes",
                  cancelBtnText: "No",
                  confirmBtnColor: Colors.red,
                  customAsset: "assets/gif/ConfusedTheOffice.gif",
                  title: "Are you sure?",
                  onConfirmBtnTap: () async {
                    productsa.removeWhere((item) {
                      bool isSelected =
                          selectedItems[productsa.indexOf(item)] == true;

                      if (isSelected) {
                        Add2Cart.removeFromCart(item, item.selectedColor);
                      }
                      return isSelected;
                    });
                    setState(() {});
                    Navigator.pop(context);
                  },
                );
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(Icons.delete),
            ),
          )
        ],
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Expanded(
              child: productsa.isEmpty
                  ? CustomWidgets.noWishListData(context)
                  : ListView.separated(
                      itemBuilder: (context, index) {
                        return listProduct(
                          context,
                          productsa[index],
                          selectedItems[
                              index], // Pass individual item selection state
                          hasSelected: true,
                          index: index,
                        );
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 15),
                      itemCount: productsa.length),
            )
          ],
        ),
      ),
      bottomSheet: productsa.isEmpty
          ? CustomWidgets.noWishListData(context, hasButton: false)
          : Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  spacing: 90,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "USD $price",
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        if (_countSelectedItems(selectedItems) > 0)
                          Text(_countSelectedItems(selectedItems) > 1
                              ? "${_countSelectedItems(selectedItems)} items"
                              : "${_countSelectedItems(selectedItems)} item")
                      ],
                    ),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          var selectedProduct = productsa
                              .where((item) =>
                                  selectedItems[productsa.indexOf(item)] ==
                                  true)
                              .toList();

                          if (selectedProduct.isEmpty) {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.warning,
                              text:
                                  "Please Select The Product to checkout first!",
                              confirmBtnText: "Okay",
                              confirmBtnColor: Colors.red,
                              customAsset:
                                  "assets/gif/Warning Anthony Anderson GIF by HULU.gif",
                              title: "Warning",
                            );
                          } else {
                            Navigator.pushNamed(context, Routes.buyNowPage,
                                arguments: selectedProduct);
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(),
                          backgroundColor: Colors.black,
                        ),
                        child: Text(
                          "Check Out",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget listProduct(
      BuildContext context, ProductModel product, bool? isSelected,
      {bool hasSelected = false, int index = 0}) {
    return listItems(
      noTrailing: true,
      title: Row(
        spacing: hasSelected ? 20 : 0,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(product.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
          ),
          if (hasSelected)
            Bounceable(
                onTap: () {
                  selectedItems[index] = !(selectedItems[index] ?? false);
                  _calculateTotalPrice();
                  setState(() {});
                },
                child: (isSelected ?? false)
                    ? Icon(Icons.check_circle)
                    : Icon(Icons.circle))
        ],
      ),
      description: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Price : ${product.priceSign}${product.price}",
              style: TextStyle(fontSize: 16)),
          if (product.selectedColor.isNotEmpty)
            Text("Color : ${product.selectedColor}",
                style: TextStyle(fontSize: 16)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Bounceable(
                onTap: () async {
                  var qty = product.qty;
                  if (--qty == 0) {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.confirm,
                      text: "Do you want to remove this item?",
                      confirmBtnText: "Yes",
                      cancelBtnText: "No",
                      confirmBtnColor: Colors.red,
                      customAsset: "assets/gif/ConfusedTheOffice.gif",
                      title: "Are you sure?",
                      onConfirmBtnTap: () async {
                        await Add2Cart.removeFromCart(
                            product, product.selectedColor);

                        await _loadInitialData();

                        Navigator.pop(context);
                      },
                    );
                  } else {
                    setState(() {
                      productsa[index].qty = qty;
                    });
                    price = await _calculateTotalPrice();

                    await Add2Cart.updateCart(
                        product, product.selectedColor, product.qty);

                    setState(() {});
                  }
                },
                child: boxButton(
                    child: Icon(
                  Icons.remove,
                  size: 20,
                )),
              ),
              boxButton(
                child: Text(product.qty.toString()),
              ),
              Bounceable(
                onTap: () async {
                  setState(() {
                    productsa[index].qty++;
                  });

                  await Add2Cart.updateCart(
                      product, product.selectedColor, product.qty);

                  price = await _calculateTotalPrice();
                  setState(() {});
                },
                child: boxButton(
                  child: Icon(Icons.add, size: 20),
                ),
              ),
            ],
          )
        ],
      ),
      leading: SizedBox(
        height: 120,
        child: productPicture(
          image: NetworkImage(product.image),
        ),
      ),
    );
  }
}
