import 'package:custom_scroll_view/data/exports.dart';

class BuyNowPage extends StatefulWidget {
  const BuyNowPage({super.key});

  @override
  State<BuyNowPage> createState() => _BuyNowPageState();
}

class _BuyNowPageState extends State<BuyNowPage> {
  int numberOfItmes = 1;

  @override
  Widget build(BuildContext context) {
    var products = ModalRoute.of(context)?.settings.arguments as List<dynamic>;

    var product = Product.fromJson(products[0] as Map<String, dynamic>);
    var color = products[1];

    double updatePrice({int? amount}) {
      amount = amount ?? 0;

      return amount * double.parse(product.price);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context, [
            products[0] as Map<String, dynamic>,
            numberOfItmes,
          ]),
          child: Icon(Icons.arrow_back),
        ),
        title: Text(
          "Orders",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: Column(
            spacing: 20,
            children: [
              GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, Routes.locationScreen),
                child: listItems(
                    title: Text(
                      "Delivery Location",
                      style: TextStyle(fontSize: 18),
                    ),
                    description: Text("42 St 606, Phnom Penh")),
              ),
              GestureDetector(
                onTap: () => CustomWidgets.inputField(context),
                child: listItems(
                    leading: Icon(Icons.phone),
                    title:
                        Text("Contact Number", style: TextStyle(fontSize: 18)),
                    description: Text("Enter your contact number")),
              ),
              listItems(
                  leading: Image.asset(
                    "assets/icons/Cash in Hand.png",
                  ),
                  title: Text("Payment", style: TextStyle(fontSize: 18)),
                  description: Text("Cash on delivery")),
              listItems(
                title: Text(product.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                description: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Price : ${product.currencySign}${product.price}",
                        style: TextStyle(fontSize: 16)),
                    Text("Color : $color", style: TextStyle(fontSize: 16)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () => setState(() {
                            numberOfItmes++;
                            updatePrice(amount: numberOfItmes);
                          }),
                          child: boxButton(
                              child: Icon(
                            Icons.add,
                            size: 20,
                          )),
                        ),
                        boxButton(
                          child: Text(
                            numberOfItmes.toString(),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() {
                            if (numberOfItmes > 1) {
                              numberOfItmes--;
                              updatePrice(amount: numberOfItmes);
                            }
                          }),
                          child: boxButton(
                            child: Icon(Icons.remove, size: 20),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                leading: SizedBox(
                  height: 120,
                  child: productPicture(
                    image: NetworkImage(product.featureImageUrl),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => CustomWidgets.inputField(context,
                    title: "Coupons Code",
                    hintText: "Enter Your Coupons Code",
                    prefixIcon: Icon(Icons.code)),
                child: listItems(
                  leading: Image.asset("assets/icons/Voucher.png"),
                  title: Text("Coupons", style: TextStyle(fontSize: 18)),
                  description: Text("Enter code to get discount"),
                ),
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
                          Text("Order Summary (2 items)",
                              style: TextStyle(fontSize: 18)),
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
                                Text("Sub total",
                                    style: TextStyle(fontSize: 16)),
                                Text("Sub total",
                                    style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.90,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Discount",
                                    style: TextStyle(fontSize: 16)),
                                Text("---------",
                                    style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.90,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Total", style: TextStyle(fontSize: 16)),
                                Text(
                                    "${product.currencySign}${updatePrice(amount: numberOfItmes)}",
                                    style: TextStyle(fontSize: 16)),
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
                      "${product.currencySign}${updatePrice(amount: numberOfItmes)}",
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
