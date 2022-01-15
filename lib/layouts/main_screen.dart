import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../contsants/const_colors.dart';
import '../reusable/components.dart';
import 'make_order_page.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        appBar: myAppBar("Tamer Deweek", themeColor),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {},
                child: Card(
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
                        const Positioned(
                            left: 20,
                            bottom: 10,
                            child: Text(
                              "Add to cart",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
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
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: MakeAnOrderScreen(),
                          inheritTheme: true,
                          ctx: context));
                },
                child: const Text("Make an Order"),
              ),
              const Card(),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
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
}
