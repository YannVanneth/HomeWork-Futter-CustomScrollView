import 'package:custom_scroll_view/bloc/addToCarts/add_bloc.dart';
import 'package:custom_scroll_view/bloc/addToCarts/add_event.dart';
import 'package:custom_scroll_view/bloc/addToCarts/add_state.dart';
import 'package:custom_scroll_view/data/exports.dart';
import 'package:custom_scroll_view/databases/add_2_cart_helper.dart';
import 'package:custom_scroll_view/models/product_model.dart';
import 'package:custom_scroll_view/views/buy_now/buynow_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../models/detail_product.dart';

class AddToCartsScreen extends StatelessWidget {
  const AddToCartsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddToCartsBloc()
        ..add(LoadCartItem())
        ..add(UpdatePriceWithoutDiscount()),
      child: BlocBuilder<AddToCartsBloc, AddToCartsState>(
        builder: (context, state) {
          if (state.price == 0) {
            context.read<AddToCartsBloc>().add(UpdatePriceWithoutDiscount());
          }

          if (state.product.isEmpty) {
            context.read<AddToCartsBloc>().add(LoadCartItem());
          }
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Text(
                  "Carts",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                backgroundColor: Colors.white,
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Expanded(
                      child: state.product.isEmpty
                          ? CustomWidgets.noWishListData(context)
                          : ListView.separated(
                              itemBuilder: (context, index) {
                                var product = state.product;

                                return listProduct(
                                  context,
                                  product[index],
                                  state.isSelected,
                                  hasSelected: true,
                                  index: index,
                                );
                              },
                              separatorBuilder: (context, index) => SizedBox(
                                    height: 15,
                                  ),
                              itemCount: state.product.length),
                    )
                  ],
                ),
              ),
              bottomSheet: state.product.isEmpty
                  ? CustomWidgets.noWishListData(context, hasButton: false)
                  : Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Row(
                          spacing: 90,
                          children: [
                            Text(
                              "USD ${state.price}",
                              style: TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(),
                                  backgroundColor: Colors.black,
                                ),
                                child: Text(
                                  "Place Order",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ));
        },
      ),
    );
  }

  Widget listProduct(
      BuildContext context, ProductModel product, bool? isSelected,
      {bool hasSelected = false, int index = 0}) {
    context.read<AddToCartsBloc>().add(LoadCartItem());
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
                onTap: () =>
                    context.read<AddToCartsBloc>().add(ToggleCheckbox()),
                child: isSelected == null || isSelected == false
                    ? Icon(Icons.circle)
                    : Icon(Icons.check_circle))
        ],
      ),
      description: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Price : ${product.priceSign}${product.price}",
              style: TextStyle(fontSize: 16)),
          Text("Color : ${product.selectedColor}",
              style: TextStyle(fontSize: 16)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Bounceable(
                onTap: () {
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
                      onConfirmBtnTap: () {
                        Add2Cart.removeFromCart(
                          product,
                          product.selectedColor,
                        );
                        Navigator.pop(context);
                      },
                    );
                  }
                  context
                      .read<AddToCartsBloc>()
                      .add(DecrementQuantity(index: index));
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
                onTap: () => context
                    .read<AddToCartsBloc>()
                    .add(IncrementQuantity(index: index)),
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
