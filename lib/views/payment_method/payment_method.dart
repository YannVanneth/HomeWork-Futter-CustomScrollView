import 'package:custom_scroll_view/data/exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

import '../buy_now/buynow_page.dart';

class PaymentMethod extends StatelessWidget {
  const PaymentMethod({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Payment"),
      ),
      body: Column(
        children: [
          Bounceable(
            onTap: () => Navigator.pop(context, "Cash On Delivery"),
            child: listItems(
                spacing: 20,
                leading: Image.asset("assets/icons/cash 1.png"),
                title: Text("Cash On Delivery"),
                description: Text("Cash On Delivery")),
          ),
          Bounceable(
            onTap: () => Navigator.pop(context, "Credit/Debit Card"),
            child: listItems(
              spacing: 20,
              leading: Image.asset("assets/icons/debit/cash 1.png"),
              title: Text("Credit/Debit Card"),
              description: Text("VISA, Mastercard, UnionPay"),
            ),
          )
        ],
      ),
    );
  }
}
