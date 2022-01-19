import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pharmacyapp/contsants/const_colors.dart';
import 'package:pharmacyapp/cubit/operation_cubit.dart';
import 'package:pharmacyapp/cubit/states.dart';
import 'package:pharmacyapp/reusable/components.dart';
import 'package:pharmacyapp/reusable/funcrions.dart';
import 'package:pharmacyapp/reusable/view_photo.dart';

// ignore: must_be_immutable
class OrderList extends StatelessWidget {
  OrderList(this.cubit, this.state, {Key? key}) : super(key: key);

  AppCubit cubit;
  AppStates state;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: state is CartItemsLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : PageView.builder(
              itemCount: 2,
              itemBuilder: (_, index) {
                switch (index) {
                  case 0:
                    return Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      child: cubit.cartItems.isEmpty
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
                              itemCount: cubit.cartItems.length,
                              separatorBuilder: (_, index) => const Divider(),
                              itemBuilder: (_, index) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                            width: 160,
                                            child: Tooltip(
                                              message: cubit
                                                  .cartItems[index].drug.name,
                                              child: Text(
                                                cubit
                                                    .cartItems[index].drug.name,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )),
                                        const Spacer(),
                                        InkWell(
                                          onTap: () {
                                            cubit.changeCartQuantity(
                                                index: index, increase: false);
                                          },
                                          child: const Icon(
                                            Icons.remove,
                                            size: 25,
                                            color: Colors.green,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 40,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                2, 5, 2, 5),
                                            child: TextFormField(
                                              onFieldSubmitted: (v) {
                                                int? q = int.tryParse(v);
                                                if (q == null) {
                                                  EasyLoading.showError(
                                                      "Invalid quantity at item ${index + 1}");
                                                } else {
                                                  cubit.changeCartQuantity(
                                                      index: index,
                                                      newValue: q);
                                                }
                                              },
                                              decoration: const InputDecoration(
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.blueGrey,
                                                    width: 0),
                                              )),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                              controller: TextEditingController(
                                                  text: (cubit.cartItems[index]
                                                          .quantity)
                                                      .toString()),
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            cubit.changeCartQuantity(
                                                index: index, increase: true);
                                          },
                                          child: const Icon(
                                            Icons.add,
                                            size: 25,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            cubit.removeFromCart(index);
                                          },
                                          child: const Icon(
                                            Icons.close,
                                            size: 30,
                                            color: Colors.red,
                                          ),
                                        ),
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
                      child: cubit.orderImages.isEmpty
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
                                  itemCount: cubit.orderImages.length,
                                  separatorBuilder: (_, index) =>
                                      const SizedBox(
                                        height: 10,
                                      ),
                                  itemBuilder: (_, index) => Center(
                                        child: Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(width: 3),
                                                  color: themeColor),
                                              child: InkWell(
                                                onTap: () {
                                                  navigateTo(
                                                      context,
                                                      ViewPhoto(cubit
                                                          .orderImages[index]),
                                                      true);
                                                },
                                                child: photoWithError(
                                                    width: 280,
                                                    imageLink: cubit
                                                        .orderImages[index],
                                                    assetPath:
                                                        "assets/images/prescription-png.png"),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 4, right: 4),
                                              child: CircleAvatar(
                                                backgroundColor: Colors.white,
                                                child: Center(
                                                  child: IconButton(
                                                      //iconSize: 30,
                                                      color: Colors.redAccent,
                                                      onPressed: () {
                                                        customChoiceDialog(
                                                            context,
                                                            title: "Warning",
                                                            content:
                                                                "Are you sure tou want to delete the photo ?",
                                                            yesFunction: () => cubit
                                                                .removeOrderImage(
                                                                    index));
                                                      },
                                                      icon: const Icon(
                                                        Icons.close,
                                                        size: 25,
                                                      )),
                                                ),
                                              ),
                                            )
                                          ],
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
