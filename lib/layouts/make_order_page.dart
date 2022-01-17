import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:pharmacyapp/cubit/operation_cubit.dart';
import 'package:pharmacyapp/cubit/states.dart';
import 'package:pharmacyapp/layouts/models/drug_model.dart';
import 'package:pharmacyapp/layouts/order_submition.dart';
import 'package:pharmacyapp/reusable/funcrions.dart';
import '../contsants/const_colors.dart';
import '../reusable/components.dart';

// ignore: must_be_immutable
class MakeAnOrderScreen extends StatelessWidget {
  MakeAnOrderScreen({Key? key}) : super(key: key);

  final _searchController = TextEditingController();
  List<OrderItem> orderItems = [];

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
                      child: TypeAheadField<Drug>(
                        suggestionsCallback: (text) =>
                            cubit.findInDataBase(subName: text),
                        onSuggestionSelected: (suggestion) {
                          _searchController.text = suggestion.name;
                          orderItems.add(OrderItem(suggestion, 1));
                          cubit.emitGeneralState();
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
                                            color: Colors.white, fontSize: 8),
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
                                onPressed: () => _searchController.text = "",
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
                      ),
                    ),
                    Expanded(
                      child: orderItems.isEmpty
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
                              itemCount: orderItems.length,
                              separatorBuilder: (_, index) => const Divider(),
                              itemBuilder: (_, index) => Row(
                                    children: [
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      SizedBox(
                                          width: 160,
                                          child: Text(
                                            orderItems[index].drug.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          )),
                                      const Spacer(),
                                      InkWell(
                                        onTap: () {
                                          if (orderItems[index].quantity > 1) {
                                            orderItems[index].quantity--;
                                            cubit.emitGeneralState();
                                          }
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
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 5, 0, 5),
                                          child: TextField(
                                            onSubmitted: (v) {
                                              orderItems[index].quantity =
                                                  int.parse(v);
                                              cubit.emitGeneralState();
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
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                            controller: TextEditingController(
                                                text:
                                                    (orderItems[index].quantity)
                                                        .toString()),
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          orderItems[index].quantity++;
                                          cubit.emitGeneralState();
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
                                          orderItems.removeAt(index);
                                          cubit.emitGeneralState();
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
                                  )),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          "Total Price",
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          "${calcOrderPrice()} LE",
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
                            navigateTo(context,
                                OrderSubmissionScreen(orderItems), true);
                          },
                        ),
                      ],
                    ),
                  ],
                )));
      },
    );
  }

  double calcOrderPrice() {
    double price = 0;
    for (OrderItem item in orderItems) {
      price += item.quantity * item.drug.price;
    }
    return price;
  }
}
