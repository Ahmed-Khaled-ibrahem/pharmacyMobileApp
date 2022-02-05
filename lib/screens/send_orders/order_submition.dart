import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacyapp/cubit/operation_cubit.dart';
import 'package:pharmacyapp/cubit/states.dart';
import 'package:pharmacyapp/contsants/themes.dart';
import '../../contsants/widgets.dart';
import '../../reusable/components.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class OrderSubmissionScreen extends StatelessWidget {
  OrderSubmissionScreen({Key? key}) : super(key: key);

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController name =
      TextEditingController(text: AppCubit.userData.fullName());
  TextEditingController phoneNumber =
      TextEditingController(text: AppCubit.userData.phone);
  TextEditingController address =
      TextEditingController(text: AppCubit.userData.address);
  bool locationReady = false;
  TextEditingController descriptionText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        AppCubit cubit = AppCubit.get(context);
        return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
                appBar: myAppBar(text: AppLocalizations.of(context)!.confirm_form, context: context),
                body: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    physics: defaultScrollPhysics,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                          child: Column(
                            children: [
                              defaultTextField(
                                  controller: name,
                                  validateString: AppLocalizations.of(context)!.error_firstname,
                                  label: AppLocalizations.of(context)!.full_name,
                                  prefixIcon: Icons.person),
                              defaultSpaceH(20),
                              defaultTextField(
                                controller: phoneNumber,
                                validateString: AppLocalizations.of(context)!.error_user_name,
                                label: AppLocalizations.of(context)!.mobile_phone,
                                prefixIcon: Icons.phone,
                                keyboardType: TextInputType.number,
                              ),
                              defaultSpaceH(20),
                              defaultTextField(
                                controller: address,
                                validateString: AppLocalizations.of(context)!.error_address,
                                label: AppLocalizations.of(context)!.address,
                                prefixIcon: Icons.home_filled,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      cubit.getLatLang();
                                    },
                                    child: Text(AppLocalizations.of(context)!.send_my_location),
                                  ),
                                  AnimatedSwitcher(
                                    duration: const Duration(seconds: 3),
                                    reverseDuration: const Duration(milliseconds: 300),
                                    switchInCurve: Curves.elasticOut,
                                    switchOutCurve: Curves.easeIn,
                                    transitionBuilder: (Widget child, Animation<double> animation) {
                                      return ScaleTransition(
                                        scale: animation,
                                        child: child,
                                      );
                                    },
                                    child: cubit.locationIsDone? const Icon(Icons.done,key: Key('1'),)
                                        :const Icon(Icons.error,key: Key('2'),),
                                  ),
                                  defaultSpaceW(20),
                                  SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: Card(
                                      elevation: 3,
                                      color: themeColor,
                                      shape: const CircleBorder(),
                                      child: IconButton(
                                        onPressed: () async {
                                          String? fullAddress =
                                          await cubit.determinePosition();
                                          if (fullAddress != null) {
                                            address.text = fullAddress;
                                          }
                                        },
                                        icon: const Icon(Icons.location_on,),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              TextField(
                                controller: descriptionText,
                                decoration: InputDecoration(
                                    labelText: AppLocalizations.of(context)!.description,
                                    prefixIcon: const Icon(Icons.description),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.blueGrey, width: 1),
                                      borderRadius: BorderRadius.circular(20),
                                    )),
                                keyboardType: TextInputType.multiline,
                                maxLines: 3,
                              ),
                            ],
                          ),
                        ),
                        // "ItemsCount": cartItems.length,
                        //         "ImagesCount": orderImages.length,
                        //         "Items Price": calcOrderPrice(),
                        // child: OrderList(cubit),
                        Container(
                          padding: const EdgeInsets.all(15),
                          margin: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                               Text(
                                AppLocalizations.of(context)!.order_details,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              defaultSpaceH(10),
                              Row(
                                children: [
                                   Expanded(
                                      child: Text(
                                        AppLocalizations.of(context)!.prescription_images,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )),
                                  Expanded(
                                      child: Text(
                                    "${cubit.orderImages.length} "+ AppLocalizations.of(context)!.image,
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ))
                                ],
                              ),
                              defaultSpaceH(10),
                              Row(
                                children: [
                                   Expanded(
                                      child: Text(
                                        AppLocalizations.of(context)!.order_items,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )),
                                  Expanded(
                                      child: Text(
                                    "${cubit.cartItems.length}  "+AppLocalizations.of(context)!.item,
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ))
                                ],
                              ),
                              defaultSpaceH(10),
                              Row(
                                children: [
                                   Expanded(
                                      child: Text(
                                        AppLocalizations.of(context)!.total_items_price,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )),
                                  Expanded(
                                      child: Text(
                                    "${cubit.calcOrderPrice()}  "+AppLocalizations.of(context)!.le,
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ))
                                ],
                              )
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          label:  Text(AppLocalizations.of(context)!.confirm),
                          icon: const Icon(Icons.playlist_add_check),
                          style: ElevatedButton.styleFrom(
                            primary: themeColor,
                          ),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              cubit.submitOrder(
                                context: context,
                                userPhone: phoneNumber.text,
                                userAddress: address.text,
                                userName: name.text,
                                description: descriptionText.text,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                )));
      },
    );
  }
}
