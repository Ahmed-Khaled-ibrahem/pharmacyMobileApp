import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacyapp/models/drug_model.dart';
import 'package:pharmacyapp/models/offer_model.dart';
import 'package:pharmacyapp/shared/fcm/dio_helper.dart';
import 'package:pharmacyapp/shared/fcm/fire_message.dart';
import 'package:pharmacyapp/shared/sub_/base_helper.dart';
import 'states.dart';

class AdminCubit extends Cubit<AppStates> {
  AdminCubit() : super(AppInitial());
  static AdminCubit get(context) => BlocProvider.of(context);

  late TabController controller;
  final SubBaseHelper _subBase = SubBaseHelper();
  final FirebaseFirestore _fireStore =
      FirebaseFirestore.instance; // fire-store database object
  DioHelper dioHelper = DioHelper();

  List<OfferItem> offersList = [];

  Future<void> startAdminProcess() async {
    emit(AdminScreensLoading());
    _readOffers();
    if (await Permission.notification.request().isGranted) {
      FireNotificationHelper(notificationHandler);
    }
    FirebaseMessaging.instance.subscribeToTopic("admin");

    /// read all messages
    ///
    /// read all orders
    ///
    emit(AdminScreensDone());
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

  void writeOffers() {
    emit(OffersListLoading());
    _fireStore.collection("global").doc("offers").set({
      "offer": offersList
          .map((e) => {
                'id': e.drug.id,
                'isPercentage': e.percentage,
                'offer': e.offer,
              })
          .toList()
    }).then((value) async {
      // offers
      print(await dioHelper.postData(
          sendData: {
            "type": "offers",
          },
          body: "New Offers",
          title: "New offers posted ,click to see",
          receiverUId: "all"));
      emit(OffersListReady());
    }).catchError((err) {
      emit(OffersListReady());
      EasyLoading.showError("error happened while uploading offers");
      //  print(err);
    });
  }

  Future<List<Drug>> findInDataBase({String? subName, int? id}) async {
    return _subBase.getDrugs(subName: subName, id: id);
  }

  void notificationHandler(Map<String, dynamic> data) {
    EasyLoading.showToast("notification come");
    print(data);
  }

  void emitGeneralState() {
    emit(GeneralState());
  }
}
