import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacyapp/cubit/signing_cubit.dart';
import 'package:pharmacyapp/cubit/states.dart';

import '../../contsants/const_colors.dart';
import '../../reusable/components.dart';

// ignore: must_be_immutable
class SignUpPage extends StatelessWidget {
  SignUpPage({Key? key}) : super(key: key);

  TextEditingController username = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController secondName = TextEditingController();
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
          appBar: myAppBar("Sign up", themeColor),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: formKey,
              child: InkWell(
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
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          const SizedBox(
              width: 320,
              child: Text(
                "We Send code to your mobile",
                textAlign: TextAlign.start,
              )),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: TextFormField(
              //autovalidateMode: AutovalidateMode.always,
              controller: mobileCodeText,
              //onChanged: (v){runanimation();},
              //onTap: (){runanimation();},
              validator: (value) {
                if (value!.isEmpty) {
                  return 'code be Empty';
                } else {
                  return null;
                }
              },
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              obscureText: showPasswordSignUp,
              decoration: InputDecoration(
                labelText: 'Code',
                prefixIcon: const Icon(Icons.security_rounded),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.blueGrey, width: 1),
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          ElevatedButton.icon(
            label: const Text("Confirm"),
            icon: const Icon(Icons.done),
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
          const SizedBox(
            height: 15,
          ),
          ElevatedButton.icon(
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
        ],
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
          const SizedBox(
            height: 30,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(
                  width: 180,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                      decoration: InputDecoration(
                          labelText: 'First Name',
                          prefixIcon: const Icon(Icons.person),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.blueGrey, width: 1),
                            borderRadius: BorderRadius.circular(40),
                          )),
                    ),
                  ),
                ),
                SizedBox(
                  width: 180,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                      decoration: InputDecoration(
                          labelText: 'Last Name',
                          prefixIcon: const Icon(Icons.person),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.blueGrey, width: 1),
                            borderRadius: BorderRadius.circular(40),
                          )),
                    ),
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
          ElevatedButton.icon(
            label: const Text("Sign up"),
            icon: const Icon(Icons.account_circle_sharp),
            style: ElevatedButton.styleFrom(
                primary: themeColor,
                fixedSize: const Size(250, 35.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80))),
            onPressed: () {
              cubit.swipeScreen();
              // if (formKey.currentState!.validate()) {
              //   if (passwordSignUp.text ==
              //       passwordSignUpConf.text) {
              //     cubit.sendValidationCode(phoneNumber.text);
              //   } else {
              //     EasyLoading.showToast(
              //         "Password must be the same.");
              //   }
              // }
            },
          ),
        ],
      ),
    );
  }
}
