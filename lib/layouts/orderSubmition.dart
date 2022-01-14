import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:pharmacyapp/cubit/cubit.dart';
import 'package:pharmacyapp/cubit/states.dart';
import '../contsants/const_colors.dart';
import '../reusable/components.dart';



class OrderSubmitionScreen extends StatefulWidget {
  const OrderSubmitionScreen({Key? key}) : super(key: key);

  @override
  _OrderSubmitionScreenState createState() => _OrderSubmitionScreenState();
}

class _OrderSubmitionScreenState extends State<OrderSubmitionScreen> {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        AppCubit cubit = AppCubit.get(context);


        TextEditingController firstName = TextEditingController(text: "Ahmed");
        TextEditingController secondName = TextEditingController(text: "Khaled");
        TextEditingController phoneNumber = TextEditingController(text: "01288534459");
        TextEditingController address = TextEditingController(text: "64 saaed elgendy st elhadara");
        GlobalKey<FormState> formKey = GlobalKey<FormState>();

        return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
                appBar: myAppBar("Confirm Data", themeColor),
                body: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 25,),
                      TextFormField(
                        //onChanged: (v){runanimation();},
                        //onTap: (){runanimation();},
                        controller: firstName,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'First Name cannot be Empty';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            labelText: 'First Name',
                            prefixIcon:
                            const Icon(Icons.person),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.blueGrey,
                                  width: 1),
                              borderRadius:
                              BorderRadius.circular(40),
                            )),
                      ),
                      const SizedBox(height: 20,),
                      TextFormField(
                        //onChanged: (v){runanimation();},
                        //onTap: (){runanimation();},
                        controller: secondName,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Last Name cannot be Empty';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            labelText: 'Last Name',
                            prefixIcon:
                            const Icon(Icons.person),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.blueGrey,
                                  width: 1),
                              borderRadius:
                              BorderRadius.circular(40),
                            )),
                      ),
                      const SizedBox(height: 20,),
                      TextFormField(
                        //onChanged: (v){runanimation();},
                        //onTap: (){runanimation();},
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
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
                              borderSide: const BorderSide(
                                  color: Colors.blueGrey, width: 1),
                              borderRadius: BorderRadius.circular(40),
                            )),
                      ),
                      const SizedBox(height: 20,),
                      TextFormField(
                        //onChanged: (v){runanimation();},
                        //onTap: (){runanimation();},
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
                            prefixIcon: const Icon(Icons.home_filled),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.blueGrey, width: 1),
                              borderRadius: BorderRadius.circular(40),
                            )),
                      ),
                      /*
                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(onPressed: (){

                          }, child: const Text("Send Location"),
                          ),
                          const SizedBox(width: 20,),
                          const Icon(Icons.location_off)
                        ],
                      ),

                       */
                      const SizedBox(height: 20,),
                      const Text("Order List"),
                      const SizedBox(height: 20,),
                      Expanded(
                        child: ListView.separated(

                            itemCount: 6,
                            separatorBuilder: (_, index) => const Divider(),
                            itemBuilder: (_, index) => Row(
                              children:  [
                                const SizedBox(width: 95,),
                                Text("${index}. Panadol 50g                5")

                              ],
                            )),
                      ),
                      ElevatedButton.icon(
                        label: const Text("Confirm"),
                        icon: const Icon(Icons.playlist_add_check),
                        style: ElevatedButton.styleFrom(
                          primary: themeColor,
                        ),
                        onPressed: () {


                        },
                      ),

                    ],
                  ),
                )));
      },
    );
  }


}
