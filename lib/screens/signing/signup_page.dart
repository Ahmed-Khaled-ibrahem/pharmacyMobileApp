import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacyapp/contsants/widgets.dart';
import 'package:pharmacyapp/cubit/operation_cubit.dart';
import 'package:pharmacyapp/cubit/signing_cubit.dart';
import 'package:pharmacyapp/cubit/states.dart';
import 'package:pharmacyapp/reusable/funcrions.dart';
import 'package:pharmacyapp/reusable/view_photo.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:pharmacyapp/contsants/themes.dart';
import '../settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class SignUpPage extends StatelessWidget {
  SignUpPage({Key? key}) : super(key: key);

  TextEditingController firstName = TextEditingController();
  TextEditingController secondName = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();

  TextEditingController passwordSignUp = TextEditingController();
  TextEditingController passwordSignUpConf = TextEditingController();
  TextEditingController mobileCodeText = TextEditingController();
  TextEditingController address = TextEditingController();
  String photo =
      "https://firebasestorage.googleapis.com/v0/b/pharmacy-app-ffac0.appspot.com/o/avatar.jpg?alt=media&token=231f9a7e-0dd8-496d-9d4f-7f068484dde4";

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool showPasswordSignUp = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SigningCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        SigningCubit cubit = SigningCubit.get(context);

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
                actions: [
                  IconButton(
                    onPressed: () {
                      navigateTo(context, SettingsScreen(true), true);
                    },
                    icon: const Icon(Icons.settings),
                  ),
                ],
                centerTitle: true,
                toolbarHeight: 60,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
                backgroundColor: themeColor,
                elevation: 0,
                title: Text(
                  AppLocalizations.of(context)!.signup,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                )),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Form(
                  key: formKey,
                  child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      child: Stack(
                        children: [
                          _confirmOtpWidget(cubit, context),
                          _inputUserWidget(cubit, context),
                        ],
                      )),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _confirmOtpWidget(SigningCubit cubit, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      transform: Matrix4(
        1,
        0,
        0,
        0,
        0,
        1,
        0,
        0,
        0,
        0,
        1,
        0,
        0,
        0,
        0,
        1,
      )
        ..rotateX(0)
        ..rotateY(0)
        ..rotateZ(3.14 * cubit.angle2),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            defaultSpaceH(20),
            Center(
              child: Lottie.asset(
                'assets/lottie/otp.zip',
                height: 250,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                AppLocalizations.of(context)!.phone_number_verification,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                textAlign: TextAlign.center,
              ),
            ),
            RichText(
              text: TextSpan(
                  text: AppLocalizations.of(context)!.enter_the_code,
                  children: [
                    TextSpan(
                        text: phoneNumber.text,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                  ],
                  style: const TextStyle(color: Colors.black54, fontSize: 15)),
              textAlign: TextAlign.center,
            ),
            defaultSpaceH(40),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: PinCodeTextField(
                  appContext: context,
                  pastedTextStyle: TextStyle(
                    color: Colors.blueGrey.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                  length: 6,
                  blinkWhenObscuring: true,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                    activeColor: themeColor,
                    inactiveFillColor: Colors.grey,
                    inactiveColor: Colors.blueGrey,
                  ),
                  cursorColor: Colors.black,
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  keyboardType: TextInputType.number,
                  boxShadows: const [
                    BoxShadow(
                      offset: Offset(0, 1),
                      color: Colors.black12,
                      blurRadius: 10,
                    )
                  ],
                  onCompleted: (v) {
                    cubit.otpCheck(
                      context: context,
                      smsOtp: v,
                      phone: phoneNumber.text,
                      firstName: firstName.text,
                      secondName: secondName.text,
                      password: passwordSignUp.text,
                      address: address.text,
                      photo: photo,
                    );
                  },
                  onChanged: (value) {},
                  beforeTextPaste: (text) {
                    return true;
                  },
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.did_not_receive,
                  style: const TextStyle(color: Colors.black54, fontSize: 15),
                ),
                TextButton(
                    onPressed: () {
                      cubit.sendValidationCode(phoneNumber.text);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.resend,
                      style: const TextStyle(
                          color: themeColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ))
              ],
            ),
            Center(
              child: ElevatedButton.icon(
                label: Text(AppLocalizations.of(context)!.back),
                icon: const Icon(Icons.arrow_back),
                style: ElevatedButton.styleFrom(
                    primary: themeColor,
                    fixedSize: const Size(250, 35.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80))),
                onPressed: () {
                  cubit.swipeBackScreen();
                  // cubit.loginButtonEvent(context);
                  //stopanimation();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputUserWidget(SigningCubit cubit, BuildContext context) {
    return AnimatedContainer(
      transform: Matrix4(
        1,
        0,
        0,
        0,
        0,
        1,
        0,
        0,
        0,
        0,
        1,
        0,
        0,
        0,
        0,
        1,
      )
        ..rotateX(0)
        ..rotateY(0)
        ..rotateZ(3.14 * cubit.angle1),
      duration: const Duration(seconds: 1),
      child: Column(
        children: [
          defaultSpaceH(10),
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 80,
            child: Stack(
              children: [
                InkWell(
                  child: ClipOval(
                    child: Image.network(
                      photo,
                      width: 150,
                      height: 150,
                      errorBuilder: (_, __, ___) {
                        return const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Icon(
                            Icons.person,
                            size: 150,
                          ),
                        );
                      },
                    ),
                  ),
                  onTap: () {
                    navigateTo(context, ViewPhoto(photo), true);
                  },
                ),
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: InkWell(
                    onTap: () async {
                      XFile? photoFile = await _takePhoto(context);
                      if (photoFile != null) {
                        AppCubit appCubit = AppCubit.get(context);
                        photo = await appCubit.uploadFile(
                            File(photoFile.path), "users");
                        cubit.emitGeneralState();
                      }
                    },
                    child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 30,
                          color: Colors.orange,
                        )),
                  ),
                ),
              ],
            ),
          ),
          defaultSpaceH(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    //onChanged: (v){runanimation();},
                    //onTap: (){runanimation();},
                    controller: firstName,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return AppLocalizations.of(context)!.error_firstname;
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.firstname,
                        prefixIcon: const Icon(Icons.person),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueGrey, width: 1),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              bottomLeft: Radius.circular(40),
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                        )),
                  ),
                ),
                defaultSpaceW(10),
                Expanded(
                  child: TextFormField(
                    //onChanged: (v){runanimation();},
                    //onTap: (){runanimation();},
                    controller: secondName,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return AppLocalizations.of(context)!.error_lastname;
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.lastname,
                        prefixIcon: const Icon(Icons.person),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueGrey, width: 1),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(40),
                              bottomRight: Radius.circular(40),
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10)),
                        )),
                  ),
                ),
              ],
            ),
          ),
          defaultSpaceH(15),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: TextFormField(
              //onChanged: (v){runanimation();},
              //onTap: (){runanimation();},
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              controller: phoneNumber,
              validator: (value) {
                if (value!.isEmpty) {
                  return AppLocalizations.of(context)!.error_user_name;
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.mobile_phone,
                  prefixIcon: const Icon(Icons.phone),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.blueGrey, width: 1),
                    borderRadius: BorderRadius.circular(40),
                  )),
            ),
          ),
          defaultSpaceH(15),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: TextFormField(
              controller: address,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.address,
                  prefixIcon: const Icon(Icons.home),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.blueGrey, width: 1),
                    borderRadius: BorderRadius.circular(40),
                  )),
            ),
          ),
          defaultSpaceH(50),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: TextFormField(
              controller: passwordSignUp,
              //onChanged: (v){runanimation();},
              //onTap: (){runanimation();},
              validator: (value) {
                if (value!.isEmpty) {
                  return AppLocalizations.of(context)!.error_password;
                } else {
                  return null;
                }
              },
              obscureText: showPasswordSignUp,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.password,
                  prefixIcon: const Icon(Icons.lock),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.blueGrey, width: 1),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      showPasswordSignUp = !showPasswordSignUp;
                      cubit.emitGeneralState();
                    },
                    icon: Icon(showPasswordSignUp
                        ? Icons.visibility
                        : Icons.visibility_off),
                  )),
            ),
          ),
          defaultSpaceH(15),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: TextFormField(
              controller: passwordSignUpConf,
              //onChanged: (v){runanimation();},
              //onTap: (){runanimation();},
              validator: (value) {
                if (value!.isEmpty) {
                  return AppLocalizations.of(context)!.error_password;
                } else {
                  return null;
                }
              },
              obscureText: showPasswordSignUp,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.confirm_pass,
                  prefixIcon: const Icon(Icons.lock),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.blueGrey, width: 1),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      showPasswordSignUp = !showPasswordSignUp;
                      cubit.emitGeneralState();
                    },
                    icon: Icon(showPasswordSignUp
                        ? Icons.visibility
                        : Icons.visibility_off),
                  )),
            ),
          ),
          defaultSpaceH(15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                label: Text(AppLocalizations.of(context)!.signup),
                icon: const Icon(Icons.account_circle_sharp),
                style: ElevatedButton.styleFrom(
                    primary: themeColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80))),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    if (passwordSignUp.text == passwordSignUpConf.text) {
                      cubit.sendValidationCode(phoneNumber.text);
                    } else {
                      EasyLoading.showToast(
                          AppLocalizations.of(context)!.same_password);
                    }
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<XFile?> _takePhoto(BuildContext context) async {
    if (await Permission.camera.request().isGranted) {
      ImageSource? source = await showGeneralDialog<ImageSource>(
        barrierLabel: "Barrier",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: const Duration(milliseconds: 700),
        context: context,
        pageBuilder: (_, __, ___) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Material(
              child: Container(
                margin: const EdgeInsets.only(bottom: 10, left: 12, right: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                ),
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(themeColor),
                      ),
                      label: Text(AppLocalizations.of(context)!.gallery),
                      onPressed: () =>
                          Navigator.pop(context, ImageSource.gallery),
                      icon: const Icon(
                        Icons.image,
                        size: 35,
                      ),
                    ),
                    defaultSpaceW(10),
                    OutlinedButton.icon(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(themeColor),
                      ),
                      label: Text(AppLocalizations.of(context)!.camera),
                      onPressed: () =>
                          Navigator.pop(context, ImageSource.camera),
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        size: 35,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        transitionBuilder: (_, anim, __, child) {
          return SlideTransition(
            position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
                .animate(anim),
            child: child,
          );
        },
      );
      if (source != null) {
        XFile? pickedFile = await ImagePicker().pickImage(source: source);
        return pickedFile;
      }
    } else {
      EasyLoading.showToast(AppLocalizations.of(context)!.error_camera);
    }
  }
}
