import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pharmacyapp/contsants/values.dart';
import 'package:pharmacyapp/cubit/operation_cubit.dart';
import 'package:pharmacyapp/models/user_model.dart';
import 'package:pharmacyapp/reusable/funcrions.dart';
import '../screens/show_screens/main_screen.dart';
import 'package:pharmacyapp/screens/signing/login_screen.dart';
import '../shared/pref_helper.dart';
import 'states.dart';

class SigningCubit extends Cubit<AppStates> {
  SigningCubit() : super(AppInitial());
  static SigningCubit get(context) => BlocProvider.of(context);

  int angle1 = 0;
  int angle2 = 3;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  late String _validateCode;

  Future<void> sendValidationCode(String phone, {bool create = true}) async {
    EasyLoading.show(status: 'sending code..');
    DocumentSnapshot collectionRef =
        await _fireStore.collection('users').doc(phone).get();
    if (collectionRef.exists && create) {
      EasyLoading.showError("Phone number already exists");
      return;
    } else if (!collectionRef.exists && !create) {
      EasyLoading.showError("Phone number doesn't exists");
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
        // EasyLoading.showInfo('Code expired now.');
      },
    );
  }

  void otpCheck(
      {required BuildContext context,
      required String smsOtp,
      required String phone,
      String? firstName,
      String? secondName,
      String? address,
      String photo = defaultUserImage,
      required String password,
      bool create = true}) async {
    EasyLoading.show(status: 'creating user..');

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _validateCode, smsCode: smsOtp);
    await _auth.signInWithCredential(credential).then((userCred) async {
      if (userCred.user == null) {
        EasyLoading.showError("wrong Code");
      } else {
        EasyLoading.dismiss();
        if (create) {
          _fireStore.collection("users").doc(phone).set({
            "name": {"first": firstName, "second": secondName},
            "pass": password,
            "photo": photo,
            "address": address
          }).then((value) {
            FirebaseMessaging.instance.subscribeToTopic(phone);
            PreferenceHelper.putDataInSharedPreference(
                key: "phone", value: phone);
            PreferenceHelper.putDataInSharedPreference(
                key: "photo", value: photo);
            PreferenceHelper.putDataInSharedPreference(
                key: "address", value: address);
            PreferenceHelper.putDataInSharedPreference(
                key: "userName",
                value: {"first": firstName, "second": secondName});
            AppCubit.userData =
                AppUser(phone, firstName!, secondName!, photo, address);
            swipeBackScreen();
            navigateTo(context, MainScreen(context), false);
          }).catchError((err) {
            EasyLoading.showToast("An error happened");
          });
        } else {
          _fireStore.collection("users").doc(phone).update({
            "pass": password,
          }).then((value) {
            swipeBackScreen();
            EasyLoading.showToast("password changed successfully");
            navigateTo(context, const LoginScreen(), false);
          }).catchError((err) {
            EasyLoading.showToast("An error happened");
          });
        }
      }
    }).catchError((err) {
      EasyLoading.showInfo("wrong Code");
    });
  }

  Future<void> loginButtonEvent({
    required BuildContext context,
    required phone,
    required password,
  }) async {
    EasyLoading.show(status: 'Please wait...');

    DocumentSnapshot collectionRef =
        await _fireStore.collection('users').doc(phone).get();
    if (!collectionRef.exists) {
      EasyLoading.showError("Wrong phone number");
      return;
    } else {
      String rightPass = collectionRef.get("pass");
      if (password == rightPass) {
        EasyLoading.dismiss();
        FirebaseMessaging.instance.subscribeToTopic(phone);
        PreferenceHelper.putDataInSharedPreference(key: "phone", value: phone);
        PreferenceHelper.putDataInSharedPreference(
            key: "userName", value: collectionRef.get("name"));
        EasyLoading.dismiss();
        Map<String, dynamic> name = collectionRef.get("name");
        String? address = collectionRef.get("address");
        String photo = collectionRef.get("photo");
        PreferenceHelper.putDataInSharedPreference(key: "photo", value: photo);
        PreferenceHelper.putDataInSharedPreference(
            key: "address", value: address);

        AppCubit.userData =
            AppUser(phone, name['first']!, name['second']!, photo, address);
        navigateTo(context, MainScreen(context), false);
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

  void emitGeneralState() {
    emit(GeneralState());
  }
}
