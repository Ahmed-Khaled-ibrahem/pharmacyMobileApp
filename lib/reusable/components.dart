import 'package:flutter/material.dart';

Widget defaultTextField({
  required TextEditingController controller,
  required String validateString,
  required String label,
  required IconData prefixIcon,
  TextInputType? keyboardType,
}) {
  return TextFormField(
    //onChanged: (v){runanimation();},
    //onTap: (){runanimation();},
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

class OptionsWidget extends StatelessWidget {
  const OptionsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (index) {},
      itemBuilder: (BuildContext context) {
        return {'Settings', 'Help', 'about us'}.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
    );
  }
}

AppBar myAppBar(String text, Color color) {
  return AppBar(
      actions: const [
        OptionsWidget(),
        SizedBox(
          width: 10,
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

Widget photoWithError(String imageLink, String assetPath) {
  return FadeInImage.assetNetwork(
    placeholder: assetPath,
    imageErrorBuilder: (
      context,
      error,
      stackTrace,
    ) {
      return Image.asset(assetPath);
    },
    image: imageLink,
  );
}
