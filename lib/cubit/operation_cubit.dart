import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sqflite/sqflite.dart';
import 'states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitial());
  static AppCubit get(context) => BlocProvider.of(context);

  Database? _dataBase; // SQL-LITE database object

  /// deal with data base
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

    _dataBase = await openDatabase(path);

    // 	"price"	NUMERIC,
    // 	"img"	TEXT,
    // 	"details"	TEXT
  }

  Future<List<Map<String, dynamic>>> findInDataBase(String subWord) async {
    List<Map<String, dynamic>> queryData =
        await _dataBase!.query("data", where: "name LIKE  \"%$subWord%\"");
    return queryData;
  }

  /// helper for make order
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

  void emitGeneralState() {
    emit(GeneralState());
  }
}