import 'package:flutter_level_01/models/product_model.dart';
import 'package:flutter_level_01/utils/add_2_cart_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:intl/intl.dart';

import '../../data/coupons_code.dart';
import '../../routes/routes.dart';
import '../../utils/order_helper.dart';
import '../../widgets/widgets.dart';

class BuyNowPage extends StatefulWidget {
  const BuyNowPage({super.key});

  @override
  State<BuyNowPage> createState() => _BuyNowPageState();
}

class _BuyNowPageState extends State<BuyNowPage> {
  late List<ProductModel> products;
  String billingAddress = "Cash On Delivery";
  String? coupon = "Apply coupon";
  String phoneNumber = "Enter a phone number";
  String shippingAddress = "Enter your location";
  double price = 0.0;
  double priceWithoutDiscount = 0.0;
  double discountRate = 0.0;
  bool isPlaceOrder = false;
  bool isCompleted = false;
  bool isShowMessage = false;
  String orderId = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    products = ModalRoute.of(context)!.settings.arguments as List<ProductModel>;
    updatePrices();
  }

  void updatePrices() {
    double total = 0.0;
    for (var product in products) {
      total += (double.parse(product.price) * product.qty);
    }
    setState(() {
      priceWithoutDiscount = total;
      price = discountRate != 0 ? total - (total * discountRate / 100) : total;
    });
  }

  void incrementQuantity(int index) {
    setState(() {
      products[index].qty++;
      updatePrices();
    });
  }

  void decrementQuantity(int index) {
    setState(() {
      if (products[index].qty > 1) {
        products[index].qty--;
        updatePrices();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(!isPlaceOrder ? "Order" : orderId),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 79),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: orderMessage(),
              ),
              SliverToBoxAdapter(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 20,
                  children: [
                    delivery(context, shippingAddress),
                    contactNumber(context, phoneNumber),
                    paymentMethods(context, billingAddress),
                  ],
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = products[index];
                    return listProductView(context, product, false,
                        hasSelected: false, index: index);
                  },
                  childCount: products.length,
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 20,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: couponsWidget(
                        context,
                        coupon,
                        discountRate,
                      ),
                    ),
                    orderSummary(context, price, discountRate,
                        priceWithoutDiscount, products.length),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            spacing: 90,
            children: [
              if (isPlaceOrder)
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.35,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isCompleted ? "Completed" : "Process".toUpperCase(),
                        style: TextStyle(
                            color:
                                isCompleted ? Colors.green : Colors.yellow[700],
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(_getCurrentDate())
                    ],
                  ),
                )
              else
                Text(
                  "USD $price",
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold),
                ),
              Expanded(
                child: OutlinedButton(
                  onPressed: isPlaceOrder
                      ? () {
                          setState(() {
                            isCompleted = true;
                          });
                        }
                      : () {
                          setState(() {
                            orderId = generateOrderId();
                            isPlaceOrder = true;
                            OrderSaver.saveOrder(
                                products, this.shippingAddress, orderId, 0);

                            products.map(
                              (element) => Add2Cart.removeFromCart(
                                  element, element.selectedColor),
                            );
                          });
                        },
                  style: isPlaceOrder
                      ? OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(),
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.black),
                        )
                      : OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(),
                          backgroundColor: Colors.black,
                        ),
                  child: Text(
                    isCompleted
                        ? "Received"
                        : isPlaceOrder
                            ? "Mark as Received"
                            : "Place Order",
                    style: TextStyle(
                      color: isPlaceOrder ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String generateOrderId() {
    return "ORDER-${DateTime.now().millisecondsSinceEpoch}-KH";
  }

  void delayed() {
    Future.delayed(Duration(seconds: 3)).then(
      (value) {
        setState(() {
          isShowMessage = true;
        });
      },
    );
  }

  Widget orderMessage() {
    return Bounceable(
      onTap: () => setState(() {
        delayed();
      }),
      child: AnimatedContainer(
        height: !isShowMessage
            ? isPlaceOrder
                ? 70
                : 0
            : 0,
        duration: Duration(milliseconds: 400),
        child: Container(
          color: Colors.black,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "We had received your order, our customer service will contact you shortly. Thank you for shopping with us.",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getCurrentDate() {
    DateTime now = DateTime.now();
    return DateFormat('h:mm a, dd-MM-yyyy').format(now);
  }

  Widget delivery(BuildContext context, String? location) {
    return GestureDetector(
      onTap: isPlaceOrder
          ? null
          : () async {
              var newLocation =
                  await Navigator.pushNamed(context, Routes.locationScreen);
              if (newLocation is String) {
                setState(() {
                  shippingAddress = newLocation;
                });
              }
            },
      child: listItems(
        title: const Text("Delivery Location", style: TextStyle(fontSize: 18)),
        description: Text(location ?? "42 St 606, Phnom Penh"),
        noTrailing: true,
      ),
    );
  }

  Widget contactNumber(BuildContext context, String? phoneNumber) {
    return GestureDetector(
      onTap: isPlaceOrder
          ? null
          : () async {
              var newContactNumber = await CustomWidgets.inputField(context,
                  typeInput: TextInputType.phone);
              if (newContactNumber is String) {
                setState(() {
                  this.phoneNumber = newContactNumber;
                });
              }
            },
      child: listItems(
        leading: const Icon(Icons.phone),
        title: const Text("Contact Number", style: TextStyle(fontSize: 18)),
        description: Text(phoneNumber ?? "Enter your contact number"),
        noTrailing: true,
      ),
    );
  }

  Widget paymentMethods(BuildContext context, String? paymentMethod) {
    return GestureDetector(
      onTap: isPlaceOrder
          ? null
          : () async {
              var selectedPaymentMethod =
                  await Navigator.pushNamed(context, Routes.paymentMethod) ??
                      "Cash On Delivery";
              if (selectedPaymentMethod is String) {
                setState(() {
                  billingAddress = selectedPaymentMethod;
                });
              }
            },
      child: listItems(
        leading: Image.asset("assets/icons/Cash in Hand.png"),
        title: const Text("Payment", style: TextStyle(fontSize: 18)),
        description: Text(paymentMethod ?? "Cash on delivery"),
        noTrailing: true,
      ),
    );
  }

  Widget couponsWidget(
      BuildContext context, String? couponss, double? discountRate) {
    return GestureDetector(
      onTap: isPlaceOrder
          ? null
          : () async {
              var couponCode = await CustomWidgets.inputField(context,
                  title: "Coupons Code",
                  hintText: "Enter Your Coupons Code",
                  prefixIcon: const Icon(Icons.code));

              if (couponCode is String) {
                this.discountRate = 0;

                setState(() {
                  coupon = couponCode;
                  for (var code in coupons) {
                    if (code['code'] == couponCode) {
                      this.discountRate =
                          double.parse(code['value'].toString());
                      updatePrices();
                      break;
                    }
                  }
                });
              }
            },
      child: listItems(
        leading: Image.asset("assets/icons/Voucher.png"),
        title: const Text("Coupons", style: TextStyle(fontSize: 18)),
        description: Row(
          spacing: 5,
          children: [
            Text(couponss ?? "Enter code to get discount"),
            discountRate != 0
                ? Text(
                    "$discountRate%",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red),
                  )
                : couponss == "Apply coupon"
                    ? Text("")
                    : Text(
                        "- Invalid Code",
                        style: TextStyle(color: Colors.red),
                      )
          ],
        ),
        noTrailing: true,
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
          if (!isPlaceOrder)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Bounceable(
                  onTap: () => decrementQuantity(index),
                  child: boxButton(child: const Icon(Icons.remove, size: 20)),
                ),
                boxButton(child: Text(product.qty.toString())),
                Bounceable(
                  onTap: () => incrementQuantity(index),
                  child: boxButton(child: const Icon(Icons.add, size: 20)),
                ),
              ],
            )
          else
            Text("x${product.qty}")
        ],
      ),
      leading: SizedBox(
        height: 120,
        child: productPicture(image: NetworkImage(product.image)),
      ),
    );
  }

  Widget orderSummary(BuildContext context, double price, double discount,
      double priceWithoutDiscount, int numberOfProducts) {
    return Column(
      spacing: 10,
      children: [
        listItems(
          leading: Icon(
            Icons.receipt,
          ),
          title: Text(
              "Order Summary (${numberOfProducts > 1 ? "$numberOfProducts items" : "$numberOfProducts item"})",
              style: TextStyle(fontSize: 18)),
          noDescription: true,
          noTrailing: true,
        ),
        Column(
          children: [
            listItems(
              leading: Text("Sub Total", style: TextStyle(fontSize: 17.5)),
              trailing: Text("USD $priceWithoutDiscount",
                  style: TextStyle(fontSize: 17.5)),
              noDescription: true,
              noTitle: true,
            ),
            listItems(
              leading: Text("Discount", style: TextStyle(fontSize: 17.5)),
              trailing: Text(discount == 0 ? "------" : "$discount%",
                  style: TextStyle(fontSize: 17.5)),
              noDescription: true,
              noTitle: true,
            ),
            listItems(
              leading: Text("Total", style: TextStyle(fontSize: 18)),
              trailing: Text("USD $price", style: TextStyle(fontSize: 18)),
              noDescription: true,
              noTitle: true,
            ),
          ],
        )
      ],
    );
  }
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
  bool noTrailing = false,
  double spacing = 10,
  Widget? trailing,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    child: Row(
      spacing: noTitle ? 0 : spacing,
      mainAxisAlignment:
          noTitle ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
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
          ),
        if (noTrailing == false) trailing ?? Icon(Icons.arrow_forward_ios),
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
