import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacyapp/contsants/themes.dart';
import 'package:pharmacyapp/contsants/widgets.dart';
import 'package:pharmacyapp/cubit/admin_cubit.dart';
import 'package:pharmacyapp/cubit/states.dart';
import 'package:pharmacyapp/reusable/components.dart';
import 'package:pharmacyapp/reusable/funcrions.dart';
import 'package:pharmacyapp/reusable/view_photo.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DrugsInfoEditScreen extends StatelessWidget {
  final int drugId;

  const DrugsInfoEditScreen(this.drugId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return BlocProvider(
      create: (BuildContext context) => AdminCubit(),
      child: BlocConsumer<AdminCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {},
        builder: (BuildContext context, AppStates state) {
          AdminCubit cubit = AdminCubit.get(context);

          TextEditingController drugName = TextEditingController(text: 'Panadol Night 30 Taps');
          TextEditingController drugPrice = TextEditingController(text: '30');

          return Scaffold(
              appBar: myAppBar(text: AppLocalizations.of(context)!.edit_info, context: context),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            InkWell(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: InteractiveViewer(
                                  child: Hero(
                                    tag: 'image',
                                    child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                        const Icon(Icons.image_not_supported_rounded,size: 80,),
                                        imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRJohJOH9MzlKeMhnxD4urqQxz5AXb_qgE-Xg&usqp=CAU'),
                                  ),
                                )
                              ),
                              onTap: () {
                                navigateTo(context, ViewPhoto('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRJohJOH9MzlKeMhnxD4urqQxz5AXb_qgE-Xg&usqp=CAU'), true);
                              },
                            ),
                            Positioned(
                              bottom: 10,
                              right: 10,
                              child: InkWell(
                                onTap: () async {
                                  XFile? photo = await _takePhoto(context);
                                  if (photo != null) {
                                    //cubit.userData.photo = await cubit.uploadFile(File(photo.path), "users");
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
                        defaultSpaceH(10),
                        Row(
                          children: [
                            defaultSpaceW(10),
                            Text(AppLocalizations.of(context)!.drug_name +' :',
                              style: const TextStyle(fontSize: 18,color: Colors.orange,fontWeight: FontWeight.w800),),
                            defaultSpaceW(10),
                            Text(drugId.toString(),style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                          ],
                        ),
                        defaultSpaceH(20),
                        defaultTextField(
                            label: AppLocalizations.of(context)!.drug_name,
                            controller: drugName,
                            prefixIcon: Icons.drive_file_rename_outline_outlined,
                            validateString: AppLocalizations.of(context)!.error_drug,
                            keyboardType: TextInputType.text,
                            lineCount: 1),
                        defaultSpaceH(10),
                        defaultTextField(
                            label: AppLocalizations.of(context)!.drug_price,
                            controller: drugPrice,
                            prefixIcon: Icons.price_change,
                            validateString: AppLocalizations.of(context)!.error_drug_price,
                            keyboardType: TextInputType.number,
                            lineCount: 1),
                        defaultSpaceH(10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                              icon: const Icon(Icons.cloud_upload_rounded),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(themeColor),
                              ),
                              onPressed: () {
                                if(formKey.currentState!.validate()){
                                  
                                  EasyLoading.show();
                                  // upload data to database
                                  //
                                  //
                                  //
                                  //
                                  //
                                  //

                                  Timer(const Duration(seconds: 3),(){
                                    EasyLoading.dismiss();
                                    EasyLoading.showSuccess(AppLocalizations.of(context)!.done_edit);
                                  });


                                }

                              },
                              label:  Text(AppLocalizations.of(context)!.save)),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
        },
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
                      label:  Text(AppLocalizations.of(context)!.gallery),
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
                      label: Text(AppLocalizations.of(context)!.camera),
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
      EasyLoading.showToast(AppLocalizations.of(context)!.error_camera);
    }
  }
}
