import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacyapp/layouts/main_screen.dart';
import 'states.dart';

class SigningCubit extends Cubit<AppStates> {
  SigningCubit() : super(AppInitial());
  static SigningCubit get(context) => BlocProvider.of(context);

  int angle1 = 0;
  int angle2 = 3;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  late String validateCode;

  Future<void> sendValidationCode(String phone) async {
    EasyLoading.show(status: 'sending code..');
    DocumentSnapshot collectionRef =
        await fireStore.collection('users').doc(phone).get();
    if (collectionRef.exists) {
      EasyLoading.showError("Phone number already exists");
      return;
    }

    auth.verifyPhoneNumber(
      phoneNumber: '+20$phone',
      verificationCompleted: (PhoneAuthCredential credential) async {},
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          EasyLoading.showToast('The provided phone number is not valid.');
        } else {
          print(e.code);
          EasyLoading.showToast(e.code);
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        validateCode = verificationId;
        swipeScreen();
        EasyLoading.showToast('Code sent check your message.');
      },
      timeout: const Duration(minutes: 2),
      codeAutoRetrievalTimeout: (String verificationId) {
        EasyLoading.showToast('Code expired now.');
      },
    );
  }

  void otpCheck(String smsOtp) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: validateCode, smsCode: smsOtp);
    UserCredential userCred = await auth.signInWithCredential(credential);
    if (userCred.user == null) {
      EasyLoading.showError("wrong Code");
    } else {
      print("create user");
    }
  }

  /// signing functions
  void userDummyLogin(BuildContext context) {
    EasyLoading.show(status: 'Connecting..');
    Timer(const Duration(seconds: 1), () {
      EasyLoading.dismiss();

      /*
      Navigator.pushReplacement(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeft,
            child: const MainScreen(),
            ctx: context),
      );

       */
    });
    emit(GeneralState());
  }

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
    if (((userName == "ahmed") & (password == "666666")) ||
        (userName == "admin")) {
      EasyLoading.show(status: 'Connecting..');
      Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();

        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: const MainScreen(),
            // inheritTheme: true,
          ),
        );
      });
      emit(LogInDoneState());
    } else {
      EasyLoading.showToast('Wrong Password user:ahmed pass:666666');
      emit(LogInErrorState());
    }
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
