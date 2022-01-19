import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacyapp/contsants/values.dart';
import 'package:pharmacyapp/contsants/widgets.dart';
import 'package:pharmacyapp/cubit/operation_cubit.dart';
import 'package:pharmacyapp/cubit/states.dart';
import 'package:pharmacyapp/reusable/funcrions.dart';
import 'package:pharmacyapp/screens/show_screens/search_reasults.dart';
import '../../contsants/const_colors.dart';
import '../../reusable/components.dart';
import 'chating_page.dart';
import '../send_orders/make_order_page.dart';
import 'offers_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

        List<Map> offersList = [
          {
            "id": 200,
            "name": "Head and Shoulders Shampoo 400 ml",
            "priceorperc": true,
            "value": 30,
            "image":
                "https://m.media-amazon.com/images/I/71+Zza6xeNL._SY355_.jpg",
          },
          {
            "id": 201,
            "name": "Sun block Cream 250 ml",
            "priceorperc": true,
            "value": 15,
            "image":
                "https://api.watsons.com.ph/medias/Sun-Light-Gel-SPF50-50ml-50020619.jpg?context=bWFzdGVyfHd0Y3BoL2ltYWdlc3w1OTg3OXxpbWFnZS9qcGVnfGhjNS9oZDgvOTA5ODQ2MDEwMjY4Ni9TdW4gTGlnaHQgR2VsIFNQRjUwIDUwbWwtNTAwMjA2MTkuanBnfGQxZGRlNmJkZGFmNDI4OWZhN2QxY2U3ZWQ4MzU1YjgxNDVmNTQxNmIxZWIwYzUwOTYyMTcwN2QyOGYzYjlkYjA",
          },
          {
            "id": 202,
            "name": "Axe Body Spray 150 ml",
            "priceorperc": false,
            "value": 60,
            "image":
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQzTheyuwVZM2IZWg8MztfoDyg-mEnrWsrMDj_SyPVSvbTXQpM07XT9XNE7gjglhyopano&usqp=CAU",
          },
        ];

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
                const SizedBox(
                  height: 5,
                ),
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
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(themeColor),
                          ),
                          onPressed: () {
                            navigateTo(context, SearchResultsScreen(), true);
                          },
                          child: SizedBox(
                            width: 300,
                            child: Row(
                              children: [
                                const Icon(Icons.search),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(AppLocalizations.of(context)!.search),
                                const Spacer(),
                                const Icon(Icons.local_pharmacy_rounded),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            navigateTo(context, const OffersScreen(), true);
                          },
                          child: CarouselSlider(
                            options: CarouselOptions(
                                height: 200.0,
                                autoPlay: true,
                                enableInfiniteScroll: true),
                            items: [0, 1, 2].map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return offerCard(offersList[i], context);
                                },
                              );
                            }).toList(),
                          ),
                        ),
                        // InkWell(
                        //   onTap: () {
                        //     navigateTo(context, SendPrescriptionScreen(), true);
                        //   },
                        //   child: Card(
                        //     elevation: 15,
                        //     shadowColor: Colors.black,
                        //     color: const Color(0xff254ea6),
                        //     child: SizedBox(
                        //       width: 300,
                        //       height: 120,
                        //       child: Stack(
                        //         children: [
                        //           const Positioned(
                        //               right: 10,
                        //               top: 10,
                        //               child: Icon(
                        //                 Icons.document_scanner,
                        //                 color: Colors.white,
                        //                 size: 60.0,
                        //               )),
                        //           Positioned(
                        //             left: 0,
                        //             child: Image.network(
                        //               "https://mir-s3-cdn-cf.behance.net/projects/404/7cb21683865409.Y3JvcCwyNzQ4LDIxNTAsMTIyLDA.jpg",
                        //               width: 160,
                        //             ),
                        //           ),
                        //           const Positioned(
                        //               right: 35,
                        //               top: 25,
                        //               child: SizedBox(
                        //                 width: 120,
                        //                 child: Text(
                        //                   "Send Doctor's Prescription",
                        //                   style: TextStyle(
                        //                       fontSize: 20,
                        //                       color: Colors.white,
                        //                       fontWeight: FontWeight.w500),
                        //                 ),
                        //               )),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
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
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, bottom: 20),
                            child: Container(
                              decoration:
                                  const BoxDecoration(color: Colors.black12),
                              child: GridView.builder(
                                scrollDirection: Axis.vertical,
                                physics: defaultScrollPhysics,
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

  Widget offerCard(Map items, context) {
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
                    SizedBox(width: 200, child: Image.network(items['image'])),
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
                  items['name'],
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
                  onPressed: () => print("add to cart"),
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
                    items['priceorperc']
                        ? "${items['value']}%"
                        : "${items['value']} LE",
                    style: TextStyle(
                        fontSize: items['priceorperc'] ? 30 : 20,
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
