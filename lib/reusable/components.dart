import 'package:flutter/material.dart';
import 'package:pharmacyapp/contsants/const_colors.dart';
import 'package:pharmacyapp/cubit/operation_cubit.dart';

Widget defaultTextField({
  required TextEditingController controller,
  required String validateString,
  required String label,
  required IconData prefixIcon,
  TextInputType? keyboardType,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    validator: (value) {
      if (value!.isEmpty) {
        return validateString;
      } else {
        return null;
      }
    },
    decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefixIcon),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blueGrey, width: 1),
          borderRadius: BorderRadius.circular(40),
        )),
  );
}

Widget optionsWidget(BuildContext context) {
  AppCubit cubit = AppCubit.get(context);

  return PopupMenuButton<String>(
    onSelected: (index) {
      switch (index) {
        case 'Settings':
          print("settings");
          break;
        case 'Help':
          print("Help");
          break;
        case 'about us':
          print("about us");
          break;
        case 'logout':
          cubit.logout(context);
          break;
      }
    },
    itemBuilder: (BuildContext context) {
      return {'Settings', 'Help', 'about us', 'logout'}.map((String choice) {
        return PopupMenuItem<String>(
          value: choice,
          child: Text(choice),
        );
      }).toList();
    },
  );
}

AppBar myAppBar(
    {required String text,
    Color color = themeColor,
    required BuildContext context}) {
  return AppBar(
      actions: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: optionsWidget(context),
        ),
      ],
      centerTitle: true,
      toolbarHeight: 60,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      backgroundColor: color,
      elevation: 0,
      title: Text(
        text,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ));
}

Widget photoWithError(
    {required String imageLink,
    String assetPath = "assets/images/loginlogo.png"}) {
  return FadeInImage.assetNetwork(
    fit: BoxFit.cover,
    placeholder: assetPath,
    imageErrorBuilder: (
      context,
      error,
      stackTrace,
    ) {
      return const Icon(
        Icons.downloading,
        size: 30,
      );
    },
    image: imageLink,
  );
}
