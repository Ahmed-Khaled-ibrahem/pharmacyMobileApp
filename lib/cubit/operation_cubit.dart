import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacyapp/models/drug_model.dart';
import 'package:pharmacyapp/models/user_model.dart';
import 'package:pharmacyapp/reusable/funcrions.dart';
import 'package:pharmacyapp/screens/show_screens/main_screen.dart';
import 'package:pharmacyapp/screens/signing/login_screen.dart';
import 'package:pharmacyapp/shared/fcm/dio_helper.dart';
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

  bool newMessage = true;

  List<OrderItem> cartItems = [];
  List<String> orderImages = [];
  // List<OfferItem> offerItems = [];

  /// cart an order functions
  Future<void> addOrderImage(XFile file) async {
    String image = await uploadPhoto(File(file.path), "prec");
    print(image);
    orderImages.add(image);
    emit(AddCartItemState());
  }

  void removeOrderImage(int index) {
    orderImages.removeAt(index);
    emit(AddCartItemState());

    FirebaseStorage.instance
        .refFromURL(orderImages[index])
        .delete()
        .then((value) => print("deleted successful"))
        .catchError((err) => print(err));
  }

  void addToCart(Drug drug) {
    if (cartItems.map((e) => e.drug.id).toList().contains(drug.id)) {
      EasyLoading.showToast("Item already in cart");
    } else {
      cartItems.add(OrderItem(drug, 1));
      emit(AddCartItemState());
    }
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

  void submitOrder({
    required BuildContext context,
    required String userName,
    required String userPhone,
    required String userAddress,
    required String description,
  }) async {
    if (cartItems.isEmpty && orderImages.isEmpty) {
      EasyLoading.showToast("No items in cart");
    } else {
      EasyLoading.show(status: "sending order..");
      if (await isConnected()) {
        List<Map<String, dynamic>> orderDrugs = cartItems
            .map((e) => {"id": e.drug.id, "quantity": e.quantity})
            .toList();

        Map<String, dynamic> orderData = {
          "Name": userName,
          "ContactPhone": userPhone,
          "UserPhone": userData.phone,
          "UserAddress": userAddress,
          "ItemsCount": cartItems.length,
          "ImagesCount": orderImages.length,
          "Items Price": calcOrderPrice(),
          "time": DateTime.now().toString(),
          "OrderDrugs": orderDrugs,
          "OrderImages": orderImages,
          "description": description,
        };

        _fireStore
            .collection("active orders")
            .doc("current")
            .collection(userData.phone)
            .add(orderData)
            .then((value) async {
          _fireStore
              .collection("users")
              .doc(userData.phone)
              .collection("orders")
              .doc(value.id)
              .set({"state": "waiting"});

          _dataBase.insert("orders", {
            "id": value.id,
            "price": orderData['Items Price'],
            "itemsCount": cartItems.length,
            "imageCount": orderImages.length,
            "time": orderData['time'],
            "details": json.encode(orderData),
          });
          cartItems = [];
          orderImages = [];
          DioHelper dioHelper = DioHelper();
          print(await dioHelper.postData(
              sendData: {"type": "newOrder", "orderId": value.id},
              title: "New order",
              body: "Order received from ${userData.phone}",
              receiverUId: "admin"));
          emit(SendOrderState());
          EasyLoading.dismiss();
          navigateTo(context, const MainScreen(), false);
        }).catchError((err) {
          print(err);
          EasyLoading.showError("Error happened while sending ");
        });
      } else {
        EasyLoading.showError("No internet connection");
      }
    }
  }

  ///-----------------------------------------------------------------------///

  /// deal with data base
  void initialReadSqlData(String? uPhone) async {
    emit(InitialStateLoading());
    // read user data
    if (uPhone != null) {
      String name =
          PreferenceHelper.getDataFromSharedPreference(key: "userName");
      Map<String, dynamic> name_ = json.decode(name);
      userData = AppUser(uPhone, name_['first']!, name_['second']!);
    }

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
    emit(InitialStateDone());
  }

  void reverseFavorites(Drug drug) {
    drug.isFav = !drug.isFav;
    emit(ChangeFavState());
    _dataBase.update("data", {"favorite": drug.isFav ? 1 : 0},
        where: "id = ${drug.id}");
  }

  Future<List<Drug>> getFavoriteList() async {
    List<Map<String, dynamic>> queryData =
        await _dataBase.query("data", where: "favorite = 1");
    return queryData.map((e) => Drug(drudData: e)).toList();
  }

  Future<List<Map<String, dynamic>>> getAllArchiveData() async {
    List<Map<String, dynamic>> queryData;
    queryData = await _dataBase.query("orders");
    return queryData;
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
  Future<String> uploadPhoto(File file, String place) async {
    // to show the photo professional use Future builder this
    // https://stackoverflow.com/questions/51983011/when-should-i-use-a-futurebuilder

    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref =
        storage.ref().child(place).child("image1" + DateTime.now().toString());
    UploadTask uploadTask = ref.putFile(file);

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

  Future<String?> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    EasyLoading.show(status: 'getting location..');

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      EasyLoading.showError('Location services are disabled.');
      return null;
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        EasyLoading.showError('Location permissions are denied',
            maskType: EasyLoadingMaskType.clear);
        return null;
      }
    } else if (permission == LocationPermission.deniedForever) {
      EasyLoading.showError(
          'Location permissions are permanently denied, we cannot request permissions.');
      return null;
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

    String fullLocation = place.subThoroughfare ?? '';
    fullLocation += ' ';
    fullLocation += place.thoroughfare ?? '';
    fullLocation += ' ';
    fullLocation += place.locality ?? '';
    fullLocation += ' ';
    fullLocation += place.subAdministrativeArea ?? '';
    fullLocation += ' ';
    fullLocation += place.administrativeArea ?? '';
    fullLocation += ' ';
    fullLocation += place.country ?? '';

    EasyLoading.dismiss();
    return fullLocation;
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

  Future<bool> isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }

  void emitGeneralState() {
    emit(GeneralState());
  }
}
