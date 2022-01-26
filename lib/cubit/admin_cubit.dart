import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pharmacyapp/models/drug_model.dart';
import 'package:pharmacyapp/shared/pref_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'states.dart';

class AdminCubit extends Cubit<AppStates> {
  AdminCubit() : super(AppInitial());
  static AdminCubit get(context) => BlocProvider.of(context);

  late TabController controller;


  late Database _dataBase;
  List<OrderItem> cartItems = [];
  List<String> orderImages = [];

  void startAdminProcess() {
    /// read all messages
    ///
    /// read all orders
    ///
  }

  Future<List<Drug>> findInDataBase({String? subName, int? id}) async {
    List<Map<String, dynamic>> queryData;
    if (subName != null) {
      queryData =
      await _dataBase.query("data", where: "name LIKE  \"%$subName%\"");
    } else {
      queryData = await _dataBase.query("data", where: "id =  $id");
    }
    return queryData.map((e) => Drug(drugData: e)).toList();
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


}
