import 'package:flutter_level_01/models/order_model.dart';
import 'package:flutter_level_01/utils/order_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

import '../models/product_model.dart';
import 'buy_now/buynow_page.dart';

class MyOrderDetails extends StatefulWidget {
  const MyOrderDetails({super.key});

  @override
  State<MyOrderDetails> createState() => _MyOrderDetailsState();
}

class _MyOrderDetailsState extends State<MyOrderDetails> {
  List<OrderDetailsModel> prod = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> loadOrderData(BuildContext context) async {
    var order = ModalRoute.of(context)?.settings.arguments ?? [];
    await OrderSaver.getOrderItems("ORDER-1740327325145-KH", 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order ID"),
      ),
      body: productView(
        context,
        [],
        hasSelected: false,
        isSelected: false,
      ),
    );
  }

  Widget productView(BuildContext context, List<ProductModel> products,
      {bool? isSelected, bool hasSelected = false}) {
    return ListView.separated(
      itemBuilder: (context, index) {
        final product = products[index];
        return listProductView(context, product, isSelected,
            hasSelected: hasSelected, index: index);
      },
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemCount: products.length,
    );
  }

  Widget listProductView(
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
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
          ),
          if (hasSelected)
            Bounceable(
                onTap: () {},
                child: isSelected == null || isSelected == false
                    ? const Icon(Icons.circle)
                    : const Icon(Icons.check_circle))
        ],
      ),
      description: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Price : ${product.priceSign}${product.price}",
              style: const TextStyle(fontSize: 16)),
          if (product.selectedColor.isNotEmpty)
            Text("Color : ${product.selectedColor}",
                style: const TextStyle(fontSize: 16)),
          // if (!isPlaceOrder)
          //   Row(
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     children: [
          //       Bounceable(
          //         onTap: () {},
          //         child: boxButton(child: const Icon(Icons.remove, size: 20)),
          //       ),
          //       boxButton(child: Text(product.qty.toString())),
          //       Bounceable(
          //         onTap: () {},
          //         child: boxButton(child: const Icon(Icons.add, size: 20)),
          //       ),
          //     ],
          //   )
          // else
          Text("x${product.qty}")
        ],
      ),
      leading: SizedBox(
        height: 120,
        child: productPicture(image: NetworkImage(product.image)),
      ),
    );
  }
}
