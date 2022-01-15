import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pharmacyapp/cubit/signing_cubit.dart';
import 'package:pharmacyapp/reusable/pref_helper.dart';
import 'contsants/const_colors.dart';
import 'cubit/operation_cubit.dart';
import 'layouts/signing/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    // navigation bar color
    statusBarColor: Color.fromRGBO(0, 0, 0, 0), // status bar color
  ));

  configLoading();

  PreferenceHelper.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (BuildContext context) => AppCubit()..initialReadSqlData()),
        BlocProvider(create: (BuildContext context) => SigningCubit()),
      ],
      child: MaterialApp(
        builder: EasyLoading.init(),
        title: 'Pharmacy',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          backgroundColor: themeColor,
          appBarTheme: const AppBarTheme(backgroundColor: themeColor),
          //canvasColor: AppCubit().themeColor,
          primaryColor: Colors.white,
          focusColor: Colors.white,
          unselectedWidgetColor: Colors.white,
          splashColor: Colors.white,
          scaffoldBackgroundColor: const Color(0xFFFFF9F9),
        ),
        home: const LoginScreen(), //const MakeAnOrderScreen(), //
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
