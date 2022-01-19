import 'package:flutter/material.dart';
import 'package:pharmacyapp/models/order_model.dart';
import 'package:pharmacyapp/reusable/components.dart';

// ignore: must_be_immutable
class ArchiveOrderDetails extends StatelessWidget {
  ArchiveOrderDetails(this.data, {Key? key}) : super(key: key);

  OrderModel data;
  @override
  Widget build(BuildContext context) {
    print(data.orderItems);
    print(data.orderItems['orderImages']);
    print(data.orderItems['OrderDrugs']);
    return Scaffold(
        appBar: myAppBar(
          text: "Order details",
          context: context,
        ),
        body: Container());
  }
}
