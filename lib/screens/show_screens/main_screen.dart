import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacyapp/contsants/brands.dart';
import 'package:pharmacyapp/contsants/widgets.dart';
import 'package:pharmacyapp/cubit/operation_cubit.dart';
import 'package:pharmacyapp/cubit/states.dart';
import 'package:pharmacyapp/models/offer_model.dart';
import 'package:pharmacyapp/reusable/funcrions.dart';
import 'package:pharmacyapp/screens/show_screens/search_reasults.dart';
import 'package:pharmacyapp/contsants/themes.dart';
import '../../reusable/components.dart';
import 'chating_page.dart';
import '../send_orders/make_order_page.dart';
import 'offers_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class MainScreen extends StatelessWidget {
  MainScreen(BuildContext? context, {Key? key}) : super(key: key) {
    if (context != null) {
      AppCubit cubit = AppCubit.get(context);
      cubit.mainStart();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        AppCubit cubit = AppCubit.get(context);

        return WillPopScope(
          onWillPop: () => onWillPop(context),
          child: Scaffold(
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    navigateTo(context, MakeAnOrderScreen(), true);
                  },
                  child: Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                        color: themeColor,
                        borderRadius: BorderRadius.circular(60)),
                    child: Stack(
                      children: [
                        Center(
                            child: state is CartItemsLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Icon(
                                    Icons.shopping_cart,
                                    size: 30,
                                    color: Colors.white,
                                  )),
                        cubit.activeOrder
                            ? Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                    color: HSLColor.fromColor(Colors.green)
                                        .withSaturation(1)
                                        .toColor(),
                                    borderRadius: BorderRadius.circular(20)),
                              )
                            : cubit.cartItems.isNotEmpty ||
                                    cubit.orderImages.isNotEmpty
                                ? Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Center(
                                        child: Text(
                                      (cubit.cartItems.length +
                                              cubit.orderImages.length)
                                          .toString(),
                                      style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    )),
                                  )
                                : Container()
                      ],
                    ),
                  ),
                ),
                defaultSpaceH(5),
                FloatingActionButton(
                  tooltip: "Ask the Doctor",
                  elevation: 10,
                  backgroundColor: themeColor,
                  onPressed: () {
                    navigateTo(context, const ChattingScreen(), true);
                  },
                  child: Stack(
                    children: [
                      const Center(
                          child: Icon(
                        Icons.message_outlined,
                        size: 30,
                        color: Colors.white,
                      )),
                      cubit.newMessage
                          ? Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(20)),
                            )
                          : Container()
                    ],
                  ),
                ),
              ],
            ),
            appBar: myAppBar(
                text: AppLocalizations.of(context)!.tamerdewwek,
                context: context),
            body: Center(
              child: state is InitialStateLoading
                  ? const CircularProgressIndicator()
                  : SingleChildScrollView(
                      physics: defaultScrollPhysics,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(themeColor),
                              ),
                              onPressed: () {
                                navigateTo(
                                    context, SearchResultsScreen(), true);
                              },
                              child: SizedBox(
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    const Icon(Icons.search),
                                    defaultSpaceW(5),
                                    Text(AppLocalizations.of(context)!.search),
                                    const Spacer(),
                                    const Icon(Icons.local_pharmacy_rounded),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          cubit.offersList.isEmpty
                              ? Card(
                                  color: Colors.amber[200],
                                  child: SizedBox(
                                      width: 300,
                                      height: 200,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            left: 20,
                                            top: -10,
                                            child: Transform.rotate(
                                                angle: 2.9,
                                                child: const Icon(
                                                  Icons.apps,
                                                  size: 220,
                                                  color: Colors.white30,
                                                )),
                                          ),
                                          Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.redeem,
                                                  size: 50,
                                                  color: Colors.black,
                                                ),
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .no_offers_now,
                                                  style: const TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                SizedBox(
                                                    width: 250,
                                                    child: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .we_will_notify_you_about_new_offers,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )), //SizedBox
                                )
                              : InkWell(
                                  onTap: () {
                                    navigateTo(
                                        context, const OffersScreen(), true);
                                  },
                                  child: CarouselSlider(
                                    options: CarouselOptions(
                                        height: 200.0,
                                        autoPlay: true,
                                        enableInfiniteScroll:
                                            cubit.offersList.length != 1),
                                    items: cubit.offersList.map((e) {
                                      print(e.drug.name);
                                      return Builder(
                                        builder: (BuildContext context) {
                                          return offerCard(e, context, cubit);
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, top: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: themeColor,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    AppLocalizations.of(context)!.brand,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w200,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            //height: height < 400 ? 400 : height - 400,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, bottom: 20),
                              child: Container(
                                decoration:
                                    const BoxDecoration(color: Colors.black12),
                                child: GridView.builder(
                                  scrollDirection: Axis.vertical,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.all(12.0),
                                  itemCount: brandsList.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 2,
                                          mainAxisSpacing: 2),
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          ClipRRect(
                                    borderRadius: BorderRadius.circular(7),
                                    child: photoWithError(
                                        imageLink: brandsList[index]['image']),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  Future<bool> onWillPop(BuildContext context) async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.are_you_sure),
            content: Text(AppLocalizations.of(context)!.do_you_want_to_exit),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(AppLocalizations.of(context)!.no),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(AppLocalizations.of(context)!.yes),
              ),
            ],
          ),
        )) ??
        false;
  }

  Widget offerCard(OfferItem items, context, AppCubit cubit) {
    return Card(
      elevation: 15,
      shadowColor: Colors.black,
      color: Colors.indigo,
      child: SizedBox(
        width: 300,
        height: 200,
        child: Stack(
          children: [
            Positioned(
              right: -20,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                  topLeft: Radius.circular(100),
                ),
                child: Stack(
                  children: [
                    SizedBox(
                        width: 200,
                        height: 200,
                        child: photoWithError(
                            imageLink: items.drug.picture ?? "",
                            errorWidget: const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 30.0, horizontal: 20),
                              child: Icon(
                                Icons.signal_cellular_no_sim_outlined,
                                size: 100,
                              ),
                            ))),
                    Positioned(
                      top: -20,
                      child: SizedBox(
                          child: photoWithError(
                        imageLink:
                            "https://freepngimg.com/thumb/categories/1219.png",
                      )),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                top: 10,
                left: 10,
                child: Text(
                  AppLocalizations.of(context)!.todayoffer,
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                )),
            Positioned(
              left: 10,
              top: 50,
              child: SizedBox(
                width: 100,
                child: Text(
                  items.drug.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      color: Colors.orangeAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Positioned(
                left: 2,
                bottom: 4,
                child: TextButton(
                  onPressed: () => cubit.addToCart(items.drug),
                  child: Text(
                    AppLocalizations.of(context)!.addtocart,
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                )),
            Positioned(
              right: -12,
              bottom: -12,
              child: Container(
                child: Center(
                  child: Text(
                    items.percentage
                        ? "${items.offer} % "
                        : "${items.offer} " + AppLocalizations.of(context)!.le,
                    style: TextStyle(
                        fontSize: items.percentage ? 18 : 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w900),
                  ),
                ),
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.circular(200),
                ),
              ),
            )
          ],
        ),
      ), //SizedBox
    );
  }
}
