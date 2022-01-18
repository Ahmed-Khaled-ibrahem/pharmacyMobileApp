import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacyapp/contsants/const_colors.dart';
import 'package:pharmacyapp/models/drug_model.dart';
import 'package:pharmacyapp/models/offer_model.dart';
import 'package:pharmacyapp/models/user_model.dart';
import 'package:pharmacyapp/reusable/funcrions.dart';
import 'package:pharmacyapp/screens/signing/login_screen.dart';
import 'package:pharmacyapp/shared/pref_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitial());
  static AppCubit get(context) => BlocProvider.of(context);

  late Database _dataBase; // SQL-LITE database object
  final FirebaseFirestore _fireStore =
      FirebaseFirestore.instance; // fire-store database object
  static late AppUser userData; // userId

  bool isEnglish = true; // english -> true   , arabic -> false
  bool isLight = true; // light -> true  ,  dark -> false

  //List<List<int>> cartList = [[],[]];
  //Map<List<int>, List<int>> cartList =  <List<int>, List<int>>{};
  //var twoDList = List.generate(row, (i) => List(col), growable: false);

  /// replaced with cartItems
  // order
  // List<int> cartItemsIds = [3, 300, 200];
  // List<int> cartItemsQuantity = [3, 2, 3];

  /// with offerItems
  //  offers
  // List<int> offersItemsID = [1, 10, 5];
  // List<bool> priceOrPercentage = [true, true, true];
  // List<int> priceValue = [1, 10, 5];

  List<OrderItem> cartItems = [];
  List<String> orderImages = [];
  List<OfferItem> offerItems = [];

  /// cart functions
  Future<void> addOrderImage(BuildContext context) async {
    XFile? file = await takePhoto(context);
    if (file != null) {
      String image = await uploadPhoto(file, "prec");
      print(image);
      orderImages.add(image);
      emit(AddCartItemState());
    }
  }

  void removeOrderImage(int index) {
    String filePath = orderImages[index].replaceAll(
        r'https://firebasestorage.googleapis.com/v0/b/pharmacy-app-ffac0.appspot.com/o/',
        '');
    print(filePath);

    // orderImages.removeAt(index);
    emit(AddCartItemState());

    FirebaseStorage.instance
        .refFromURL(orderImages[index])
        .delete()
        .then((value) => print("deleted successful"))
        .catchError((err) => print(err));
  }

  void addToCart(Drug drug) {
    cartItems.add(OrderItem(drug, 1));
    emit(AddCartItemState());
  }

  void removeFromCart(int index) {
    cartItems.removeAt(index);
    emit(AddCartItemState());
  }

  void changeCartQuantity(
      {required int index, bool increase = true, int? newValue}) {
    if (newValue == null) {
      if (increase) {
        cartItems[index].quantity++;
      } else {
        if (cartItems[index].quantity > 1) {
          cartItems[index].quantity--;
        }
      }
    } else {
      cartItems[index].quantity = newValue;
    }
    emit(ChangeCartItemState());
  }

  double calcOrderPrice() {
    double price = 0;
    for (OrderItem item in cartItems) {
      price += item.quantity * item.drug.price;
    }
    price = double.parse(price.toStringAsFixed(2));
    return price;
  }

  void submitOrder() {
    if (cartItems.isNotEmpty) {
    } else {
      EasyLoading.showToast("No items in cart");
    }
  }

  /// deal with data base
  void initialReadSqlData(String? uPhone) async {
    if (uPhone != null) {
      String name =
          PreferenceHelper.getDataFromSharedPreference(key: "userName");
      Map<String, dynamic> name_ = json.decode(name);
      userData = AppUser(uPhone, name_['first']!, name_['second']!);
    }

    String databasePath = await getDatabasesPath();
    String path = "$databasePath/drugs.db";

    await deleteDatabase(path);

    bool exists = await databaseExists(path);
    if (!exists) {
      // database read before
      ByteData data = await rootBundle.load("assets/drugs_data/testSql.db");
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes);
    }
    _dataBase = await openDatabase(path);
  }

  void makeFavorites(int id, {bool remove = false}) {
    _dataBase.update("data", {"favorite": !remove ? 1 : 0}, where: "id = $id");
  }

  Future<List<Drug>> getFavoriteList() async {
    List<Map<String, dynamic>> queryData =
        await _dataBase.query("data", where: "favorite = 1");
    return queryData.map((e) => Drug(drudData: e)).toList();
  }

  Future<List<Drug>> findInDataBase({String? subName, int? id}) async {
    List<Map<String, dynamic>> queryData;

    if (subName != null) {
      queryData =
          await _dataBase.query("data", where: "name LIKE  \"%$subName%\"");
    } else {
      queryData = await _dataBase.query("data", where: "id =  $id");
    }
    return queryData.map((e) => Drug(drudData: e)).toList();
  }

  /// helper for make order
  Future<String> uploadPhoto(XFile file, String place) async {
    // to show the photo professional use Future builder this
    // https://stackoverflow.com/questions/51983011/when-should-i-use-a-futurebuilder

    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref =
        storage.ref().child(place).child("image1" + DateTime.now().toString());
    UploadTask uploadTask = ref.putFile(File(file.path));

    uploadTask.snapshotEvents.listen((event) async {
      double percentage = event.bytesTransferred / event.totalBytes;
      EasyLoading.showProgress(percentage, status: 'uploading...');
    }).onError((err) {
      EasyLoading.showError("Error while uploading the photo..");
    });

    TaskSnapshot task = await uploadTask.catchError((err) {
      EasyLoading.showError("Error while uploading the photo..");
    });
    String link = await task.ref.getDownloadURL();
    EasyLoading.dismiss();
    return link;
  }

  Future<void> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    EasyLoading.show(status: 'getting location..');

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      EasyLoading.showError('Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        EasyLoading.showError('Location permissions are denied',
            maskType: EasyLoadingMaskType.clear);
        return;
      }
    } else if (permission == LocationPermission.deniedForever) {
      EasyLoading.showError(
          'Location permissions are permanently denied, we cannot request permissions.');
      return;
    }

    Position pos = await Geolocator.getCurrentPosition();

    List<Placemark> placeMarks =
        await placemarkFromCoordinates(pos.latitude, pos.longitude)
            .catchError((err) {
      print(err);
      EasyLoading.dismiss();
    });
    Placemark place = placeMarks[0];

    print(pos.longitude);
    print(pos.latitude);
    print(place);

    EasyLoading.dismiss();
  }

  Future<XFile?> takePhoto(BuildContext context) async {
    if (await Permission.camera.request().isGranted) {
      ImageSource? source = await showGeneralDialog<ImageSource>(
        barrierLabel: "Barrier",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: const Duration(milliseconds: 700),
        context: context,
        pageBuilder: (_, __, ___) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Material(
              child: Container(
                margin: const EdgeInsets.only(bottom: 10, left: 12, right: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                ),
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(themeColor),
                      ),
                      label: const Text("Gallery"),
                      onPressed: () =>
                          Navigator.pop(context, ImageSource.gallery),
                      icon: const Icon(
                        Icons.image,
                        size: 35,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    OutlinedButton.icon(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(themeColor),
                      ),
                      label: const Text("Camera"),
                      onPressed: () =>
                          Navigator.pop(context, ImageSource.camera),
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        size: 35,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        transitionBuilder: (_, anim, __, child) {
          return SlideTransition(
            position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
                .animate(anim),
            child: child,
          );
        },
      );
      if (source != null) {
        XFile? pickedFile = await ImagePicker().pickImage(source: source);
        return pickedFile;
      }
    } else {
      EasyLoading.showToast("Can't open camera");
    }
  }

  /// logOut
  void logout(BuildContext context) {
    customChoiceDialog(context,
        title: "Logout",
        content: "Are you sure you want to logout ?", yesFunction: () {
      EasyLoading.show(status: "logging out...");
      try {
        if (userData.phone != "notYet") {
          FirebaseMessaging.instance.unsubscribeFromTopic(userData.phone);
          PreferenceHelper.clearDataFromSharedPreference(key: "phone");
          EasyLoading.dismiss();
          userData.phone = "notYet";
          cartItems = [];
          orderImages = [];
          navigateTo(context, const LoginScreen(), false);
        } else {
          EasyLoading.showToast("You must login first");
        }
      } catch (err) {
        if (err.toString().contains("LateInitializationError")) {
          EasyLoading.showToast("You must login first");
        } else {
          EasyLoading.showToast("An error happened at logout");
        }
      }
    });
  }

  void emitGeneralState() {
    emit(GeneralState());
  }
}
