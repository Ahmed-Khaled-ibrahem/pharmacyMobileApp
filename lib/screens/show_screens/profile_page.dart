import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacyapp/contsants/const_colors.dart';
import 'package:pharmacyapp/cubit/operation_cubit.dart';
import 'package:pharmacyapp/cubit/states.dart';
import 'package:pharmacyapp/reusable/funcrions.dart';
import 'package:pharmacyapp/reusable/view_photo.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        AppCubit cubit = AppCubit.get(context);

        TextEditingController address = TextEditingController();
        TextEditingController oldPassword = TextEditingController();
        TextEditingController newPassword = TextEditingController();
        TextEditingController firstName = TextEditingController(text: "Ahmed");
        TextEditingController secondName = TextEditingController(text: "Khaled");
        TextEditingController phoneNumber = TextEditingController(text: "01288534459");

        GlobalKey<FormState> formKey = GlobalKey<FormState>();
        bool showPasswordSignUp = true;

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
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
                    "Profile",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
              body: Padding(
                padding: const EdgeInsets.all(15),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          InkWell(
                            child: Image.network('https://png.pngtree.com/png-vector/20191101/ourmid/pngtree-cartoon-color-simple-male-avatar-png-image_1934459.jpg',
                            width: 200,
                            ),
                            onTap: (){navigateTo(context, ViewPhoto('https://png.pngtree.com/png-vector/20191101/ourmid/pngtree-cartoon-color-simple-male-avatar-png-image_1934459.jpg'
                            ), true);},
                          ),
                          Positioned(
                            bottom: -20,
                            right: -20,
                            child: InkWell(
                              onTap: () async {
                                XFile? photo = await _takePhoto(context);
                                if (photo != null) {
                                  cubit.addOrderImage(photo);
                                }
                              },
                              child: Container(
                                width: 80,
                                  height: 80,
                                  decoration:  BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: const Icon(Icons.edit,size: 30,color: Colors.orange,)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
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
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                readOnly: true,
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
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                controller: address,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'address cannot be Empty';
                                  } else {
                                    return null;
                                  }
                                },
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
                                controller: oldPassword,
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
                                    labelText: 'Old Password',
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
                                controller: newPassword,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'new Password cannot be Empty';
                                  } else {
                                    return null;
                                  }
                                },
                                obscureText: showPasswordSignUp,
                                decoration: InputDecoration(
                                    labelText: 'New Password',
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
                                  label: const Text("Update"),
                                  icon: const Icon(Icons.account_circle_sharp),
                                  style: ElevatedButton.styleFrom(
                                      primary: themeColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(80))),
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {

                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        );
      },
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
