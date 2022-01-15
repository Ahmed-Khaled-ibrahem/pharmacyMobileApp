import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacyapp/cubit/operation_cubit.dart';
import 'package:pharmacyapp/cubit/states.dart';
import '../contsants/const_colors.dart';
import '../contsants/widgets.dart';
import '../reusable/components.dart';

// ignore: must_be_immutable
class OrderSubmissionScreen extends StatelessWidget {
  OrderSubmissionScreen({Key? key}) : super(key: key);

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController firstName = TextEditingController(text: "Ahmed");
  TextEditingController secondName = TextEditingController(text: "Khaled");
  TextEditingController phoneNumber =
      TextEditingController(text: "01288534459");
  TextEditingController address =
      TextEditingController(text: "64 saaed elgendy st elhadara");
  bool locationReady = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        AppCubit cubit = AppCubit.get(context);
        double height = MediaQuery.of(context).size.height;
        print(height);
        return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
                floatingActionButton: FloatingActionButton(
                  backgroundColor: themeColor,
                  child: locationReady
                      ? const Icon(
                          Icons.location_on_sharp,
                          color: Colors.green,
                        )
                      : const Icon(
                          Icons.location_off,
                          color: Colors.orangeAccent,
                        ),
                  onPressed: () => cubit.determinePosition(),
                ),
                appBar: myAppBar("Confirm Data", themeColor),
                body: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
                    child: SingleChildScrollView(
                      physics: defaultScrollPhysics,
                      child: Column(
                        children: [
                          defaultTextField(
                              controller: firstName,
                              validateString: 'First Name cannot be Empty',
                              label: 'First Name',
                              prefixIcon: Icons.person),
                          defaultSpaceH,
                          defaultTextField(
                              controller: secondName,
                              validateString: 'Last Name cannot be Empty',
                              label: 'Last Name',
                              prefixIcon: Icons.person),
                          defaultSpaceH,
                          defaultTextField(
                            controller: phoneNumber,
                            validateString: 'Last Name cannot be Empty',
                            label: 'Last Name',
                            prefixIcon: Icons.phone,
                            keyboardType: TextInputType.number,
                          ),
                          defaultSpaceH,
                          defaultTextField(
                            controller: phoneNumber,
                            validateString: 'address cannot be Empty',
                            label: 'Address',
                            prefixIcon: Icons.home_filled,
                          ),
                          // const SizedBox(height: 20,),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     ElevatedButton(onPressed: (){
                          //
                          //     }, child: const Text("Send Location"),
                          //     ),
                          //     const SizedBox(width: 20,),
                          //     const Icon(Icons.location_off)
                          //   ],
                          // ),
                          defaultSpaceH,
                          const Text("Order List"),
                          defaultSpaceH,
                          SizedBox(
                            height: 6 * 30, // itemCount * itemLength
                            child: ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 6,
                                separatorBuilder: (_, index) => const Divider(),
                                itemBuilder: (_, index) => SizedBox(
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("$index. Panadol 50g"),
                                          defaultSpaceW,
                                          const Text("5"),
                                        ],
                                      ),
                                    )),
                          ),
                          ElevatedButton.icon(
                            label: const Text("Confirm"),
                            icon: const Icon(Icons.playlist_add_check),
                            style: ElevatedButton.styleFrom(
                              primary: themeColor,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                )));
      },
    );
  }
}
