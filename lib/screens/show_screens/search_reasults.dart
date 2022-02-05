import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pharmacyapp/contsants/widgets.dart';
import 'package:pharmacyapp/cubit/operation_cubit.dart';
import 'package:pharmacyapp/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacyapp/models/drug_model.dart';
import 'package:pharmacyapp/reusable/funcrions.dart';
import 'package:pharmacyapp/screens/show_screens/favoriates_items.dart';
import 'package:pharmacyapp/contsants/themes.dart';
import '../../../reusable/components.dart';

// ignore: must_be_immutable
class SearchResultsScreen extends StatelessWidget {
  SearchResultsScreen({Key? key}) : super(key: key);
  final _searchController = TextEditingController();
  String? text;
  bool loadAgain = true;
  late List<Drug> oldList;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        AppCubit cubit = AppCubit.get(context);

        return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
                appBar: myAppBar(
                    text: "Search",
                    context: context,
                    actionIcon: IconButton(
                        tooltip: "Favorites Screen",
                        onPressed: () {
                          navigateTo(context, const FavoritesScreen(), true);
                        },
                        icon: const Icon(Icons.star))),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: TextFormField(
                          onChanged: (String v) {
                            text = v;
                            loadAgain = true;
                            cubit.emitGeneralState();
                          },
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
                        )),
                    Expanded(
                      child: loadAgain
                          ? FutureBuilder<List<Drug>>(
                              future: cubit.findInDataBase(subName: text),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<Drug>> snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting:
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  default:
                                    if (snapshot.hasError) {
                                      return const Center(child: Text('Error'));
                                    } else if (snapshot.data != null &&
                                        snapshot.data!.isNotEmpty) {
                                      loadAgain = false;
                                      oldList = snapshot.data!;
                                      return list(
                                          context, snapshot.data!, cubit);
                                    } else {
                                      return Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(
                                              Icons.shopping_bag_outlined,
                                              color: Colors.grey,
                                              size: 100,
                                            ),
                                            Text(
                                              'No items',
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
                            )
                          : list(context, oldList, cubit),
                    ),
                  ],
                )));
      },
    );
  }

  Widget list(BuildContext context, List<Drug> drugs, AppCubit cubit) {
    return GridView.builder(
      scrollDirection: Axis.vertical,
      physics: defaultScrollPhysics,
      shrinkWrap: true,
      padding: const EdgeInsets.all(12.0),
      itemCount: drugs.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: MediaQuery.of(context).size.width / (520),
          crossAxisCount: 2,
          crossAxisSpacing: 3,
          mainAxisSpacing: 5),
      itemBuilder: (BuildContext context, int index) =>
          cartItem(drugs[index], cubit, context),
    );
  }

  Widget cartItem(Drug drug, AppCubit cubit, BuildContext context) {
    return Card(
      elevation: 10,
      color: Colors.blue,
      child: Column(
        children: [
          defaultSpaceH(3),
          Stack(
            alignment: Alignment.topLeft,
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width / 2.4,
                  height: 120,
                  child: photoWithError(
                      imageLink: drug.picture ?? "null",
                      errorWidget: Center(
                        child: Text(
                          drug.name.toString().length < 2
                              ? " "
                              : drug.name.toString().trim().substring(0, 2),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ))),
              CircleAvatar(
                child: IconButton(
                    color: Colors.white,
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      cubit.reverseFavorites(drug);
                    },
                    icon: drug.isFav
                        ? const Icon(Icons.star)
                        : const Icon(Icons.star_border_outlined)),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SingleChildScrollView(
                  child: Tooltip(
                    message: drug.name,
                    child: Text(
                      drug.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                  scrollDirection: Axis.vertical,
                ),
                defaultSpaceH(3),
                Row(
                  children: [
                    SizedBox(
                      width: 90,
                      child: SingleChildScrollView(
                        child: Text(
                          "${drug.price} LE",
                          style: const TextStyle(
                              fontSize: 20,
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
                      child: IconButton(
                          color: Colors.white,
                          onPressed: () {
                            cubit.addToCart(drug);
                            EasyLoading.showToast("Item added successfully.");
                          },
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
