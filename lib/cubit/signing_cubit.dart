import 'dart:async';
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
  late String validateCode;

  void createByMobilePhone(String phone) {
    auth.verifyPhoneNumber(
      phoneNumber: '+20$phone',
      verificationCompleted: (PhoneAuthCredential credential) async {},
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        } else {
          print(e.code);
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        validateCode = verificationId;
        print("sent successfully");
      },
      timeout: const Duration(minutes: 2),
      codeAutoRetrievalTimeout: (String verificationId) {
        print("timeout");
      },
    );
  }

  Future<User?> otpCheck(String smsOtp) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: validateCode, smsCode: smsOtp);
    UserCredential userCred = await auth.signInWithCredential(credential);
    return userCred.user;
  }

  Future<void> loginWithMobile(String phone) async {
    // ConfirmationResult confirmationResult =
    // await auth.signInWithPhoneNumber('+2$phone');
    //  UserCredential userCredential = await confirmationResult.confirm('123456');
  }

  /// signing functions
  void gMailRegistration(BuildContext context) {
    EasyLoading.show(status: 'Connecting..');
    Timer(const Duration(seconds: 1), () {
      EasyLoading.dismiss();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
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
