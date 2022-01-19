import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_database/firebase_database.dart';
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
import 'package:pharmacyapp/models/order_model.dart';
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
  final DatabaseReference _fireBase =
      FirebaseDatabase.instance.ref(); // real time firebase object
  static late AppUser userData; // userId


  String languageState = 'English';   // all states is 'English' - 'Arabic' - 'System'
  String themeState = 'Light';   // all states is 'Light' - 'Dark' - 'System'
  bool isEnglish = true; // english -> true   , arabic -> false
  bool isLight = true; // light -> true  ,  dark -> false

  bool newMessage = false;

  List<OrderItem> cartItems = [];
  List<String> orderImages = [];
  bool activeOrder = false;
  // List<OfferItem> offerItems = [];

  // start function
  void mainStart() {
    _loadDataBase();

    _fireBase.child(userData.phone).get().then((snapshot) {
      /// check if there any active orders
      DataSnapshot orders = snapshot.child("orders");
      if (orders.exists) {
        String map = json.encode(orders.value);
        Map<String, dynamic> mapA = json.decode(map);
        activeOrder = mapA.values.contains("wait");
      }

      /// see if there message
      DataSnapshot messages = snapshot.child("message");
      if (messages.exists) {
        String map = json.encode(messages.value);
        Map<String, dynamic> mapA = json.decode(map);
        newMessage = !mapA['user'];
      }
      emit(GetFireStateDone());
    }).catchError((err) {
      print(err);
    });
  }

  void appStart(String? uPhone,String lang, String theme) async {
    emit(InitialStateLoading());

    themeState = theme;
    languageState = lang;
    // read user data
    if (uPhone != null) {
      String name =
          PreferenceHelper.getDataFromSharedPreference(key: "userName");
      Map<String, dynamic> name_ = json.decode(name);
      userData = AppUser(uPhone, name_['first']!, name_['second']!);
      mainStart();
    }

    emit(InitialStateDone());
  }

  /// cart an order functions
  Future<void> addOrderImage(XFile file) async {
    String image = await uploadFile(File(file.path), "prec");
    print(image);
    orderImages.add(image);
    emit(AddCartItemState());
    _saveCartLocal();
  }

  void removeOrderImage(int index) {
    orderImages.removeAt(index);
    emit(AddCartItemState());
    _saveCartLocal();
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
      _saveCartLocal();
    }
  }

  void removeFromCart(int index) {
    cartItems.removeAt(index);
    emit(AddCartItemState());
    _saveCartLocal();
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
    _saveCartLocal();
    emit(ChangeCartItemState());
  }

  void _saveCartLocal() {
    List<Map<String, dynamic>> orderDrugs = cartItems
        .map((e) => {"id": e.drug.id, "quantity": e.quantity})
        .toList();
    Map<String, dynamic> cartData = {
      "OrderDrugs": orderDrugs,
      "OrderImages": orderImages,
    };
    PreferenceHelper.putDataInSharedPreference(
        key: "cartData", value: cartData);
  }

  Future<void> _readCartLocal(Map<String, dynamic> cartData) async {
    emit(CartItemsLoading());
    List<dynamic> tempImages = cartData['OrderImages'];
    orderImages = tempImages.map((e) => e.toString()).toList();
    List<dynamic> orderDrugs = cartData['OrderDrugs'];
    for (dynamic orderItem in orderDrugs) {
      Drug drug = (await (findInDataBase(id: orderItem['id'])))[0];
      cartItems.add(OrderItem(drug, orderItem['quantity']));
    }
    emit(CartItemsDone());
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
      if (await _isConnected()) {
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
          _fireBase
              .child(userData.phone)
              .child("orders")
              .update({value.id: "wait"});

          DioHelper dioHelper = DioHelper();
          print(await dioHelper.postData(
              sendData: {"type": "newOrder", "orderId": value.id},
              title: "New order",
              body: "Order received from ${userData.phone}",
              receiverUId: "admin"));

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
          PreferenceHelper.clearDataFromSharedPreference(key: "cartData");
          activeOrder = true;

          emit(SendOrderState());
          EasyLoading.dismiss();
          navigateTo(context, MainScreen(null), false);
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
  Future<void> _loadDataBase() async {
    String databasePath = await getDatabasesPath();
    print(userData.phone);
    String path = "$databasePath/${userData.phone}-drugs.db";

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

    String? data =
        PreferenceHelper.getDataFromSharedPreference(key: "cartData");
    if (data != null) {
      _readCartLocal(json.decode(data));
    }
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

  Future<List<OrderModel>> getAllArchiveData() async {
    List<OrderModel> returnedData = [];
    List<Map<String, dynamic>> queryData;
    DataSnapshot fireOrder =
        await _fireBase.child(userData.phone).child("orders").get();

    if (fireOrder.exists) {
      String map = json.encode(fireOrder.value);
      Map<String, dynamic> stateMap = json.decode(map);
      print(stateMap);
      queryData = await _dataBase.query("orders");
      if (queryData.isEmpty) {
        stateMap.forEach((key, value) async {
          DocumentSnapshot<Map<String, dynamic>> orderData;
          if (value == "wait") {
            orderData = await _fireStore
                .collection("active orders")
                .doc("current")
                .collection(userData.phone)
                .doc(key)
                .get();
          } else {
            orderData = await _fireStore
                .collection("active orders")
                .doc("archive")
                .collection(userData.phone)
                .doc(key)
                .get();
          }
          if (orderData.exists) {
            print(orderData.data());
            returnedData.add(OrderModel(
                oId: key,
                orderData: orderData.data()!,
                isActive: value == "wait",
                fromFire: true));
            _dataBase.insert("orders", {
              "id": key,
              "price": orderData['Items Price'],
              "itemsCount": orderData['ItemsCount'],
              "imageCount": orderData['ImagesCount'],
              "time": orderData['time'],
              "details": json.encode(orderData.data()),
            });
          }
        });
        return returnedData;
      } else {
        print(queryData);
        for (Map<String, dynamic> e in queryData) {
          String id = e['id'];
          String? status = stateMap[id];
          if (status != null) {
            // get order state at every order form data base ;
            returnedData.add(OrderModel(
              oId: id,
              orderData: e,
              isActive: status == "wait",
            ));
          } else {
            _dataBase.delete("orders", where: "id =  $id").catchError((err) {
              print("deleted before");
              return 0;
            });
          }
        }
        return returnedData;
      }
    } else {
      return [];
    }
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
  Future<String> uploadFile(File file, String place) async {
    // to show the photo professional use Future builder this
    // https://stackoverflow.com/questions/51983011/when-should-i-use-a-futurebuilder
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref =
        storage.ref().child(place).child("file" + DateTime.now().toString());
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
    EasyLoading.show(status: 'getting location..');

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      EasyLoading.showError('Location services are disabled.');
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
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

    // print(pos.longitude);
    // print(pos.latitude);

    EasyLoading.dismiss();
    return fullLocation;
  }

  Future<bool> _isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
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
          PreferenceHelper.clearDataFromSharedPreference(key: "cartData");
          EasyLoading.dismiss();
          userData.phone = "notYet";
          cartItems = [];
          orderImages = [];
          activeOrder = false;
          newMessage = false;
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
