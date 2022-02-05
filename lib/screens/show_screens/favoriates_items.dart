import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pharmacyapp/contsants/themes.dart';
import 'package:pharmacyapp/contsants/widgets.dart';
import 'package:pharmacyapp/cubit/operation_cubit.dart';
import 'package:pharmacyapp/cubit/states.dart';
import 'package:pharmacyapp/models/drug_model.dart';
import '../../reusable/components.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        AppCubit cubit = AppCubit.get(context);

        return Scaffold(
            appBar: myAppBar(
              text: AppLocalizations.of(context)!.favorites_items,
              context: context,
            ),
            body: FutureBuilder<List<Drug>>(
              future: cubit.getFavoriteList(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Drug>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    if (snapshot.hasError) {
                      return  Center(child: Text(AppLocalizations.of(context)!.error));
                    } else if (snapshot.data != null &&
                        snapshot.data!.isNotEmpty) {
                      return list(context, snapshot.data!, cubit);
                    } else {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:  [
                            const Icon(
                              Icons.shopping_bag_outlined,
                              color: Colors.grey,
                              size: 100,
                            ),
                            Text(
                              AppLocalizations.of(context)!.no_favorite_items,
                              style: const TextStyle(
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
            ));
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
                  child: Text(
                    drug.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  scrollDirection: Axis.vertical,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 90,
                      child: SingleChildScrollView(
                        child: Text(
                          "${drug.price}"+ AppLocalizations.of(context)!.le,
                          style: const TextStyle(
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
                      child: IconButton(
                          color: Colors.white,
                          onPressed: () {
                            cubit.addToCart(drug);
                            EasyLoading.showToast(AppLocalizations.of(context)!.item_added_successfully);
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
