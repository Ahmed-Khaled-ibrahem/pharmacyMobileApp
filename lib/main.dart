import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:page_transition/page_transition.dart';
import 'cubit/cubit.dart';
import 'layouts/LoginScreen.dart';
import 'layouts/mainScreen.dart';
import 'layouts/makeOrderPage.dart';


Future<void> main() async {

  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(// navigation bar color
    statusBarColor: Color.fromRGBO(0, 0, 0, 0), // status bar color
  ));

  runApp(MyApp());
  configLoading();
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit(),
      child: MaterialApp(
        builder: EasyLoading.init(),
        title: 'Pharmacy',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          backgroundColor: AppCubit().themeColor,
          appBarTheme: AppBarTheme(backgroundColor: AppCubit().themeColor),
          //canvasColor: AppCubit().themeColor,
          primaryColor: Colors.white,
          focusColor: Colors.white,
          unselectedWidgetColor: Colors.white,

          splashColor: Colors.white,
          scaffoldBackgroundColor: const Color(0xFFFFF9F9),

        ),
        home: const MakeAnOrderScreen(),// const LoginScreen() ,
      ),
    );
  }
}


void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.wanderingCubes
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}
