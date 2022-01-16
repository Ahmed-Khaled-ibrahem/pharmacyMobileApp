import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:pharmacyapp/cubit/operation_cubit.dart';
import 'package:pharmacyapp/cubit/states.dart';
import 'package:pharmacyapp/layouts/order_submition.dart';
import '../contsants/const_colors.dart';
import '../reusable/components.dart';

// ignore: must_be_immutable
class MakeAnOrderScreen extends StatelessWidget {
  MakeAnOrderScreen({Key? key}) : super(key: key);

  final _searchController = TextEditingController();
  int totalPrice = 0;

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
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: TypeAheadField<Map<String, dynamic>>(
                        suggestionsCallback: cubit.findInDataBase,
                        onSuggestionSelected: (suggestion) {
                          _searchController.text = suggestion['name'];
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            minLeadingWidth: 25,
                            title: Text(suggestion['name']),
                            subtitle: Text("price : ${suggestion['price']}"),
                            leading: SizedBox(
                              width: 25,
                              child: suggestion['picture']
                                      .toString()
                                      .contains("dalilaldwaa")
                                  ? Image.network(suggestion['picture'])
                                  : CircleAvatar(
                                      backgroundColor: themeColor,
                                      child: Text(
                                        suggestion['name'].toString().length < 2
                                            ? " "
                                            : suggestion['name']
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
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Your Order list"),
                    ),
                    Expanded(
                      child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemCount: 7,
                          separatorBuilder: (_, index) => const Divider(),
                          itemBuilder: (_, index) => Row(
                                children: [
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  const SizedBox(
                                      width: 160,
                                      child: Text("Panadol 50g Tap")),
                                  const Spacer(),
                                  const InkWell(
                                    child: SizedBox(
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
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      child: TextField(
                                        decoration: const InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.blueGrey, width: 0),
                                        )),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                        controller: TextEditingController(
                                            text: (index + 1).toString()),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                  ),
                                  const InkWell(
                                    child: SizedBox(
                                        width: 40,
                                        height: 70,
                                        child: Icon(
                                          Icons.add,
                                          size: 25,
                                          color: Colors.blue,
                                        )),
                                  ),
                                  const InkWell(
                                    child: SizedBox(
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
                          "$totalPrice LE",
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      OrderSubmissionScreen()),
                            );
                            //cubit.loginButtonEvent(context);
                            //stopanimation();
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
