import 'dart:convert';

import 'package:dash_chat/dash_chat.dart';

class OrderModel {
  bool isActive;
  late String id;
  late double price;
  late int itemsCount;
  late int imagesCount;
  late String time;
  String? description;
  late String phone;
  late String name;
  late String address;
  late Map<String, dynamic> orderItems;

  OrderModel(
      {String? oId,
      required Map<String, dynamic> orderData,
      required this.isActive,
      bool fromFire = false}) {
    id = oId!;
    if (!fromFire) {
      orderData = json.decode(orderData['details']);
    }
    price = orderData['Items Price'];
    itemsCount = orderData['ImagesCount'];
    imagesCount = orderData['ImagesCount'];
    DateTime dateTime = DateTime.parse(orderData['time']);
    time = DateFormat("yyyy-MM-dd hh:mm:ss").format(dateTime);
    description = orderData['description'];
    phone = orderData['ContactPhone'];
    name = orderData['Name'];
    address = orderData['UserAddress'];
    orderItems = {
      "orderImages": orderData['orderImages'],
      "OrderDrugs": orderData['OrderDrugs']
    };
  }
}
