import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacyapp/contsants/themes.dart';
import 'package:pharmacyapp/contsants/widgets.dart';
import 'package:pharmacyapp/cubit/operation_cubit.dart';
import 'package:pharmacyapp/cubit/states.dart';
import 'package:pharmacyapp/reusable/components.dart';
import 'package:pharmacyapp/reusable/funcrions.dart';
import 'package:pharmacyapp/reusable/view_photo.dart';
import 'package:pharmacyapp/screens/signing/forget_password_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  TextEditingController address =
      TextEditingController(text: AppCubit.userData.address);
  TextEditingController firstName =
      TextEditingController(text: AppCubit.userData.firstName);
  TextEditingController secondName =
      TextEditingController(text: AppCubit.userData.lastName);
  TextEditingController phoneNumber =
      TextEditingController(text: AppCubit.userData.phone);

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        AppCubit cubit = AppCubit.get(context);

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
                  title:  Text(
                    AppLocalizations.of(context)!.profile,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
              body: Padding(
                padding: const EdgeInsets.all(15),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 105,
                        child: Stack(
                          children: [
                            InkWell(
                              child: ClipOval(
                                child: Image.network(
                                  AppCubit.userData.photo,
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
                              onTap: () {
                                navigateTo(context,
                                    ViewPhoto(AppCubit.userData.photo), true);
                              },
                            ),
                            Positioned(
                              bottom: 2,
                              right: 2,
                              child: InkWell(
                                onTap: () async {
                                  XFile? photo = await _takePhoto(context);
                                  if (photo != null) {
                                    cubit.deleteFile(AppCubit.userData.photo);
                                    AppCubit.userData.photo = await cubit
                                        .uploadFile(File(photo.path), "users");
                                    cubit.emitGeneralState();
                                  }
                                },
                                child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: const BoxDecoration(
                                      color: Colors.black87,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(40)),
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
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: firstName,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return AppLocalizations.of(context)!.error_firstname;
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration:  InputDecoration(
                                          labelText: AppLocalizations.of(context)!.firstname,
                                          prefixIcon: const Icon(Icons.person),
                                          enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.blueGrey,
                                                width: 1),
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(40),
                                                bottomLeft: Radius.circular(40),
                                                topRight: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10)),
                                          )),
                                    ),
                                  ),
                                  defaultSpaceW(10),
                                  Expanded(
                                    child: TextFormField(
                                      controller: secondName,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return AppLocalizations.of(context)!.error_lastname;
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration:  InputDecoration(
                                          labelText: AppLocalizations.of(context)!.lastname,
                                          prefixIcon: const Icon(Icons.person),
                                          enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.blueGrey,
                                                width: 1),
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(40),
                                                bottomRight:
                                                    Radius.circular(40),
                                                topLeft: Radius.circular(10),
                                                bottomLeft:
                                                    Radius.circular(10)),
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
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                readOnly: true,
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
                                      borderSide: const BorderSide(
                                          color: Colors.blueGrey, width: 1),
                                      borderRadius: BorderRadius.circular(40),
                                    )),
                              ),
                            ),
                            defaultSpaceH(15),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: defaultTextField(
                                controller: address,
                                validateString: AppLocalizations.of(context)!.error_address,
                                label: AppLocalizations.of(context)!.address,
                                prefixIcon: Icons.home_filled,
                              ),
                            ),
                            defaultSpaceH(15),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton.icon(
                                  label:  Text(AppLocalizations.of(context)!.update),
                                  icon: const Icon(Icons.account_circle_sharp),
                                  style: ElevatedButton.styleFrom(
                                      primary: themeColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(80))),
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      cubit.changeUserData(
                                          firstName: firstName.text,
                                          secondName: secondName.text,
                                          context: context,
                                          address: address.text);
                                    }
                                  },
                                ),
                              ),
                            ),
                            TextButton(
                                onPressed: () {
                                  navigateTo(context, ForgetPassPage(), true);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:  [
                                    const Icon(Icons.password_sharp),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(AppLocalizations.of(context)!.changepass),
                                  ],
                                )),
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
                    defaultSpaceW(10),
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
