import 'package:image_picker/image_picker.dart';
import 'package:pharmacyapp/cubit/operation_cubit.dart';
import 'package:pharmacyapp/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../contsants/const_colors.dart';
import '../../reusable/components.dart';

/// TODO : THIS WILL BE REPLACED IN THE SEND ORDER

// ignore: must_be_immutable
class SendPrescriptionScreen extends StatelessWidget {
  SendPrescriptionScreen({Key? key}) : super(key: key);
  TextEditingController descriptionText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        AppCubit cubit = AppCubit.get(context);

        return Scaffold(
            floatingActionButton: FloatingActionButton(
              child: const Text("test"),
              onPressed: () async {
                // DioHelper dioHelper = DioHelper();
                // print(await dioHelper.postData(
                //     sendData: {"Test": "data"},
                //     title: "Test From app",
                //     body: "Click here",
                //     receiverUId: "01201838240"));

                XFile? file = await cubit.takePhoto(context);
                if (file != null) {
                  print(await cubit.uploadPhoto(file));
                }
              },
            ),
            appBar: myAppBar(text: "Send Prescription", context: context),
            body: InkWell(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Card(
                      color: Colors.amber,
                      child: SizedBox(
                        width: 350,
                        height: 200,
                        child: Stack(
                          children: [
                            Positioned(
                                top: 25,
                                right: 15,
                                child: Transform.rotate(
                                    angle: 0.5,
                                    child: const Icon(
                                      Icons.photo_camera_rounded,
                                      size: 120,
                                      color: Colors.black26,
                                    ))),
                            const Positioned(
                                right: 10,
                                bottom: 10,
                                child: Icon(
                                  Icons.qr_code_scanner,
                                  size: 50,
                                  color: Colors.black26,
                                )),
                            Positioned(
                              bottom: 15,
                              left: 10,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(themeColor),
                                ),
                                onPressed: () {},
                                child: SizedBox(
                                  width: 200,
                                  child: Row(
                                    children: const [
                                      Icon(Icons.camera),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text("Scan by Camera"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 60,
                              left: 10,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(themeColor),
                                ),
                                onPressed: () {},
                                child: SizedBox(
                                  width: 200,
                                  child: Row(
                                    children: const [
                                      Icon(Icons.photo),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text("Pick from Gallery"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const Positioned(
                              top: 15,
                              left: 10,
                              child: Text(
                                "Take a picture then\n get the order",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 30),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Send a description with image",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: descriptionText,
                        decoration: InputDecoration(
                            labelText: "Description",
                            prefixIcon: const Icon(Icons.description),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.blueGrey, width: 3),
                              borderRadius: BorderRadius.circular(20),
                            )),
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(themeColor),
                      ),
                      onPressed: () {},
                      child: SizedBox(
                        width: 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text("Send"),
                            SizedBox(
                              width: 20,
                            ),
                            Icon(Icons.send_sharp),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }
}
