import 'package:flutter/material.dart';
import 'package:pharmacyapp/contsants/const_colors.dart';
import 'package:pharmacyapp/cubit/operation_cubit.dart';
import 'package:pharmacyapp/reusable/funcrions.dart';
import 'package:pharmacyapp/screens/settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget defaultTextField(
    {required TextEditingController controller,
    required String validateString,
    required String label,
    required IconData prefixIcon,
    TextInputType? keyboardType,
    int? lineCount,
    String? initialValue,
    bool? readonly}) {
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
    readOnly: readonly ?? false,
    initialValue: initialValue,
    maxLines: lineCount,
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

  String setText = AppLocalizations.of(context)!.settings;
  String logoutText = AppLocalizations.of(context)!.logout;

  return PopupMenuButton<String>(
    onSelected: (index) {
      if (index == setText) {
        navigateTo(context, const SettingsScreen(), true);
      } else if (index == logoutText) {
        cubit.logout(context);
      }
    },
    itemBuilder: (BuildContext context) {
      return {setText, logoutText}.map((String choice) {
        return PopupMenuItem<String>(
          value: choice,
          child: Row(
            children: [
              choice == setText
                  ? Icon(
                      Icons.settings,
                      color: cubit.themeState == 'Dark'
                          ? Colors.white
                          : Colors.black,
                    )
                  : Icon(
                      Icons.logout,
                      color: cubit.themeState == 'Dark'
                          ? Colors.white
                          : Colors.black,
                    ),
              const SizedBox(
                width: 10,
              ),
              Text(choice),
            ],
          ),
        );
      }).toList();
    },
  );
}

AppBar myAppBar({
  required String text,
  Color color = themeColor,
  required BuildContext context,
  Widget? actionIcon,
}) {
  return AppBar(
      actions: [
        actionIcon ?? Container(),
        optionsWidget(context),
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
    String assetPath = "assets/images/loginlogo.png",
    double? height,
    double? width,
    Widget? errorWidget}) {
  return FadeInImage.assetNetwork(
    height: height,
    width: width,
    fit: BoxFit.cover,
    placeholder: assetPath,
    imageErrorBuilder: (
      context,
      error,
      stackTrace,
    ) {
      return SizedBox(
        width: width,
        height: height,
        child: Center(
          child: errorWidget ??
              const Icon(
                Icons.downloading,
                size: 30,
              ),
        ),
      );
    },
    image: imageLink,
  );
}
