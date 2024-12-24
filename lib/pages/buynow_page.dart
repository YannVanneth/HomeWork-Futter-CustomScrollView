import 'package:custom_scroll_view/data/exports.dart';

class BuyNowPage extends StatelessWidget {
  const BuyNowPage({super.key});

  @override
  Widget build(BuildContext context) {
    var products = ModalRoute.of(context)?.settings.arguments as Product;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("Orders"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: Column(
            spacing: 20,
            children: [
              listItems(
                  title: Text("Delivery Location"),
                  description: Text("42 St 606, Phnom Penh")),
              listItems(
                  leading: Icon(Icons.phone),
                  title: Text("Contact Number"),
                  description: Text("Enter your contact number")),
              listItems(
                  leading: Image.asset(
                    "assets/icons/Cash in Hand.png",
                  ),
                  title: Text("Payment"),
                  description: Text("Cash on delivery")),
              listItems(
                title: Text(products.name),
                description: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Price ${products.currencySign}${products.price}"),
                    Text("Color :"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        boxButton(
                            child: Icon(
                          Icons.add,
                          size: 20,
                        )),
                        boxButton(),
                        boxButton(child: Icon(Icons.remove, size: 20)),
                      ],
                    )
                  ],
                ),
                leading: SizedBox(
                  height: 120,
                  child: productPicture(
                    image: NetworkImage(products.featureImageUrl),
                  ),
                ),
              ),
              listItems(
                leading: Image.asset("assets/icons/Voucher.png"),
                title: Text("Coupons"),
                description: Text("Enter code to get discount"),
              ),
              Expanded(
                child: listItems(
                  leading: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        spacing: 10,
                        children: [
                          Image.asset("assets/icons/Purchase Order.png"),
                          Text("Order Summary (2 items)"),
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.90,
                        child: Divider(),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.90,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Sub total"),
                                Text("Sub total"),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.90,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Discount"),
                                Text("---------"),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.90,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Total"),
                                Text("US \$23"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  noTitle: true,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "US \$23",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                          backgroundColor: Colors.black),
                      child: Text(
                        "Place Order",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      //   child: ProductDetailsPageState().bottomArea(context, products),
      // ),
    );
  }

  Widget boxButton(
      {double? width,
      double? height,
      Widget? child,
      Decoration? decoration,
      double borderWidth = 0.8}) {
    return Container(
      width: width ?? 30,
      height: height ?? 30,
      decoration: decoration ??
          BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(2)),
            border: Border.all(color: Colors.black, width: borderWidth),
          ),
      child: Center(child: child ?? Text("1")),
    );
  }

  Widget listItems({
    Widget? title,
    Widget? description,
    Widget? leading,
    bool noDescription = false,
    bool noLeading = false,
    bool noTitle = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (noLeading == false)
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [leading ?? Icon(Icons.delivery_dining)],
            ),
          if (noTitle == false)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title ?? Text("Title"),
                  if (noDescription == false)
                    description ??
                        Text(
                          "Product Description",
                          textAlign: TextAlign.start,
                        ),
                ],
              ),
            )
        ],
      ),
    );
  }

  Widget productPicture({double size = 140, NetworkImage? image}) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: image ?? AssetImage("assets/images/iphone12.jpg"),
            fit: BoxFit.contain),
      ),
    );
  }
}
