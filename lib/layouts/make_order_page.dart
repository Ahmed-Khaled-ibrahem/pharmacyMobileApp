import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacyapp/cubit/cubit.dart';
import 'package:pharmacyapp/cubit/states.dart';
import 'package:searchfield/searchfield.dart';

import '../contsants/const_colors.dart';
import '../reusable/components.dart';

class MakeAnOrderScreen extends StatefulWidget {
  const MakeAnOrderScreen({Key? key}) : super(key: key);

  @override
  _MakeAnOrderScreenState createState() => _MakeAnOrderScreenState();
}

class _MakeAnOrderScreenState extends State<MakeAnOrderScreen> {
  final _searchController = TextEditingController();
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    //countries = data.map((e) => Country.fromMap(e)).toList();
  }

  List<String> countries = [
    "VOLTAREN  75MG 3AMP",
    "VOLTAREN 100 SUPP",
    "VOLTAREN 12.5 INF SUPP.",
    "VOLTAREN 25 mg TAB",
    "VOLTAREN 25MG SUPP",
    "VOLTAREN 50 mg TAB",
    "VOLTAREN 6AMP",
    "VOLTAREN 75 MG 4 AMP",
    " VOLTAREN D 50 DISP TAB"
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        AppCubit cubit = AppCubit.get(context);

        return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
                appBar: myAppBar("Make an Order", themeColor),
                floatingActionButton: FloatingActionButton(
                  onPressed: () => cubit.readSqlData(),
                ),
                body: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: SearchField(
                        suggestions: countries,
                        suggestionState: SuggestionState.enabled,
                        controller: _searchController,
                        hint: 'Search For Item',
                        maxSuggestionsInViewPort: 4,
                        itemHeight: 45,
                        onTap: (x) {},
                        //hasOverlay: true,

                        //marginColor: Colors.deepOrange,
                        searchInputDecoration: InputDecoration(
                            labelText: 'Search',
                            prefixIcon: const Icon(Icons.search),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.blueGrey, width: 1),
                              borderRadius: BorderRadius.circular(40),
                            )),
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                          itemCount: 7,
                          separatorBuilder: (_, index) => const Divider(),
                          itemBuilder: (_, index) => Row(
                                children: [
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  const Text("Panadol 50g Tap "),
                                  const Spacer(),
                                  IconButton(
                                      onPressed: () {},
                                      color: Colors.green,
                                      icon: const Icon(Icons.remove, size: 25)),
                                  SizedBox(
                                    width: 40,
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
                                  IconButton(
                                      color: Colors.blue,
                                      onPressed: () {},
                                      icon: const Icon(Icons.add, size: 25)),
                                  IconButton(
                                      color: Colors.red,
                                      onPressed: () {},
                                      icon: const Icon(Icons.close, size: 22)),
                                ],
                              )),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        label: const Text("Submit"),
                        icon: const Icon(Icons.playlist_add_check),
                        style: ElevatedButton.styleFrom(
                          primary: themeColor,
                          fixedSize: const Size(250, 35.0),
                          // shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.circular(80))
                        ),
                        onPressed: () {
                          cubit.swipeScreen();
                          //cubit.loginButtonEvent(context);
                          //stopanimation();
                        },
                      ),
                    ),
                  ],
                )));
      },
    );
  }
}
