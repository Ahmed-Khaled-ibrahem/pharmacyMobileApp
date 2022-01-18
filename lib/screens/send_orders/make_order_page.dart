import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:pharmacyapp/cubit/operation_cubit.dart';
import 'package:pharmacyapp/cubit/states.dart';
import 'package:pharmacyapp/models/drug_model.dart';
import 'package:pharmacyapp/reusable/funcrions.dart';
import '../../contsants/const_colors.dart';
import '../../reusable/components.dart';
import 'order_submition.dart';

// ignore: must_be_immutable
class MakeAnOrderScreen extends StatelessWidget {
  MakeAnOrderScreen({Key? key}) : super(key: key);

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        AppCubit cubit = AppCubit.get(context);

        return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
                appBar: myAppBar(text: "Make an Order", context: context),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Row(
                        children: [
                          Expanded(
                              child: TypeAheadField<Drug>(
                            suggestionsCallback: (text) =>
                                cubit.findInDataBase(subName: text),
                            onSuggestionSelected: (suggestion) {
                              _searchController.text = suggestion.name;
                              cubit.addToCart(suggestion);
                            },
                            itemBuilder: (context, drug) {
                              return ListTile(
                                minLeadingWidth: 25,
                                title: Text(drug.name),
                                subtitle: Text("price : ${drug.price}"),
                                leading: SizedBox(
                                  width: 25,
                                  child: drug.picture
                                          .toString()
                                          .contains("dalilaldwaa")
                                      ? Image.network(
                                          drug.picture!,
                                          errorBuilder: (_, __, ___) {
                                            return CircleAvatar(
                                              backgroundColor: themeColor,
                                              child: Text(
                                                drug.name.toString().length < 2
                                                    ? " "
                                                    : drug.name
                                                        .toString()
                                                        .substring(0, 2),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 8),
                                              ),
                                            );
                                          },
                                        )
                                      : CircleAvatar(
                                          backgroundColor: themeColor,
                                          child: Text(
                                            drug.name.toString().length < 2
                                                ? " "
                                                : drug.name
                                                    .toString()
                                                    .substring(0, 2),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 8),
                                          ),
                                        ),
                                ),
                              );
                            },
                            textFieldConfiguration: TextFieldConfiguration(
                              decoration: InputDecoration(
                                  labelText: 'Search',
                                  prefixIcon: const Icon(Icons.search),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.cancel_outlined),
                                    onPressed: () =>
                                        _searchController.text = "",
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.blueGrey, width: 1),
                                    borderRadius: BorderRadius.circular(40),
                                  )),
                              controller: _searchController,
                            ),
                            //hasOverlay: true,
                            //marginColor: Colors.deepOrange,
                          )),
                          IconButton(
                              iconSize: 30,
                              splashRadius: 30,
                              tooltip: "Send prescription",
                              onPressed: () async {
                                cubit.addOrderImage(context);
                              },
                              icon: const Icon(Icons.camera_alt_outlined))
                        ],
                      ),
                    ),
                    Expanded(
                      child: PageView.builder(
                          itemCount: 2,
                          itemBuilder: (_, index) {
                            switch (index) {
                              case 0:
                                return cubit.cartItems.isEmpty
                                    ? Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                        separatorBuilder: (_, index) =>
                                            const Divider(),
                                        itemBuilder: (_, index) => Row(
                                              children: [
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                SizedBox(
                                                    width: 160,
                                                    child: Text(
                                                      cubit.cartItems[index]
                                                          .drug.name,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    )),
                                                const Spacer(),
                                                InkWell(
                                                  onTap: () {
                                                    cubit.changeCartQuantity(
                                                        index: index,
                                                        increase: false);
                                                  },
                                                  child: const SizedBox(
                                                      width: 40,
                                                      height: 70,
                                                      child: Icon(
                                                        Icons.remove,
                                                        size: 25,
                                                        color: Colors.green,
                                                      )),
                                                ),
                                                SizedBox(
                                                  width: 50,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 5, 0, 5),
                                                    child: TextFormField(
                                                      onFieldSubmitted: (v) {
                                                        int? q =
                                                            int.tryParse(v);
                                                        if (q == null) {
                                                          EasyLoading.showError(
                                                              "Invalid quantity at item ${index + 1}");
                                                        } else {
                                                          cubit
                                                              .changeCartQuantity(
                                                                  index: index,
                                                                  newValue: q);
                                                        }
                                                      },
                                                      decoration:
                                                          const InputDecoration(
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.blueGrey,
                                                            width: 0),
                                                      )),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      controller:
                                                          TextEditingController(
                                                              text: (cubit
                                                                      .cartItems[
                                                                          index]
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
                                                        index: index,
                                                        increase: true);
                                                  },
                                                  child: const SizedBox(
                                                      width: 40,
                                                      height: 70,
                                                      child: Icon(
                                                        Icons.add,
                                                        size: 25,
                                                        color: Colors.blue,
                                                      )),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    cubit.removeFromCart(index);
                                                  },
                                                  child: const SizedBox(
                                                      width: 40,
                                                      height: 70,
                                                      child: Icon(
                                                        Icons.close,
                                                        size: 25,
                                                        color: Colors.red,
                                                      )),
                                                ),
                                              ],
                                            ));
                              case 1:
                                return cubit.orderImages.isEmpty
                                    ? Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                            physics:
                                                const BouncingScrollPhysics(),
                                            itemCount: cubit.orderImages.length,
                                            separatorBuilder: (_, index) =>
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                            itemBuilder: (_, index) => Center(
                                                  child: Stack(
                                                    alignment:
                                                        Alignment.topRight,
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                        width:
                                                                            3),
                                                                color:
                                                                    themeColor),
                                                        child: photoWithError(
                                                            width: 280,
                                                            imageLink: cubit
                                                                    .orderImages[
                                                                index],
                                                            assetPath:
                                                                "assets/images/prescription-png.png"),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 4,
                                                                right: 4),
                                                        child: CircleAvatar(
                                                          backgroundColor:
                                                              themeColor,
                                                          child: Center(
                                                            child: IconButton(
                                                                //iconSize: 30,
                                                                color: Colors
                                                                    .redAccent,
                                                                onPressed: () {
                                                                  cubit.removeOrderImage(
                                                                      index);
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons.close,
                                                                  size: 23,
                                                                )),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )),
                                      );
                            }
                            return Container();
                          }),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          "Total Price",
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          "${cubit.calcOrderPrice()} LE",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        ElevatedButton.icon(
                          label: const Text("Submit"),
                          icon: const Icon(Icons.playlist_add_check),
                          style: ElevatedButton.styleFrom(
                            primary: themeColor,
                            //  fixedSize: const Size(250, 35.0),
                            // shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(80))
                          ),
                          onPressed: () {
                            navigateTo(context, OrderSubmissionScreen(), true);
                          },
                        ),
                      ],
                    ),
                  ],
                )));
      },
    );
  }
}
