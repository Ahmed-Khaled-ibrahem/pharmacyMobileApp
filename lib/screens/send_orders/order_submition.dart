import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacyapp/cubit/operation_cubit.dart';
import 'package:pharmacyapp/cubit/states.dart';
import 'package:pharmacyapp/contsants/themes.dart';
import '../../contsants/widgets.dart';
import '../../reusable/components.dart';

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
                appBar: myAppBar(text: "Confirm Data", context: context),
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
                                  validateString: 'First Name cannot be Empty',
                                  label: 'First Name',
                                  prefixIcon: Icons.person),
                              defaultSpaceH(20),
                              defaultTextField(
                                controller: phoneNumber,
                                validateString: 'Last Name cannot be Empty',
                                label: 'Last Name',
                                prefixIcon: Icons.phone,
                                keyboardType: TextInputType.number,
                              ),
                              defaultSpaceH(20),
                              defaultTextField(
                                controller: address,
                                validateString: 'address cannot be Empty',
                                label: 'Address',
                                prefixIcon: Icons.home_filled,
                              ),
                              TextButton(
                                onPressed: () async {
                                  String? fullAddress =
                                      await cubit.determinePosition();
                                  if (fullAddress != null) {
                                    address.text = fullAddress;
                                  }
                                },
                                child: const Text("use current Location"),
                              ),
                              TextField(
                                controller: descriptionText,
                                decoration: InputDecoration(
                                    labelText: "Description",
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
                              const Text(
                                "Order details",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Expanded(
                                      child: Text(
                                    "Cart images",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )),
                                  Expanded(
                                      child: Text(
                                    "${cubit.orderImages.length} image ",
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ))
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Expanded(
                                      child: Text(
                                    "Cart items",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )),
                                  Expanded(
                                      child: Text(
                                    "${cubit.cartItems.length} item ",
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ))
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Expanded(
                                      child: Text(
                                    "total items price",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )),
                                  Expanded(
                                      child: Text(
                                    "${cubit.calcOrderPrice()} pound ",
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
                          label: const Text("Confirm"),
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
