import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacyapp/cubit/operation_cubit.dart';
import 'package:pharmacyapp/cubit/states.dart';
import 'package:pharmacyapp/models/drug_model.dart';
import 'package:pharmacyapp/reusable/funcrions.dart';
import 'package:pharmacyapp/screens/send_orders/archive_order.dart';
import '../../contsants/const_colors.dart';
import '../../reusable/components.dart';
import 'order_list.dart';
import 'order_submition.dart';

// ignore: must_be_immutable
class MakeAnOrderScreen extends StatelessWidget {
  MakeAnOrderScreen({Key? key}) : super(key: key);

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        AppCubit cubit = AppCubit.get(context);

        return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
                appBar: myAppBar(
                    text: "Make an Order",
                    context: context,
                    actionIcon: Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        IconButton(
                            tooltip: "Archived Orders",
                            onPressed: () {
                              navigateTo(context, ArchiveOrders(), true);
                            },
                            icon: const Icon(Icons.archive)),
                        Visibility(
                          visible: cubit.activeOrder,
                          child: const Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    )),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Row(
                        children: [
                          Expanded(
                              child: TypeAheadField<Drug>(
                            suggestionsCallback: (text) =>
                                cubit.findInDataBase(subName: text),
                            onSuggestionSelected: (suggestion) {
                              _searchController.clear();
                              cubit.addToCart(suggestion);
                            },
                            itemBuilder: (context, drug) {
                              return ListTile(
                                minLeadingWidth: 25,
                                title: Text(drug.name),
                                subtitle: Text("price : ${drug.price}"),
                                leading: SizedBox(
                                  width: 25,
                                  child: drug.picture
                                          .toString()
                                          .contains("dalilaldwaa")
                                      ? Image.network(
                                          drug.picture!,
                                          errorBuilder: (_, __, ___) {
                                            return CircleAvatar(
                                              backgroundColor: themeColor,
                                              child: Text(
                                                drug.name.toString().length < 2
                                                    ? " "
                                                    : drug.name
                                                        .toString()
                                                        .substring(0, 2),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 8),
                                              ),
                                            );
                                          },
                                        )
                                      : CircleAvatar(
                                          backgroundColor: themeColor,
                                          child: Text(
                                            drug.name.toString().length < 2
                                                ? " "
                                                : drug.name
                                                    .toString()
                                                    .substring(0, 2),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 8),
                                          ),
                                        ),
                                ),
                              );
                            },
                            textFieldConfiguration: TextFieldConfiguration(
                              decoration: InputDecoration(
                                  labelText: 'Search',
                                  prefixIcon: const Icon(Icons.search),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.cancel_outlined),
                                    onPressed: () =>
                                        _searchController.text = "",
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.blueGrey, width: 1),
                                    borderRadius: BorderRadius.circular(40),
                                  )),
                              controller: _searchController,
                            ),
                            //hasOverlay: true,
                            //marginColor: Colors.deepOrange,
                          )),
                          IconButton(
                              iconSize: 30,
                              splashRadius: 30,
                              tooltip: "Send prescription",
                              onPressed: () async {
                                XFile? photo = await _takePhoto(context);
                                if (photo != null) {
                                  cubit.addOrderImage(photo);
                                }
                              },
                              icon: const Icon(Icons.camera_alt_outlined))
                        ],
                      ),
                    ),
                    Expanded(
                      child: OrderList(cubit, state),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          "Total Price",
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          "${cubit.calcOrderPrice()} LE",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        ElevatedButton.icon(
                          label: const Text("Submit"),
                          icon: const Icon(Icons.playlist_add_check),
                          style: ElevatedButton.styleFrom(
                            primary: themeColor,
                            //  fixedSize: const Size(250, 35.0),
                            // shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(80))
                          ),
                          onPressed: () {
                            navigateTo(context, OrderSubmissionScreen(), true);
                          },
                        ),
                      ],
                    ),
                  ],
                )));
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
