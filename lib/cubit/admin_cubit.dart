import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'states.dart';

class AdminCubit extends Cubit<AppStates> {
  AdminCubit() : super(AppInitial());
  static AdminCubit get(context) => BlocProvider.of(context);

  late TabController controller;

  void startAdminProcess() {
    /// read all messages
    ///
    /// read all orders
    ///
  }
}
