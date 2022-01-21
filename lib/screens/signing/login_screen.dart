import 'package:pharmacyapp/cubit/operation_cubit.dart';
import 'package:pharmacyapp/cubit/signing_cubit.dart';
import 'package:pharmacyapp/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacyapp/models/user_model.dart';
import 'package:pharmacyapp/reusable/funcrions.dart';
import '../../contsants/const_colors.dart';
import '../show_screens/main_screen.dart';
import '../settings.dart';
import 'signup_page.dart';
import 'forget_password_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController =
      AnimationController(vsync: this, duration: const Duration(seconds: 30));
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool showPassword = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => animationController.repeat());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SigningCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        SigningCubit cubit = SigningCubit.get(context);

        return Scaffold(
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
                title: const Text(
                  "LOGIN",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
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
                                  runanimation();
                                },
                                onTap: () {
                                  runanimation();
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
                                    labelText: 'Mobile phone',
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
                                  runanimation();
                                },
                                onTap: () {
                                  runanimation();
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
                                      navigateTo(
                                          context, ForgetPassPage(), true);
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
                                        phone: username.text,
                                        password: password.text);
                                    stopAnimation();
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
                                navigateTo(context, MainScreen(null), false);
                                AppCubit.userData = AppUser(
                                    "dev account",
                                    "dev",
                                    "acc",
                                    "https://firebasestorage.googleapis.com/v0/b/pharmacy-app-ffac0.appspot.com/o/avatar.jpg?alt=media&token=231f9a7e-0dd8-496d-9d4f-7f068484dde4",
                                    null);
                                stopAnimation();
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
                                  navigateTo(context, SignUpPage(), true);
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

  void stopAnimation() {
    animationController.value = 1;
    if (animationController.isAnimating) {
      animationController.dispose();
    }
  }
}
