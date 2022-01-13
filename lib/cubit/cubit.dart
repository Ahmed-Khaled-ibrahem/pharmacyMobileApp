import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacyapp/layouts/LoginScreen.dart';
import 'package:pharmacyapp/layouts/mainScreen.dart';
import 'states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitial());
  static AppCubit get(context) => BlocProvider.of(context);

  Color themeColor = const Color(0xFF004282);//0A6889


  TextEditingController username = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController secondName = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();

  TextEditingController password = TextEditingController();
  TextEditingController passwordSignup = TextEditingController();
  TextEditingController passwordSignupConf = TextEditingController();
  TextEditingController mobileCodeText = TextEditingController();

  bool showPassword = true;
  bool showPasswordSignup = true;
  bool showPasswordSignupConf = true;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> formKeySignup = GlobalKey<FormState>();

  int Counter = 0;
  bool mobileCode = true;
  int angle1 = 0;
  int angle2 = 3;



  void loginButtonEvent(context){
    formKey.currentState?.validate();
/*

 check user here
 using username.text
 and password.text

*/
    bool loginSuccsesful = false;

    if((username.text == "ahmed")&(password.text == "666666"))
    {loginSuccsesful = true;}

    if(loginSuccsesful){

      EasyLoading.show(status: 'Connecting..');
      Timer(
          const Duration(seconds: 1),(){
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
    }
    else{
      EasyLoading.showToast('Wrong Password user:ahmed pass:666666');
    }
    emit(General());
  }


  void passwordSecuredChanged(int i) {
    switch (i){
      case 1:
        showPassword = !showPassword;
        break;
      case 2:
        showPasswordSignup = !showPasswordSignup;
        break;
      case 3:
        showPasswordSignupConf = !showPasswordSignupConf;
        break;
    }

    emit(General());
  }

  void gmailRigesteration(context) {

    EasyLoading.show(status: 'Connecting..');
    Timer(
        const Duration(seconds: 1),(){
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
    emit(General());
  }


  void swipScreen() {
  angle1 = 3;
  angle2 = 0;
    emit(General());
  }
  void swipBackScreen() {
  angle1 = 0;
  angle2 = 3;
    emit(General());
  }

  void increamentCounter() {
    //angle+=40;
    emit(General());
  }

}
