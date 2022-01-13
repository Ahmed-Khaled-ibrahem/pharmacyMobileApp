import 'dart:async';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacyapp/cubit/cubit.dart';
import 'package:pharmacyapp/cubit/reusable/classes.dart';
import 'package:pharmacyapp/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacyapp/layouts/mainScreen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'SignupPage.dart';
import 'forgetpasswordpage.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);


  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin{
  late AnimationController animationController = AnimationController(
      vsync: LoginScreenState(),
      duration: const Duration(seconds: 30));
  @override
  void initState(){
    super.initState();

    animationController.repeat();

  }


  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        AppCubit cubit = AppCubit.get(context);



        return Scaffold(
            appBar: myAppBar("LOGIN",cubit.themeColor),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: AnimatedBuilder(
                    animation: animationController,
                    builder: (context,_){
                      return Opacity(
                        opacity: animationController.value,
                        child: Transform.translate(
                          offset: Offset(animationController.value*(1300),animationController.value*(1300)),
                          child: Transform.scale(
                              scale: 40,
                              child: const Icon(
                                Icons.circle ,
                                color: Colors.black12,)),
                        ),
                      );
                    },
                  ),
                ),

                GestureDetector(
                  onTap: (){FocusScope.of(context).requestFocus(FocusNode());},
                  child: SingleChildScrollView(
                    child: Form(
                      key: cubit.formKey,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20,),
                            SizedBox(
                                height: 120,
                                child: Image.asset("assets/images/loginlogo.png")),
                            const SizedBox(height: 20,),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(40,0,40,0),
                              child: TextFormField(
                                onChanged: (v){runanimation();},
                                onTap: (){runanimation();},
                                controller: cubit.username,
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
                            const SizedBox(height: 10,),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(40,0,40,0),
                              child: TextFormField(
                                controller: cubit.password,
                                onChanged: (v){runanimation();},
                                onTap: (){runanimation();},
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Password cannot be Empty';
                                  } else {
                                    return null;
                                  }
                                },
                                obscureText: cubit.showPassword,
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
                                        cubit.passwordSecuredChanged(1);
                                      },
                                      icon: Icon(cubit.showPassword
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                    )),
                              ),
                            ),
                            //const SizedBox(height: 5,),
                            Row(
                              children: [
                                const SizedBox(width: 40,),
                                TextButton(
                                    onPressed: (){
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                            type: PageTransitionType.rightToLeftWithFade,
                                            child: const ForgetPassPage(),
                                            ctx: context),
                                      );
                                    },
                                    child: const Text("Forget your Password ?")),
                              ],
                            ),
                            const SizedBox(height: 20,),
                            ElevatedButton.icon(
                              label: const Text("Login"),
                              icon: const Icon(Icons.double_arrow),
                              style: ElevatedButton.styleFrom(
                                  primary: cubit.themeColor,
                                  fixedSize: const Size(250, 35.0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(80)) ),
                              onPressed: (){
                                cubit.loginButtonEvent(context);
                                stopanimation();
                              },),
                            const SizedBox(height: 30,),
                            const Text("Or Sign in with Google Account",
                              style: TextStyle(fontWeight: FontWeight.bold),),
                            const SizedBox(height: 10,),
                            InkWell(
                              onTap: (){
                                cubit.gmailRigesteration(context);
                                stopanimation();
                                },
                              child: SizedBox(
                                  height: 40,
                                  child: Image.asset("assets/images/googleIcon.png")),
                            ),
                            const SizedBox(height: 5,),
                            const Text("Gmail",
                              style:TextStyle(fontWeight: FontWeight.bold) ,),
                            const SizedBox(height: 30,),
                            const Text("You haven't account yet"),
                            TextButton(
                                onPressed: (){
                                  Navigator.push(context,
                                      PageTransition(
                                          type: PageTransitionType.rightToLeft,
                                          child: const SignUpPage(),
                                          inheritTheme: true,
                                          ctx: context));
                                },
                                child: const Text("Sign up",
                                  style:TextStyle(fontWeight: FontWeight.bold) ,)),

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

  void runanimation(){
    animationController.value=0;
    if(animationController.isDismissed){
      animationController.forward();
    }
  }
  void stopanimation(){
    animationController.value=1;
    if(animationController.isAnimating){
      animationController.dispose();
    }
  }
}


