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
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacyapp/contsants/values.dart';
import 'package:pharmacyapp/models/drug_model.dart';
import 'package:pharmacyapp/models/message_model.dart';
import 'package:pharmacyapp/models/offer_model.dart';
import 'package:pharmacyapp/models/order_model.dart';
import 'package:pharmacyapp/models/user_model.dart';
import 'package:pharmacyapp/reusable/funcrions.dart';
import 'package:pharmacyapp/screens/show_screens/main_screen.dart';
import 'package:pharmacyapp/screens/signing/login_screen.dart';
import 'package:pharmacyapp/shared/fcm/dio_helper.dart';
import 'package:pharmacyapp/shared/fcm/fire_message.dart';
import 'package:pharmacyapp/shared/pref_helper.dart';
import 'package:pharmacyapp/shared/sub_/base_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'states.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitial());
  static AppCubit get(context) => BlocProvider.of(context);

  late Database _dataBase; // SQL-LITE database object
  final SubBaseHelper _subBase = SubBaseHelper();
  final FirebaseFirestore _fireStore =
      FirebaseFirestore.instance; // fire-store database object
  final DatabaseReference _fireBase =
      FirebaseDatabase.instance.ref(); // real time firebase object
  static late AppUser userData; // userId

  String languageState =
      'English'; // all states is 'English' - 'Arabic' - 'System'
  String themeState = 'Light'; // all states is 'Light' - 'Dark' - 'System'

  bool newMessage = false;
  bool activeOrder = false;
  int numberOfMessages = 0;
  int numberOfOrders = 0;

  List<OrderItem> cartItems = [];
  List<String> orderImages = [];
  List<OfferItem> offersList = [];


  bool locationIsDone = false;
  // start function
  void mainStart() {
    emit(InitialStateLoading());

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
      DataSnapshot messages = snapshot.child("messages");
      if (messages.exists) {
        String map = json.encode(messages.value);
        Map<String, dynamic> mapA = json.decode(map);
        newMessage = !mapA['user'];
        numberOfMessages = mapA['numberOfMessages'] ?? 0;
      }
      numberOfOrders =
          int.parse(snapshot.child("numberOfOrders").value.toString());

      emit(GetFireStateDone());
    }).catchError((err) {
      print(err);
    });
  }

  void appStart(String? uPhone, String lang, String theme) async {
    themeState = theme;
    languageState = lang;

    if (await Permission.notification.request().isGranted) {
      FireNotificationHelper(notificationHandler);
    }

    // read user data
    if (uPhone != null) {
      String name =
          PreferenceHelper.getDataFromSharedPreference(key: "userName");
      String? address =
          PreferenceHelper.getDataFromSharedPreference(key: "address");
      String photo = PreferenceHelper.getDataFromSharedPreference(
              key: "photo") ??
          "https://firebasestorage.googleapis.com/v0/b/pharmacy-app-ffac0.appspot.com/o/avatar.jpg?alt=media&token=231f9a7e-0dd8-496d-9d4f-7f068484dde4";
      Map<String, dynamic> name_ = json.decode(name);
      userData =
          AppUser(uPhone, name_['first']!, name_['second']!, photo, address);
      mainStart();
    }
  }

  void _readOffers() {
    _fireStore.collection("global").doc("offers").get().then((value) async {
      List<dynamic> offersData = value['offer'];
      for (var element in offersData) {
        OfferItem item = OfferItem((await findInDataBase(id: element['id']))[0],
            (element['offer'] * 1.0),
            isPercentage: element['isPercentage']);
        item.drug.price = element['isPercentage']
            ? item.drug.price * (element['offer'] / 100)
            : element['offer'] * 1.0;
        print(element['photo']);
        offersList.add(item);
      }

      emit(OffersListReady());
    }).catchError((err) {
      print(err);
    });
  }

  /// cart and orders functions
  Future<void> addOrderImage(XFile file) async {
    String image = await uploadFile(File(file.path), "prec");
    orderImages.add(image);
    emit(AddCartItemState());
    _saveCartLocal();
  }

  void removeOrderImage(int index) {
    orderImages.removeAt(index);
    emit(AddCartItemState());
    _saveCartLocal();
    deleteFile(orderImages[index]);
  }

  void addToCart(Drug drug) {
    if (!EasyLoading.isShow) {
      EasyLoading.showToast("Item added to cart");
    }
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

  Future<Map<String, dynamic>> readCartLocal(
      Map<String, dynamic> cartData) async {
    List<dynamic> tempImages = cartData['orderImages'] ?? [];
    tempImages = tempImages.map((e) => e.toString()).toList();
    List<dynamic> orderDrugs = cartData['OrderDrugs'];
    List<OrderItem> tempItems = [];
    for (dynamic orderItem in orderDrugs) {
      Drug drug = (await (findInDataBase(id: orderItem['id'])))[0];
      tempItems.add(OrderItem(drug, orderItem['quantity']));
    }
    return {
      "OrderImages": tempImages,
      "OrderDrugs": tempItems,
    };
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
        numberOfOrders++;
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
          "location": await determinePosition(latLan: true) ?? "denied",
        };
        String id = "$numberOfOrders";

        _fireStore
            .collection("active orders")
            .doc("current")
            .collection(userData.phone)
            .doc(id)
            .set(orderData)
            .then((value) async {
          _fireBase.child(userData.phone).child("orders").update({id: "wait"});
          _fireBase
              .child(userData.phone)
              .update({"numberOfOrders": numberOfOrders});

          DioHelper dioHelper = DioHelper();
          print(await dioHelper.postData(
              sendData: {
                "type": "newOrder",
                "user": userData.phone,
                "orderId": id,
                "orderData": json.encode(orderData)
              },
              title: "New order",
              body: "Order received from ${userData.phone}",
              receiverUId: "admin"));

          _dataBase.insert("orders", {
            "id": id,
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
          EasyLoading.showError("Error happened while sending ");
        });
      } else {
        EasyLoading.showError("No internet connection");
      }
    }
  }

  /// deal with data base
  Future<void> _loadDataBase() async {
    String databasePath = await getDatabasesPath();
    String path = "$databasePath/${userData.phone}-drugs.db";

    // await deleteDatabase(path);

    bool exists = await databaseExists(path);
    if (!exists) {
      ByteData data = await rootBundle.load("assets/drugs_data/testSql.db");
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes);
    }
    _dataBase = await openDatabase(path);

    // read local cart data if exist
    String? data =
        PreferenceHelper.getDataFromSharedPreference(key: "cartData");
    if (data != null) {
      emit(CartItemsLoading());
      readCartLocal(json.decode(data)).then((value) {
        cartItems = value['OrderDrugs'];
        orderImages = value['OrderImages'];
        emit(CartItemsDone());
      });
    }

    _readOffers();

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
    return queryData.map((e) => Drug(drugData: e)).toList();
  }

  Future<List<OrderModel>> getAllOrders() async {
    List<OrderModel> returnedData = [];
    List<Map<String, dynamic>> queryData;
    DataSnapshot fireOrder =
        await _fireBase.child(userData.phone).child("orders").get();

    if (fireOrder.exists) {
      String map = json.encode(fireOrder.value);
      Map<String, dynamic> stateMap = json.decode(map);

      queryData = await _dataBase.query("orders");
      if (queryData.isEmpty) {
        for (int i = 0; i < stateMap.length; i++) {
          String key = stateMap.keys.toList()[i];
          String value = stateMap.values.toList()[i];
          DocumentSnapshot<Map<String, dynamic>> orderData;
          if (value == "wait") {
            orderData = await _fireStore
                .collection("active orders")
                .doc("current")
                .collection(userData.phone)
                .doc(key.trim())
                .get();
          } else {
            orderData = await _fireStore
                .collection("active orders")
                .doc("archive")
                .collection(userData.phone)
                .doc(key.trim())
                .get();
          }
          if (orderData.exists) {
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
        }
        return returnedData;
      } else {
        for (Map<String, dynamic> e in queryData) {
          String id = e['id'].toString().trim();
          String? status = stateMap[id];
          if (status != null) {
            // get order state at every order form data base ;
            returnedData.add(OrderModel(
              oId: id,
              orderData: e,
              isActive: status.trim() == "wait",
            ));
          } else {
            _dataBase.delete("orders", where: "id =  $id").catchError((err) {
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

  Future<List<MessageModel>> getAllMessages() async {
    List<MessageModel> messagesData = (await _dataBase.query("messages"))
        .map((e) => MessageModel(jsonData: e))
        .toList();
    numberOfMessages = 1;
    if ((messagesData.length == numberOfMessages)) {
      return messagesData;
    } else {
      QuerySnapshot<Map<String, dynamic>> data = await _fireStore
          .collection("users")
          .doc(userData.phone)
          .collection("messages")
          .get();
      messagesData = [];
      for (var e in data.docs) {
        Map<String, dynamic> messageMap = e.data();
        messageMap['id'] = e.id;
        messagesData.add(MessageModel(jsonData: messageMap));
        _dataBase.insert("messages", messageMap);
      }
      return messagesData;
    }
  }

  Future<bool> saveMessage({
    String? id,
    required String body,
    required MessageType type,
    double? size,
    double? width,
    bool mine = true,
    String? time,
  }) async {
    numberOfMessages++;
    id ??= "$numberOfMessages";
    time ??= DateTime.now().toString();
    Map<String, dynamic> messageMap = {
      'id': id,
      'body': body,
      'type': {
        MessageType.text: "text",
        MessageType.image: "image",
        MessageType.file: "file"
      }[type],
      'size': size,
      'width': width,
      'time': time,
      'sender': mine ? 0 : 1,
      'status': 0
    };
    print(messageMap);

    if (mine) {
      if (await _isConnected()) {
        try {
          await _fireStore
              .collection("users")
              .doc(userData.phone)
              .collection("messages")
              .doc(id)
              .set(messageMap);
          messageMap['id'] = id;
          _fireBase.child(userData.phone).child("messages").update({
            "numberOfMessages": numberOfMessages,
            "doctor": false,
            "user": true
          });
          _dataBase.insert("messages", messageMap);

          DioHelper dioHelper = DioHelper();
          print(await dioHelper.postData(
              sendData: {
                "type": "newMessage",
                "user": userData.phone,
                "messageId": id,
                "messageData": json.encode(messageMap)
              },
              title: "New order",
              body: "Order received from ${userData.phone}",
              receiverUId: "admin"));
          return true;
        } catch (err) {
          print(err);
          return false;
        }
      } else {
        return false;
      }
    } else {
      _dataBase.insert("messages", messageMap);
      return true;
    }
  }

  Future<List<Drug>> findInDataBase({String? subName, int? id}) async {
    return _subBase.getDrugs(subName: subName, id: id);
  }

  /// helper for make order
  Future<String> uploadFile(File file, String place) async {
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

  void deleteFile(String url) {
    if (url != defaultUserImage) {
      FirebaseStorage.instance
          .refFromURL(url)
          .delete()
          .then((value) => print("deleted successful"))
          .catchError((err) => print(err));
    }
  }

  void getLatLang() async {
    locationIsDone = !locationIsDone;
    emitGeneralState();
  }

  Future<String?> determinePosition({bool latLan = false}) async {
    if (!latLan) {
      EasyLoading.show(status: 'getting location..');
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!latLan) {
        EasyLoading.showError('Location services are disabled.');
      }
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (!latLan) {
          EasyLoading.showError('Location permissions are denied');
        }
        return null;
      }
    } else if (permission == LocationPermission.deniedForever) {
      if (!latLan) {
        EasyLoading.showError(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
      return null;
    }

    Position pos = await Geolocator.getCurrentPosition();

    if (latLan) {
      return "${pos.latitude}, ${pos.longitude}";
    }

    List<Placemark> placeMarks =
        await placemarkFromCoordinates(pos.latitude, pos.longitude)
            .catchError((err) {
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

  /// notification receiver
  void notificationHandler(Map<String, dynamic> data) {
    String type = data['type'];
    String title;
    String body;

    switch (type) {
      case "orderConfirmation":
        activeOrder = false;
        _dataBase.update("orders", {"price": data['newPrice']},
            where: "id == ${data['orderId']}");
        body =
            "your order has received the price is ${data['price']} , the delivery will contact you soon";
        title = "Order confirmation";
        emit(NotificationReceived());
        break;
      case "newMessage":
        numberOfMessages++;
        newMessage = true;
        _dataBase.insert("messages", data["messageData"]);
        body = "The doctor sent you a message see it";
        title = "New message";
        emit(NotificationReceived());
        break;
      case "offers":
        body = "New offers available check them now";
        title = "New offers";
        _readOffers();
        emit(NotificationReceived());
        break;
      default:
        body = data['body'];
        title = data['title'];
    }
    showDialog(
      context: navigatorKey.currentState!.context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: [
            OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Ok")),
          ],
        );
      },
    );
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
          emit(UserLogOut());
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

  void changeUserData(
      {required String firstName,
      required String secondName,
      String? address,
      required BuildContext context}) async {
    if (await _isConnected()) {
      userData.firstName = firstName;
      userData.lastName = secondName;
      userData.address = address;

      await _fireStore.collection("users").doc(userData.phone).update({
        "name": {"first": firstName, "second": secondName},
        "photo": userData.photo,
        "address": address
      });

      PreferenceHelper.putDataInSharedPreference(
          key: "photo", value: userData.photo);
      PreferenceHelper.putDataInSharedPreference(
          key: "address", value: address);
      PreferenceHelper.putDataInSharedPreference(
          key: "userName", value: {"first": firstName, "second": secondName});
      EasyLoading.showToast("profile changed successfully");
      emit(ChangeUserProfileData());
      Navigator.of(context).pop();
    }
  }

  void emitGeneralState() {
    emit(GeneralState());
  }
}
