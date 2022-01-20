import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottie/lottie.dart';
import 'package:pharmacyapp/contsants/widgets.dart';
import 'package:pharmacyapp/cubit/signing_cubit.dart';
import 'package:pharmacyapp/cubit/states.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../contsants/const_colors.dart';

// ignore: must_be_immutable
class ForgetPassPage extends StatelessWidget {
  ForgetPassPage({Key? key}) : super(key: key);

  TextEditingController phoneNumber = TextEditingController();
  TextEditingController passwordSignUp = TextEditingController();
  TextEditingController passwordSignUpConf = TextEditingController();
  TextEditingController mobileCodeText = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool showPasswordSignUp = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SigningCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        SigningCubit cubit = SigningCubit.get(context);

        return Scaffold(
          appBar: AppBar(
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
                "Change Password",
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
                        _inputUserWidget(cubit),
                      ],
                    )),
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
                        password: passwordSignUp.text,
                        create: false);
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

  Widget _inputUserWidget(SigningCubit cubit) {
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
          Center(
            child: Lottie.asset(
              'assets/lottie/login.zip',
              height: 250,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: TextFormField(
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
                label: const Text("Change password"),
                icon: const Icon(Icons.account_circle_sharp),
                style: ElevatedButton.styleFrom(
                    primary: themeColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80))),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    if (passwordSignUp.text == passwordSignUpConf.text) {
                      cubit.sendValidationCode(phoneNumber.text, create: false);
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
}
