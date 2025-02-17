import 'package:custom_scroll_view/bloc/buy_now_/buy_now_bloc.dart';
import 'package:custom_scroll_view/bloc/buy_now_/buy_now_event.dart';
import 'package:custom_scroll_view/bloc/buy_now_/buy_now_state.dart';
import 'package:custom_scroll_view/data/exports.dart';
import 'package:custom_scroll_view/models/detail_product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuyNowPage extends StatelessWidget {
  const BuyNowPage({super.key});

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as DetailProduct;
    return BlocProvider(
      create: (context) => BuyNowBloc(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back),
          ),
          title: Text(
            "Orders",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: BuyNowView(),
      ),
    );
  }
}

class BuyNowView extends StatelessWidget {
  const BuyNowView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BuyNowBloc, BuyNowState>(
      builder: (context, state) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              spacing: 20,
              children: [
                delivery(context, state.location),
                contactNumber(context, state.phoneNumber),
                paymentMethods(context, state.paymentMethod),
                productView(context, state.products),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget productView(BuildContext context, List<Product> products) {
  return ListView.separated(
      itemBuilder: (context, index) {
        final product = products[index];
        return listItems(
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
              // Text("Color : $selectedColor", style: TextStyle(fontSize: 16)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      //   => setState(() {
                      //   numberOfItmes++;
                      //   updatePrice(amount: numberOfItmes);
                      // })
                    },
                    child: boxButton(
                        child: Icon(
                      Icons.add,
                      size: 20,
                    )),
                  ),
                  boxButton(
                    child: Text(""
                        // numberOfItmes.toString(),
                        ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // => setState(() {
                      // if (numberOfItmes > 1) {
                      //   numberOfItmes--;
                      //   updatePrice(amount: numberOfItmes);
                      // }
                    },
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
        );
      },
      separatorBuilder: (context, index) => SizedBox(
            height: 10,
          ),
      itemCount: products.length);
}

Widget couponsWidget(BuildContext context, String? coupons) {
  return GestureDetector(
    onTap: () async {
      var couponCode = await CustomWidgets.inputField(context,
          title: "Coupons Code",
          hintText: "Enter Your Coupons Code",
          prefixIcon: Icon(Icons.code));

      if (couponCode is String) {
        context.read<BuyNowBloc>().add(UpdateCoupons(couponCode));
      }
    },
    child: listItems(
      leading: Image.asset("assets/icons/Voucher.png"),
      title: Text("Coupons", style: TextStyle(fontSize: 18)),
      description: Text(coupons ?? "Enter code to get discount"),
    ),
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
        title: Text(paymentMethod ?? "Payment", style: TextStyle(fontSize: 18)),
        description: Text(paymentMethod ?? "Cash on delivery")),
  );
}

Widget contactNumber(BuildContext context, String phoneNumber) {
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
        description: Text(phoneNumber ?? "Enter your contact number")),
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
          location ?? "Delivery Location",
          style: TextStyle(fontSize: 18),
        ),
        description: Text("42 St 606, Phnom Penh")),
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
  double spacing = 10,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    child: Row(
      spacing: spacing,
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
