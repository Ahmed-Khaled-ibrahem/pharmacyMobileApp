import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:pharmacyapp/contsants/widgets.dart';
import 'package:pharmacyapp/cubit/operation_cubit.dart';
import 'package:pharmacyapp/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacyapp/models/drug_model.dart';
import '../../../contsants/const_colors.dart';
import '../../../reusable/components.dart';

// ignore: must_be_immutable
class SearchResultsScreen extends StatelessWidget {
  SearchResultsScreen({Key? key}) : super(key: key);
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
                appBar: myAppBar(text: "Search", context: context),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TypeAheadField<Drug>(
                        suggestionsCallback: (text) =>
                            cubit.findInDataBase(subName: text),
                        onSuggestionSelected: (suggestion) {
                          _searchController.text = suggestion.name;
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
                      child: GridView.builder(
                        scrollDirection: Axis.vertical,
                        physics: defaultScrollPhysics,
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(12.0),
                        itemCount: images.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio:
                                MediaQuery.of(context).size.width /
                                    (MediaQuery.of(context).size.height / 1.23),
                            crossAxisCount: 2,
                            crossAxisSpacing: 3,
                            mainAxisSpacing: 5),
                        itemBuilder: (BuildContext context, int index) =>
                            cartItem(index),
                      ),
                    ),
                  ],
                )));
      },
    );
  }

  List<String> images = [
    "https://images.unsplash.com/photo-1453728013993-6d66e9c9123a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8dmlld3xlbnwwfHwwfHw%3D&w=1000&q=80",
    "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg",
    "https://media.istockphoto.com/photos/colored-powder-explosion-on-black-background-picture-id1057506940?k=20&m=1057506940&s=612x612&w=0&h=3j5EA6YFVg3q-laNqTGtLxfCKVR3_o6gcVZZseNaWGk=",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0PR2ZAzwhWY7orX3aNxJE67X5TaAjAN7H_g&usqp=CAU"
  ];
  bool stared = false;

  Widget cartItem(int index) {
    return Card(
      elevation: 10,
      color: Colors.blue,
      child: Column(
        children: [
          const SizedBox(
            height: 3,
          ),
          Stack(
            children: [
              SizedBox(
                  width: 150,
                  height: 120,
                  child: Image.network(
                    images[index],
                    fit: BoxFit.cover,
                  )),
              const Positioned(
                  left: 9,
                  top: 10,
                  child: Icon(
                    Icons.circle,
                    color: Colors.white,
                    size: 30,
                  )),
              IconButton(
                  onPressed: () {
                    stared = !stared;
                  },
                  icon: stared
                      ? const Icon(Icons.star)
                      : const Icon(Icons.star_border_outlined)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 95,
                  child: SingleChildScrollView(
                    child: Text(
                      "Panadol Extra 50mg",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    scrollDirection: Axis.vertical,
                  ),
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 90,
                      child: SingleChildScrollView(
                        child: Text(
                          "120.0 LE ",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.white),
                        ),
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                          color: themeColor,
                          borderRadius: BorderRadius.circular(20)),
                      height: 40,
                      child: IconButton(
                          color: Colors.white,
                          onPressed: () {},
                          icon: const Icon(Icons.add_shopping_cart_sharp)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
