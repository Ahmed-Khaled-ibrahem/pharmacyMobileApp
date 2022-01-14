import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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

    if ((userName == "ahmed") & (password == "666666")) {
      EasyLoading.show(status: 'Connecting..');
      Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
        Navigator.pushReplacement(
          context,
          PageTransition(
              type: PageTransitionType.rightToLeft,
              child: const MainScreen(),
              inheritTheme: true,
              ctx: context),
        );
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

  void gMailRegistration(BuildContext context) {
    EasyLoading.show(status: 'Connecting..');
    Timer(const Duration(seconds: 1), () {
      EasyLoading.dismiss();
      Navigator.pushReplacement(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeft,
            child: const MainScreen(),
            inheritTheme: true,
            ctx: context),
      );
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
