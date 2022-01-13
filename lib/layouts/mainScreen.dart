import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacyapp/cubit/cubit.dart';
import 'package:pharmacyapp/cubit/reusable/classes.dart';
import 'package:pharmacyapp/cubit/states.dart';

import 'makeOrderPage.dart';

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
        AppCubit cubit = AppCubit.get(context);

        return Scaffold(
          appBar:  myAppBar("Tamer Deweek",cubit.themeColor),

          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:  [
                 TextButton(onPressed: (){
                   Navigator.push(context,
                       PageTransition(
                           type: PageTransitionType.rightToLeft,
                           child: const MakeAnOrderScreen(),
                           inheritTheme: true,
                           ctx: context));

                 },
                   child: const Text("Make an Order"),),

              ],
            ),
          ),
        );
      },
    );
  }
}
