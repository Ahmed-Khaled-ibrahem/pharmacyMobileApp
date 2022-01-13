import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacyapp/cubit/cubit.dart';
import 'package:pharmacyapp/cubit/reusable/classes.dart';
import 'package:pharmacyapp/cubit/states.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}


class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return
      BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {},
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);

          return Scaffold(
              appBar: myAppBar("Sign up",cubit.themeColor),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                key: cubit.formKeySignup,
                child: InkWell(
                  onTap: (){FocusScope.of(context).requestFocus(FocusNode());},
                  child:   Stack(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        transform: Matrix4(
                          1,0,0,0,
                          0,1,0,0,
                          0,0,1,0,
                          0,0,0,1,
                        )..rotateX(0)..rotateY(0)..rotateZ(3.14*cubit.angle2),
                        child: Column(
                          children: [
                            const SizedBox(height: 30,),
                            const SizedBox(width:320,
                                child: Text("We Send code to your mobile",textAlign: TextAlign.start,)),
                            const SizedBox(height: 10,),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10,0,10,0),
                              child: TextFormField(
                                //autovalidateMode: AutovalidateMode.always,
                                controller: cubit.mobileCodeText,
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
                                obscureText: cubit.showPasswordSignupConf,
                                decoration: InputDecoration(
                                    labelText: 'Code',
                                    prefixIcon: const Icon(Icons.security_rounded),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.blueGrey, width: 1),
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    ),
                              ),
                            ),
                            const SizedBox(height: 15,),
                            ElevatedButton.icon(
                              label: const Text("Confirm"),
                              icon: const Icon(Icons.done),
                              style: ElevatedButton.styleFrom(
                                  primary: cubit.themeColor,
                                  fixedSize: const Size(250, 35.0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(80)) ),
                              onPressed: (){
                                cubit.increamentCounter();
                                // cubit.loginButtonEvent(context);
                                //stopanimation();
                              },),
                            const SizedBox(height: 15,),
                            ElevatedButton.icon(
                              label: const Text("Back"),
                              icon: const Icon(Icons.arrow_back),
                              style: ElevatedButton.styleFrom(
                                  primary: cubit.themeColor,
                                  fixedSize: const Size(250, 35.0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(80)) ),
                              onPressed: (){
                                cubit.swipBackScreen();
                                // cubit.loginButtonEvent(context);
                                //stopanimation();
                              },),
                          ],
                        ),
                      ) ,
                      AnimatedContainer(
                        transform: Matrix4(
                          1,0,0,0,
                          0,1,0,0,
                          0,0,1,0,
                          0,0,0,1,
                        )..rotateX(0)..rotateY(0)..rotateZ(3.14*cubit.angle1),
                        duration: const Duration(seconds: 1),
                        child: Column(
                          children: [
                            const SizedBox(height: 30,),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 180,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(10,0,10,0),
                                      child: TextFormField(

                                        //onChanged: (v){runanimation();},
                                        //onTap: (){runanimation();},
                                        controller: cubit.firstName,
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
                                      padding: const EdgeInsets.fromLTRB(10,0,10,0),
                                      child: TextFormField(

                                        //onChanged: (v){runanimation();},
                                        //onTap: (){runanimation();},
                                        controller: cubit.secondName,
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
                            const SizedBox(height: 15,),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10,0,10,0),
                              child: TextFormField(
                                //onChanged: (v){runanimation();},
                                //onTap: (){runanimation();},
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                controller: cubit.phoneNumber,
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
                                      borderSide: const BorderSide(
                                          color: Colors.blueGrey, width: 1),
                                      borderRadius: BorderRadius.circular(40),
                                    )),
                              ),
                            ),
                            const SizedBox(height: 15,),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10,0,10,0),
                              child: TextFormField(
                                //autovalidateMode: AutovalidateMode.always,
                                controller: cubit.passwordSignup,
                                //onChanged: (v){runanimation();},
                                //onTap: (){runanimation();},
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Password cannot be Empty';
                                  } else {
                                    return null;
                                  }
                                },
                                obscureText: cubit.showPasswordSignup,
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
                                        cubit.passwordSecuredChanged(2);
                                      },
                                      icon: Icon(cubit.showPasswordSignup
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                    )),
                              ),
                            ),
                            const SizedBox(height: 15,),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10,0,10,0),
                              child: TextFormField(
                                //autovalidateMode: AutovalidateMode.always,
                                controller: cubit.passwordSignupConf,
                                //onChanged: (v){runanimation();},
                                //onTap: (){runanimation();},
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Password cannot be Empty';
                                  } else {
                                    return null;
                                  }
                                },
                                obscureText: cubit.showPasswordSignupConf,
                                decoration: InputDecoration(
                                    labelText: 'Confirm Password',
                                    prefixIcon: const Icon(Icons.lock),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.blueGrey, width: 1),
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        cubit.passwordSecuredChanged(3);
                                      },
                                      icon: Icon(cubit.showPasswordSignupConf
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                    )),
                              ),
                            ),
                            const SizedBox(height: 15,),
                            ElevatedButton.icon(
                              label: const Text("Sign up"),
                              icon: const Icon(Icons.account_circle_sharp),
                              style: ElevatedButton.styleFrom(
                                  primary: cubit.themeColor,
                                  fixedSize: const Size(250, 35.0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(80)) ),
                              onPressed: (){
                                cubit.swipScreen();
                                //cubit.loginButtonEvent(context);
                                //stopanimation();
                              },),
                          ],
                        ),
                      ),
                    ],
                  )



                ),
              ),
            ),
            );
        },
      );

  }
}
