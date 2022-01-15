import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pharmacyapp/layouts/main_screen.dart';
import 'package:pharmacyapp/reusable/funcrions.dart';
import 'package:pharmacyapp/reusable/pref_helper.dart';
import 'states.dart';

class SigningCubit extends Cubit<AppStates> {
  SigningCubit() : super(AppInitial());
  static SigningCubit get(context) => BlocProvider.of(context);

  // TODO : FORGET PASSWORD

  int angle1 = 0;
  int angle2 = 3;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  late String _validateCode;

  Future<void> sendValidationCode(String phone) async {
    EasyLoading.show(status: 'sending code..');
    DocumentSnapshot collectionRef =
        await _fireStore.collection('users').doc(phone).get();
    if (collectionRef.exists) {
      EasyLoading.showError("Phone number already exists");
      return;
    }

    _auth.verifyPhoneNumber(
      phoneNumber: '+20$phone',
      verificationCompleted: (PhoneAuthCredential credential) async {},
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          EasyLoading.showError('The provided phone number is not valid.');
        } else if (e.code == "too-many-requests") {
          EasyLoading.showError("please wait a moment then try again");
        } else {
          EasyLoading.showError(e.code);
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        _validateCode = verificationId;
        swipeScreen();
        EasyLoading.showToast('Code sent check your message.');
      },
      timeout: const Duration(minutes: 2),
      codeAutoRetrievalTimeout: (String verificationId) {
        EasyLoading.showInfo('Code expired now.');
      },
    );
  }

  void otpCheck({
    required BuildContext context,
    required String smsOtp,
    required String phone,
    required String firstName,
    required String secondName,
    required String password,
  }) async {
    EasyLoading.show(status: 'creating user..');

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _validateCode, smsCode: smsOtp);
    await _auth.signInWithCredential(credential).then((userCred) {
      if (userCred.user == null) {
        EasyLoading.showError("wrong Code");
      } else {
        EasyLoading.dismiss();
        print("create user");
        _fireStore.collection("users").doc(phone).set({
          "name": {"first": firstName, "second": secondName},
          "pass": password,
        });

        PreferenceHelper.putDataInSharedPreference(key: "phone", value: phone);
        PreferenceHelper.putDataInSharedPreference(
            key: "userName", value: {"first": firstName, "second": secondName});

        navigateTo(context, const MainScreen(), false);
      }
    }).catchError((err) {
      print(err);
      EasyLoading.showInfo("wrong Code");
    });
  }

  Future<void> loginButtonEvent({
    required BuildContext context,
    required phone,
    required password,
  }) async {
    DocumentSnapshot collectionRef =
        await _fireStore.collection('users').doc(phone).get();
    if (!collectionRef.exists) {
      EasyLoading.showError("Wrong phone number");
      return;
    } else {
      String rightPass = collectionRef.get("pass");
      print(rightPass);
      if (password == rightPass) {
        EasyLoading.dismiss();
        PreferenceHelper.putDataInSharedPreference(key: "phone", value: phone);
        PreferenceHelper.putDataInSharedPreference(
            key: "userName", value: collectionRef.get("name"));
        navigateTo(context, const MainScreen(), false);
      } else {
        EasyLoading.showError("Wrong password");
      }
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
