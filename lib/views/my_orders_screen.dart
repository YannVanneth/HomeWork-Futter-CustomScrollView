import 'package:flutter_level_01/data/exports.dart';
import 'package:flutter_level_01/utils/order_helper.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:intl/intl.dart';

import '../models/order_model.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  List<OrderModel> orderInvoices = [];

  @override
  void initState() {
    super.initState();
    fetchOrderInvoices();
  }

  Future<void> fetchOrderInvoices() async {
    orderInvoices = (await OrderSaver.getAllOrders(0))
        .map(
          (e) => OrderModel.fromJSON(e),
        )
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          title: Text('My Orders'),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: orderInvoices.isEmpty
              ? CustomWidgets.noWishListData(context)
              : ListView.separated(
                  itemBuilder: (context, index) {
                    final order = orderInvoices[index];
                    return Bounceable(
                      onTap: () =>
                          Navigator.pushNamed(context, Routes.myOrdersDetails),
                      child: orderListItem(order),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(
                        height: 10,
                      ),
                  itemCount: orderInvoices.length),
        ));
  }

  Widget orderListItem(OrderModel order) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.65,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('#${order.invoiceId}'),
              Text(DateFormat("h:mm a, dd-MM-yyyy")
                  .format(DateTime.parse(order.orderDate))),
            ],
          ),
        ),
        Row(
          children: [
            Text("Status: "),
            Text(
              order.status,
              style: TextStyle(color: Colors.amber),
            )
          ],
        )
      ],
    );
  }
}
