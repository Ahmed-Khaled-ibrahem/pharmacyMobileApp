import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

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
                    width: 55,height: 55,
                    decoration: BoxDecoration(
                        color: themeColor,
                      borderRadius: BorderRadius.circular(60)
                    ),
                    child: Stack(
                      children: [
                        const Center(
                            child: Icon(
                          Icons.shopping_cart,
                          size: 30,
                              color: Colors.white,
                        )),
                        cubit.cartItems.isNotEmpty
                            ? Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Center(
                                    child: Text(
                                  cubit.cartItems.length.toString(),
                                  style: const TextStyle(
                                      fontSize: 10, fontWeight: FontWeight.bold),
                                )),
                              )
                            : Container()
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 5,),
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
            appBar: myAppBar(text: "Tamer Deweek", context: context),
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
                              children: const [
                                Icon(Icons.search),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("Search"),
                                Spacer(),
                                Icon(Icons.local_pharmacy_rounded),
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
                            ),
                            items: [1, 2, 3, 4, 5].map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return offerCard();
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
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Brands",
                                  style: TextStyle(
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
                              child: GridView.count(
                                physics: defaultScrollPhysics,
                                primary: false,
                                padding: const EdgeInsets.all(10),
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5,
                                crossAxisCount: 3,
                                children: [
                                  photoWithError(
                                      imageLink:
                                          "https://www.scrolldroll.com/wp-content/uploads/2020/03/gillette-logo.jpg"),
                                  photoWithError(
                                    imageLink:
                                        "https://mir-s3-cdn-cf.behance.net/projects/404/70822d53075295.Y3JvcCw5MjMsNzIyLDAsMjE0.jpg",
                                  ),
                                  photoWithError(
                                    imageLink:
                                        "https://seeklogo.com/images/P/pampers-logo-D613293CC6-seeklogo.com.png",
                                  ),
                                  photoWithError(
                                    imageLink:
                                        "https://pbs.twimg.com/profile_images/1312124968411504640/cClEe45Z_400x400.jpg",
                                  ),
                                  photoWithError(
                                    imageLink:
                                        "https://www.redafrica.xyz/wp-content/uploads/2020/01/CloseUP-Logo.png",
                                  ),
                                  photoWithError(
                                    imageLink:
                                        "https://i.pinimg.com/736x/ff/c6/d3/ffc6d3054e864678e01b6823d3e26503.jpg",
                                  ),
                                  photoWithError(
                                    imageLink:
                                        "https://pbs.twimg.com/profile_images/1566237760/logo-vatika_400x400.jpg",
                                  ),
                                  photoWithError(
                                    imageLink:
                                        "https://www.sampleroom.ph/image/catalog/brand-partners/HandS_logo.jpg",
                                  ),
                                  photoWithError(
                                    imageLink:
                                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ9T6ApEOkNdZSMZwqlo7Tb6B2XXGOKF7NPEAW-o8P4EwM-j-fLrNnjvnnU-xQRjzsEFPY&usqp=CAU",
                                  ),
                                ],
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
            title: const Text('Are you sure?'),
            content: const Text('Do you want to Exit'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  Widget offerCard() {
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
                        child: Image.network(
                            "https://m.media-amazon.com/images/I/71+Zza6xeNL._SY355_.jpg")),
                    Positioned(
                      top: -20,
                      child: SizedBox(
                          child: Image.network(
                        "https://freepngimg.com/thumb/categories/1219.png",
                      )),
                    ),
                  ],
                ),
              ),
            ),
            const Positioned(
                top: 10,
                left: 10,
                child: Text(
                  "Today's Offer",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                )),
            const Positioned(
              left: 20,
              top: 50,
              child: SizedBox(
                width: 110,
                child: Text(
                  "Head and Shoulders Shampoo 400 ml",
                  style: TextStyle(
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
                  child: const Text(
                    "Add to cart",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                )),
            Positioned(
              right: -12,
              bottom: -12,
              child: Container(
                child: const Center(
                  child: Text(
                    "30%",
                    style: TextStyle(
                        fontSize: 30,
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
