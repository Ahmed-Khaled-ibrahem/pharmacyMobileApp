import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pharmacyapp/cubit/signing_cubit.dart';
import 'screens/show_screens/main_screen.dart';
import 'package:pharmacyapp/screens/signing/login_screen.dart';
import 'shared/pref_helper.dart';
import 'cubit/operation_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color.fromRGBO(0, 0, 0, 0), // status bar color
  ));

  // configLoading();

  await PreferenceHelper.init();

  String? phone = PreferenceHelper.getDataFromSharedPreference(key: "phone");

  runApp(EasyDynamicThemeWidget(child: MyApp(phone)));
}

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  MyApp(this.phone, {Key? key}) : super(key: key);

  String? phone;
  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_MyAppState>()!.restartApp();
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void restartApp() {
    setState(() {});
  }

  String lang = PreferenceHelper.getDataFromSharedPreference(key: 'language') ??
      "English";
  String theme =
      PreferenceHelper.getDataFromSharedPreference(key: 'ThemeState') ??
          'Light';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (BuildContext context) =>
                AppCubit()..appStart(widget.phone, lang, theme)),
        BlocProvider(create: (BuildContext context) => SigningCubit()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        locale: lang == 'English'
            ? const Locale('en')
            : lang == 'Arabic'
                ? const Locale('ar')
                : null,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('ar', ''),
        ],
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: EasyDynamicTheme.of(context).themeMode,
        // navigatorKey: navigatorKey,
        builder: EasyLoading.init(),
        title: 'Pharmacy',
        debugShowCheckedModeBanner: false,
        /*
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

         */
        home: widget.phone == null
            ? const LoginScreen()
            : MainScreen(null), //const MakeAnOrderScreen(), //
      ),
    );
  }
}

// void configLoading() {
//   EasyLoading.instance
//     ..displayDuration = const Duration(milliseconds: 2000)
//     ..indicatorType = EasyLoadingIndicatorType.wanderingCubes
//     ..loadingStyle = EasyLoadingStyle.dark
//     ..indicatorSize = 45.0
//     ..radius = 10.0
//     ..progressColor = Colors.yellow
//     ..backgroundColor = Colors.green
//     ..indicatorColor = Colors.yellow
//     ..textColor = Colors.yellow
//     ..maskColor = Colors.blue.withOpacity(0.5)
//     ..userInteractions = true
//     ..dismissOnTap = false;
// }
