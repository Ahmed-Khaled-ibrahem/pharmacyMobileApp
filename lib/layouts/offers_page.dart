import 'package:pharmacyapp/cubit/signing_cubit.dart';
import 'package:pharmacyapp/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../contsants/const_colors.dart';
import '../../reusable/components.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({Key? key}) : super(key: key);

  @override
  _OffersScreenState createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SigningCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        // SigningCubit cubit = SigningCubit.get(context);

        return Scaffold(
            appBar: myAppBar("Current Offers", themeColor),
            body: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: 7,
                      separatorBuilder: (_, index) => const Divider(),
                      itemBuilder: (_, index) => Card(
                            color: Colors.green,
                            child: SizedBox(
                              height: 80,
                              child: Stack(
                                children: [
                                  Positioned(
                                      bottom: 0,
                                      left: 5,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  themeColor),
                                        ),
                                        onPressed: () {},
                                        child: Row(
                                          children: const [
                                            Icon(Icons.shopping_cart),
                                            Text(" add to cart "),
                                          ],
                                        ),
                                      )),
                                  const Positioned(
                                    top: 10,
                                    left: 10,
                                    child: Text(
                                      "Clear Shampoo 450ml",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: themeColor, width: 5),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Image.network(
                                        "https://cdnprod.mafretailproxy.com/sys-master-root/h08/hc7/14804221100062/492031_main.jpg_480Wx480H",
                                        width: 70,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 70,
                                    bottom: -10,
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
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        color: Colors.orangeAccent,
                                        borderRadius:
                                            BorderRadius.circular(200),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                ),
              ],
            ));
      },
    );
  }
}
