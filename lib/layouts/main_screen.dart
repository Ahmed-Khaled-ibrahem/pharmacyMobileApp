import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacyapp/cubit/cubit.dart';
import 'package:pharmacyapp/cubit/states.dart';

import '../contsants/const_colors.dart';
import '../reusable/components.dart';
import 'make_order_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        // AppCubit cubit = AppCubit.get(context);

        Future<bool> showExitPopup() async {
          AlertDialog alert = AlertDialog(
            title: const Text("Alert"),
            content: const Text("Are you sure tou want to exit?"),
            actions: [
              TextButton(
                child: const Text("Cancel"),
                onPressed:  () {},
              ),
              TextButton(
                child: const Text("Exit"),
                onPressed:  () {},
              ),
            ],
          );
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return alert;
            },
          );
          return true;

        }
        
        return WillPopScope(
          onWillPop: showExitPopup,
          child: Scaffold(
            appBar: myAppBar("Tamer Deweek", themeColor),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: const MakeAnOrderScreen(),
                              inheritTheme: true,
                              ctx: context));
                    },
                    child: const Text("Make an Order"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
