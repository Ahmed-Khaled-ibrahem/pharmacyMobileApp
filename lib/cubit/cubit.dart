import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacyapp/layouts/main_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitial());
  static AppCubit get(context) => BlocProvider.of(context);

  Database? dataBase;

  int counter = 0;
  // bool mobileCode = true;
  int angle1 = 0;
  int angle2 = 3;

  void loginButtonEvent({
    required BuildContext context,
    required userName,
    required password,
  }) {
    emit(LogInLoadingState());
    /*
     check user here
     using username.text
     and password.text
    */

    if (((userName == "ahmed") & (password == "666666")) ||
        (userName == "admin")) {
      EasyLoading.show(status: 'Connecting..');
      Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();

        /*
        Navigator.pushReplacement(
          context,
          PageTransition(
              type: PageTransitionType.rightToLeft,
              child: const MainScreen(),
              inheritTheme: true,
              ctx: context),
        );

         */
      });
      emit(LogInDoneState());
    } else {
      EasyLoading.showToast('Wrong Password user:ahmed pass:666666');
      emit(LogInErrorState());
    }
  }

  // Future<List<List<dynamic>>> readCsvData() async {
  //   int now = DateTime.now().millisecondsSinceEpoch;
  //   String dataString =
  //       await rootBundle.loadString('assets/drugs_data/data.csv');
  //
  //   List<List<dynamic>> dataFrame =
  //       const CsvToListConverter().convert(dataString);
  //   print(
  //       "taken time to read data ${DateTime.now().millisecondsSinceEpoch - now} ms");
  //   print(dataFrame.sublist(445, 455));
  //   return dataFrame;
  // }

  void initialReadSqlData() async {
    String databasePath = await getDatabasesPath();
    String path = "$databasePath/drugs.db";

    // await deleteDatabase(path);

    bool exists = await databaseExists(path);
    if (!exists) {
      // database read before
      ByteData data = await rootBundle.load("assets/drugs_data/testSql.db");
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes);
    }

    dataBase = await openDatabase(path);

    // 	"price"	NUMERIC,
    // 	"img"	TEXT,
    // 	"details"	TEXT
  }

  Future<List<Map<String, dynamic>>> readSqlData(String subWord) async {
    List<Map<String, dynamic>> queryData =
        await dataBase!.query("data", where: "name LIKE  \"%$subWord%\"");
    //print(queryData);
    //  "name"	TEXT,
    // 	"price"	NUMERIC,
    // 	"img"	TEXT,
    // 	"details"	TEXT
    return queryData;
  }

  Future<void> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    EasyLoading.show(status: 'getting location..');

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      EasyLoading.showToast('Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        EasyLoading.showToast('Location permissions are denied',
            maskType: EasyLoadingMaskType.clear);
        return;
      }
    } else if (permission == LocationPermission.deniedForever) {
      EasyLoading.showToast(
          'Location permissions are permanently denied, we cannot request permissions.');
      return;
    }

    Position pos = await Geolocator.getCurrentPosition();

    List<Placemark> placeMarks =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);
    Placemark place = placeMarks[0];

    print(pos.longitude);
    print(pos.latitude);
    print(place);

    EasyLoading.dismiss();
  }

  void gMailRegistration(BuildContext context) {
    EasyLoading.show(status: 'Connecting..');
    Timer(const Duration(seconds: 1), () {
      EasyLoading.dismiss();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  const MainScreen()),
      );
      /*
      Navigator.pushReplacement(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeft,
            child: const MainScreen(),
            ctx: context),
      );

       */
    });
    emit(GeneralState());
  }

  void swipeScreen() {
    angle1 = 3;
    angle2 = 0;
    emit(GeneralState());
  }

  void swipeBackScreen() {
    angle1 = 0;
    angle2 = 3;
    emit(GeneralState());
  }

  void incrementCounter() {
    //angle+=40;
    emit(GeneralState());
  }

  void emitGeneralState() {
    emit(GeneralState());
  }
}
