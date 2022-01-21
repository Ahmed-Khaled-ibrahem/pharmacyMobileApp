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

import '../../contsants/const_colors.dart';
import '../settings.dart';

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
                      navigateTo(context, const SettingsScreen(), true);
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
                title: const Text(
                  "Sign up",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
            defaultSpaceH,
            Center(
              child: Lottie.asset(
                'assets/lottie/otp.zip',
                height: 250,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Phone Number Verification',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                textAlign: TextAlign.center,
              ),
            ),
            RichText(
              text: TextSpan(
                  text: "Enter the code sent to ",
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
            defaultSpaceH,
            defaultSpaceH,
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
                        address: address.text);
                  },
                  onChanged: (value) {},
                  beforeTextPaste: (text) {
                    return true;
                  },
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Didn't receive the code? ",
                  style: TextStyle(color: Colors.black54, fontSize: 15),
                ),
                TextButton(
                    onPressed: () {
                      cubit.sendValidationCode(phoneNumber.text);
                    },
                    child: const Text(
                      "RESEND",
                      style: TextStyle(
                          color: themeColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ))
              ],
            ),
            Center(
              child: ElevatedButton.icon(
                label: const Text("Back"),
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
          Stack(
            children: [
              InkWell(
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 105,
                  child: ClipOval(
                    child: Image.network(
                      photo,
                      width: 200,
                      height: 200,
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
                ),
                onTap: () {
                  navigateTo(context, ViewPhoto(photo), true);
                },
              ),
              Positioned(
                bottom: -20,
                right: -20,
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
          const SizedBox(
            height: 10,
          ),
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
                        return 'First Name cannot be Empty';
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                        labelText: 'First Name',
                        prefixIcon: Icon(Icons.person),
                        enabledBorder: OutlineInputBorder(
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
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextFormField(
                    //onChanged: (v){runanimation();},
                    //onTap: (){runanimation();},
                    controller: secondName,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Last Name cannot be Empty';
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                        labelText: 'Last Name',
                        prefixIcon: Icon(Icons.person),
                        enabledBorder: OutlineInputBorder(
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
          const SizedBox(
            height: 15,
          ),
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
                  return 'Phone number cannot be Empty';
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                  labelText: 'Phone number',
                  prefixIcon: const Icon(Icons.phone),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.blueGrey, width: 1),
                    borderRadius: BorderRadius.circular(40),
                  )),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: TextFormField(
              controller: address,
              decoration: InputDecoration(
                  labelText: 'address',
                  prefixIcon: const Icon(Icons.home),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.blueGrey, width: 1),
                    borderRadius: BorderRadius.circular(40),
                  )),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: TextFormField(
              controller: passwordSignUp,
              //onChanged: (v){runanimation();},
              //onTap: (){runanimation();},
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Password cannot be Empty';
                } else {
                  return null;
                }
              },
              obscureText: showPasswordSignUp,
              decoration: InputDecoration(
                  labelText: 'Password',
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
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: TextFormField(
              controller: passwordSignUpConf,
              //onChanged: (v){runanimation();},
              //onTap: (){runanimation();},
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Password cannot be Empty';
                } else {
                  return null;
                }
              },
              obscureText: showPasswordSignUp,
              decoration: InputDecoration(
                  labelText: 'Confirm Password',
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
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                label: const Text("Sign up"),
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
                      EasyLoading.showToast("Password must be the same.");
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
                      label: const Text("Gallery"),
                      onPressed: () =>
                          Navigator.pop(context, ImageSource.gallery),
                      icon: const Icon(
                        Icons.image,
                        size: 35,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    OutlinedButton.icon(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(themeColor),
                      ),
                      label: const Text("Camera"),
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
      EasyLoading.showToast("Can't open camera");
    }
  }
}
