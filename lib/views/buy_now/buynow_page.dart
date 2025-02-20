import 'package:custom_scroll_view/bloc/buy_now_/buy_now_bloc.dart';
import 'package:custom_scroll_view/bloc/buy_now_/buy_now_event.dart';
import 'package:custom_scroll_view/bloc/buy_now_/buy_now_state.dart';
import 'package:custom_scroll_view/data/exports.dart';
import 'package:custom_scroll_view/models/detail_product.dart';
import 'package:custom_scroll_view/models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import '../../data/coupons_code.dart';

class BuyNowPage extends StatelessWidget {
  const BuyNowPage({super.key});

  @override
  Widget build(BuildContext context) {
    var product =
        ModalRoute.of(context)!.settings.arguments as List<ProductModel>;
    return BlocProvider(
        create: (context) => BuyNowBloc()
          ..add(LoadProducts(product))
          ..add(UpdateBillingAddress("Cash On Delivery"))
          ..add(UpdateCoupons("Apply coupon"))
          ..add(UpdatePhoneNumber("Enter a phone number"))
          ..add(UpdateShippingAddress("Enter your location"))
          ..add(UpdatePrice())
          ..add(UpdatePriceWithoutDiscount()),
        child: BuyNowView());
  }
}

class BuyNowView extends StatelessWidget {
  const BuyNowView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BuyNowBloc, BuyNowState>(
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              surfaceTintColor: Colors.white,
              centerTitle: true,
              backgroundColor: Colors.white,
              title: Text("Buy Now"),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.shopping_cart),
                ),
              ],
            ),
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        spacing: 20,
                        children: [
                          delivery(context, state.location),
                          contactNumber(context, state.phoneNumber),
                          paymentMethods(context, state.paymentMethod),
                        ],
                      ),
                    ),
                    Expanded(child: productView(context, state.products)),
                    Expanded(
                      flex: 2,
                      child: Column(
                        spacing: 20,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: couponsWidget(
                                context, state.coupon, state.discountRate),
                          ),
                          orderSummary(
                              context,
                              state.price,
                              state.discountRate,
                              state.priceWithoutDiscount,
                              state.products.length),
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
                    Text(
                      "USD ${state.price}",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
    );
  }
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
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              )),
        ),
        if (hasSelected)
          Bounceable(
              onTap: () {},
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
              onTap: () =>
                  context.read<BuyNowBloc>().add(DecrementQuantity(index)),
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
              onTap: () =>
                  context.read<BuyNowBloc>().add(IncrementQuantity(index)),
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

Widget productView(BuildContext context, List<ProductModel> products,
    {bool? isSelected, bool hasSelected = false}) {
  return ListView.separated(
      itemBuilder: (context, index) {
        final product = products[index];
        return listProductView(context, product, isSelected,
            hasSelected: hasSelected, index: index);
      },
      separatorBuilder: (context, index) => SizedBox(
            height: 10,
          ),
      itemCount: products.length);
}

Widget couponsWidget(
    BuildContext context, String? couponss, double? discountRate) {
  return GestureDetector(
    onTap: () async {
      var couponCode = await CustomWidgets.inputField(context,
          title: "Coupons Code",
          hintText: "Enter Your Coupons Code",
          prefixIcon: Icon(Icons.code));

      if (couponCode is String) {
        context.read<BuyNowBloc>().add(UpdateCoupons(couponCode));

        for (var code in coupons) {
          if (code['code'] == couponCode) {
            context.read<BuyNowBloc>().add(
                UpdateDiscountRate(double.parse(code['value'].toString())));

            context.read<BuyNowBloc>().add(UpdatePrice());
            break;
          }
        }
      }
    },
    child: listItems(
      leading: Image.asset("assets/icons/Voucher.png"),
      title: Text("Coupons", style: TextStyle(fontSize: 18)),
      description: Row(
        spacing: 5,
        children: [
          Text(couponss ?? "Enter code to get discount"),
          discountRate != 0
              ? Text(
                  "$discountRate%",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                )
              : Text("")
        ],
      ),
      noTrailing: true,
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

Widget paymentMethods(BuildContext context, String? paymentMethod) {
  return GestureDetector(
    onTap: () async {
      var selectedPaymentMethod =
          await Navigator.pushNamed(context, Routes.paymentMethod) ??
              "Cash On Delivery";

      if (selectedPaymentMethod is String) {
        context
            .read<BuyNowBloc>()
            .add(UpdateBillingAddress(selectedPaymentMethod));
      }
    },
    child: listItems(
      leading: Image.asset(
        "assets/icons/Cash in Hand.png",
      ),
      title: Text("Payment", style: TextStyle(fontSize: 18)),
      description: Text(paymentMethod ?? "Cash on delivery"),
      noTrailing: true,
    ),
  );
}

Widget contactNumber(BuildContext context, String? phoneNumber) {
  return GestureDetector(
    onTap: () async {
      var contactNumber = await CustomWidgets.inputField(context,
          typeInput: TextInputType.phone);

      if (contactNumber is String) {
        context.read<BuyNowBloc>().add(UpdatePhoneNumber(contactNumber));
      }
    },
    child: listItems(
      leading: Icon(Icons.phone),
      title: Text("Contact Number", style: TextStyle(fontSize: 18)),
      description: Text(phoneNumber ?? "Enter your contact number"),
      noTrailing: true,
    ),
  );
}

Widget delivery(BuildContext context, String? location) {
  return GestureDetector(
    onTap: () async {
      var location = await Navigator.pushNamed(context, Routes.locationScreen);

      if (location is String) {
        context.read<BuyNowBloc>().add(UpdateShippingAddress(location));
      }
    },
    child: listItems(
      title: Text(
        "Delivery Location",
        style: TextStyle(fontSize: 18),
      ),
      description: Text(location ?? "42 St 606, Phnom Penh"),
      noTrailing: true,
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
