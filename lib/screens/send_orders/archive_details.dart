import 'package:flutter/material.dart';
import 'package:pharmacyapp/contsants/const_colors.dart';
import 'package:pharmacyapp/models/drug_model.dart';
import 'package:pharmacyapp/models/order_model.dart';
import 'package:pharmacyapp/reusable/components.dart';
import 'package:pharmacyapp/reusable/funcrions.dart';
import 'package:pharmacyapp/reusable/view_photo.dart';

// ignore: must_be_immutable
class ArchiveOrderDetails extends StatelessWidget {
  ArchiveOrderDetails(this.data, this.returner, {Key? key}) : super(key: key);

  OrderModel data;
  Function returner;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: myAppBar(
          text: "Order details",
          context: context,
        ),
        body: SingleChildScrollView(
physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(flex: 2, child: Text("maker name")),
                    Expanded(flex: 4, child: Text(data.name))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Expanded(flex: 2, child: Text("maker phone")),
                    Expanded(flex: 4, child: Text(data.phone))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(flex: 2, child: Text("maker address")),
                    Expanded(flex: 4, child: Text(data.address))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Expanded(flex: 2, child: Text("Order price")),
                    Expanded(flex: 4, child: Text(data.price.toString()))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Expanded(flex: 2, child: Text("Order time")),
                    Expanded(flex: 4, child: Text(data.time))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: data.description != null,
                  child: Row(
                    children: [
                      const Expanded(flex: 2, child: Text("Order price")),
                      Expanded(flex: 4, child: Text(data.description!))
                    ],
                  ),
                ),
                Visibility(
                  visible: data.description != null,
                  child: const SizedBox(
                    height: 10,
                  ),
                ),
                Row(
                  children: [
                    const Expanded(flex: 2, child: Text("drugs count")),
                    Expanded(flex: 4, child: Text(data.itemsCount.toString()))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Expanded(flex: 2, child: Text("images count")),
                    Expanded(flex: 4, child: Text(data.imagesCount.toString()))
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 400,
                  child: FutureBuilder<Map<String, dynamic>>(
                    future: returner({
                      'orderImages': data.orderItems['orderImages'],
                      'OrderDrugs': data.orderItems['OrderDrugs']
                    }),
                    builder: (BuildContext context,
                        AsyncSnapshot<Map<String, dynamic>> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        default:
                          if (snapshot.hasError) {
                            return const Center(child: Text('Error'));
                          } else if (snapshot.data != null) {
                            return itemsList(snapshot.data!['OrderImages'],
                                snapshot.data!['OrderDrugs'], context);
                          } else {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.archive,
                                    color: Colors.grey,
                                    size: 100,
                                  ),
                                  Text(
                                    'No Data',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  )
                                ],
                              ),
                            );
                          }
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget itemsList(
      List<String> images, List<OrderItem> items, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: PageView.builder(
physics: const BouncingScrollPhysics(),
          itemCount: 2,
          itemBuilder: (_, index) {
            switch (index) {
              case 0:
                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: items.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.remove_shopping_cart,
                                color: Colors.grey,
                                size: 100,
                              ),
                              Text(
                                'No items in cart',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              )
                            ],
                          ),
                        )
                      : ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemCount: items.length,
                          separatorBuilder: (_, index) => const Divider(),
                          itemBuilder: (_, index) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Tooltip(
                                      message: items[index].drug.name,
                                      child: Text(
                                        items[index].drug.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(2, 5, 2, 5),
                                      child: Text(
                                          items[index].quantity.toString(),
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                    )
                                  ],
                                ),
                              )),
                );
              case 1:
                return Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: images.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.document_scanner,
                                color: Colors.grey,
                                size: 100,
                              ),
                              Text(
                                'No photos in cart',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              )
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              itemCount: images.length,
                              separatorBuilder: (_, index) => const SizedBox(
                                    height: 10,
                                  ),
                              itemBuilder: (_, index) => Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 3),
                                          color: themeColor),
                                      child: InkWell(
                                        onTap: () {
                                          navigateTo(context,
                                              ViewPhoto(images[index]), true);
                                        },
                                        child: photoWithError(
                                            width: 280,
                                            imageLink: images[index],
                                            assetPath:
                                                "assets/images/prescription-png.png",
                                            errorWidget: Image.asset(
                                              "assets/images/prescription-png.png",
                                              width: 280,
                                            )),
                                      ),
                                    ),
                                  )),
                        ),
                );
            }
            return Container();
          }),
    );
  }
}
