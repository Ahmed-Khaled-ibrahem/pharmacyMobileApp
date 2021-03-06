import 'package:pharmacyapp/contsants/widgets.dart';
import 'package:pharmacyapp/cubit/signing_cubit.dart';
import 'package:pharmacyapp/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacyapp/reusable/funcrions.dart';
import 'package:pharmacyapp/screens/admin_screens/admin_main_screen.dart';
import 'package:pharmacyapp/contsants/themes.dart';
import '../settings.dart';
import 'signup_page.dart';
import 'forget_password_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => animationController.repeat());
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
                title: Text(
                  AppLocalizations.of(context)!.login_c,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
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
                            defaultSpaceH(20),
                            SizedBox(
                                height: 120,
                                child:
                                    Image.asset("assets/images/loginlogo.png")),
                            defaultSpaceH(20),
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
                                    return AppLocalizations.of(context)!
                                        .error_user_name;
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                    labelText: AppLocalizations.of(context)!
                                        .mobile_phone,
                                    prefixIcon: const Icon(Icons.person),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.blueGrey, width: 1),
                                      borderRadius: BorderRadius.circular(40),
                                    )),
                              ),
                            ),
                            defaultSpaceH(10),
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
                                    return AppLocalizations.of(context)!
                                        .error_password;
                                  } else {
                                    return null;
                                  }
                                },
                                obscureText: showPassword,
                                decoration: InputDecoration(
                                    labelText:
                                        AppLocalizations.of(context)!.password,
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
                                defaultSpaceW(40),
                                TextButton(
                                    onPressed: () {
                                      navigateTo(
                                          context, ForgetPassPage(), true);
                                    },
                                    child: Text(AppLocalizations.of(context)!.forget_pass,
                                    style: Theme.of(context).textTheme.button,)),
                              ],
                            ),
                            defaultSpaceH(20),
                            Row(
                              children: [
                                defaultSpaceW(50),
                                Transform.scale(
                                  scale: 1.2,
                                  child: SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: Checkbox(
                                      value: rememberMe,
                                      onChanged: (value) {
                                        setState(() {
                                          rememberMe = value!;
                                        });
                                      },
                                      fillColor:
                                          MaterialStateProperty.all(themeColor),
                                      shape: const CircleBorder(),
                                    ),
                                  ),
                                ),
                                Text(AppLocalizations.of(context)!.remember_me,
                                    style: const TextStyle(fontSize: 12))
                              ],
                            ),
                            ElevatedButton.icon(
                                label:
                                    Text(AppLocalizations.of(context)!.login_s),
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
                            defaultSpaceH(50),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {
                                    navigateTo(context, const AdminMainScreen(), false);
                                    stopAnimation();
                                  },
                                  child: const SizedBox(
                                      height: 40, child: Text("A")),
                                ),
                                InkWell(
                                  onTap: () {
                                    cubit.loginButtonEvent(
                                        context: context,
                                        phone: "01201838240",
                                        password: "12345");
                                    stopAnimation();
                                  },
                                  child: const SizedBox(
                                      height: 40, child: Text("U")),
                                ),
                              ],
                            ),
                            defaultSpaceH(5),
                            defaultSpaceH(30),
                            Text(AppLocalizations.of(context)!.havent_account,style: Theme.of(context).textTheme.headline5,),
                            TextButton(
                                onPressed: () {
                                  navigateTo(context, SignUpPage(), true);
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.signup,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
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
