import 'dart:async';

import 'package:page_transition/page_transition.dart';
import 'package:pharmacyapp/cubit/cubit.dart';
import 'package:pharmacyapp/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../contsants/const_colors.dart';
import '../reusable/components.dart';
import 'signup_page.dart';
import 'forget_password_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController = AnimationController(
      vsync: this, duration: const Duration(seconds: 30));
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool showPassword = true;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1),(){
      animationController.repeat();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        AppCubit cubit = AppCubit.get(context);

        return Scaffold(
            appBar: myAppBar("LOGIN", themeColor),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: AnimatedBuilder(
                    animation: animationController,
                    builder: (context, _) {
                      return Opacity(
                        opacity: animationController.value,
                        child: Transform.translate(
                          offset: Offset(animationController.value * (1300),
                              animationController.value * (1300)),
                          child: Transform.scale(
                              scale: 40,
                              child: const Icon(
                                Icons.circle,
                                color: Colors.black12,
                              )),
                        ),
                      );
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                                height: 120,
                                child:
                                    Image.asset("assets/images/loginlogo.png")),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                              child: TextFormField(
                                onChanged: (v) {
                                  //runanimation();
                                },
                                onTap: () {
                                  //runanimation();
                                },
                                controller: username,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'User Name cannot be Empty';
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                    labelText: 'User Name or Mobile phone',
                                    prefixIcon: const Icon(Icons.person),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.blueGrey, width: 1),
                                      borderRadius: BorderRadius.circular(40),
                                    )),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                              child: TextFormField(
                                controller: password,
                                onChanged: (v) {
                                  //runanimation();
                                },
                                onTap: () {
                                  //runanimation();
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Password cannot be Empty';
                                  } else {
                                    return null;
                                  }
                                },
                                obscureText: showPassword,
                                decoration: InputDecoration(
                                    labelText: 'Password',
                                    prefixIcon: const Icon(Icons.lock),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.blueGrey, width: 1),
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        showPassword = !showPassword;
                                        cubit.emitGeneralState();
                                      },
                                      icon: Icon(showPassword
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                    )),
                              ),
                            ),
                            //const SizedBox(height: 5,),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 40,
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                            type: PageTransitionType
                                                .rightToLeftWithFade,
                                            child: const ForgetPassPage(),
                                            ctx: context),
                                      );
                                    },
                                    child:
                                        const Text("Forget your Password ?")),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton.icon(
                                label: const Text("Login"),
                                icon: const Icon(Icons.double_arrow),
                                style: ElevatedButton.styleFrom(
                                    primary: themeColor,
                                    fixedSize: const Size(250, 35.0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(80))),
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    cubit.loginButtonEvent(
                                        context: context,
                                        userName: username.text,
                                        password: password.text);
                                    //stopanimation();
                                  }
                                }),
                            const SizedBox(
                              height: 30,
                            ),
                            const Text(
                              "Or Sign in with Google Account",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                cubit.gMailRegistration(context);
                                //stopanimation();
                              },
                              child: SizedBox(
                                  height: 40,
                                  child: Image.asset(
                                      "assets/images/googleIcon.png")),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              "Gmail",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            const Text("You haven't account yet"),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.rightToLeft,
                                          child: const SignUpPage(),
                                          inheritTheme: true,
                                          ctx: context));
                                },
                                child: const Text(
                                  "Sign up",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }

  void runanimation() {
    animationController.value = 0;
    if (animationController.isDismissed) {
      animationController.forward();
    }
  }

  void stopanimation() {
    animationController.value = 1;
    if (animationController.isAnimating) {
      animationController.dispose();
    }
  }
}
