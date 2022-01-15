import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacyapp/cubit/signing_cubit.dart';
import 'package:pharmacyapp/cubit/states.dart';
import '../contsants/const_colors.dart';
import '../reusable/components.dart';
import 'make_order_page.dart';



class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

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


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SigningCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        SigningCubit cubit = SigningCubit.get(context);

        return  WillPopScope(
          onWillPop: () => onWillPop(context),
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
              tooltip: "Ask the Doctor",
              elevation: 10,
              backgroundColor: themeColor,
              onPressed: () {},
              child: const Icon(Icons.message_outlined),
            ),
            appBar: myAppBar("Tamer Deweek", themeColor),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(themeColor),
                    ),
                    onPressed: () {
                      cubit.navigateTo(context, MakeAnOrderScreen(), true);
                    },
                    child: SizedBox(
                      width: 300,
                      child: Row(
                        children: const [
                          Icon(Icons.view_list),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Make an Order"),
                          Spacer(),
                          Icon(Icons.search),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){

                    },
                    child: CarouselSlider(
                      options: CarouselOptions(height: 200.0, autoPlay: true,),

                      items: [1,2,3,4,5].map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return offerCard();
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Card(
                      elevation: 15,
                      shadowColor: Colors.black,
                      color: const Color(0xff254ea6),
                      child: SizedBox(
                        width: 300,
                        height: 120,
                        child: Stack(
                          children: [
                            const Positioned(
                                right: 10,
                                top: 10,
                                child: Icon(
                                  Icons.document_scanner,
                                  color: Colors.white,
                                  size: 60.0,
                                )),
                            Positioned(
                              left: 0,
                              child: Image.network(
                                "https://mir-s3-cdn-cf.behance.net/projects/404/7cb21683865409.Y3JvcCwyNzQ4LDIxNTAsMTIyLDA.jpg",
                                width: 160,
                              ),
                            ),
                            const Positioned(
                                right: 35,
                                top: 25,
                                child: SizedBox(
                                  width: 120,
                                  child: Text(
                                    "Send Doctor's Prescription",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: EdgeInsetsGeometry.infinity.horizontal,
                    child: const Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Center(
                        child: Text(
                          "Brands",
                          style: TextStyle(
                            fontSize: 20,
                            color: themeColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            color: Colors.teal),
                        child: GridView.count(
                          primary: false,
                          padding: const EdgeInsets.all(20),
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          crossAxisCount: 3,
                          children: [
                            photoWithError(
                                "https://www.scrolldroll.com/wp-content/uploads/2020/03/gillette-logo.jpg",
                                ""),
                            photoWithError(
                                "https://mir-s3-cdn-cf.behance.net/projects/404/70822d53075295.Y3JvcCw5MjMsNzIyLDAsMjE0.jpg",
                                ""),
                            photoWithError(
                                "https://seeklogo.com/images/P/pampers-logo-D613293CC6-seeklogo.com.png",
                                ""),
                            photoWithError(
                                "https://pbs.twimg.com/profile_images/1312124968411504640/cClEe45Z_400x400.jpg",
                                ""),
                            photoWithError(
                                "https://www.redafrica.xyz/wp-content/uploads/2020/01/CloseUP-Logo.png",
                                ""),
                            photoWithError(
                                "http://assets.stickpng.com/thumbs/589a40535aa6293a4aac48a6.png",
                                ""),
                            photoWithError(
                                "https://pbs.twimg.com/profile_images/1566237760/logo-vatika_400x400.jpg",
                                ""),
                            photoWithError(
                                "https://www.sampleroom.ph/image/catalog/brand-partners/HandS_logo.jpg",
                                ""),
                            photoWithError(
                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ9T6ApEOkNdZSMZwqlo7Tb6B2XXGOKF7NPEAW-o8P4EwM-j-fLrNnjvnnU-xQRjzsEFPY&usqp=CAU",
                                ""),
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
}


