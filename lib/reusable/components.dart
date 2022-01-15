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
        return {'Settings', 'Help', 'about us','logout'}.map((String choice) {
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
    fit: BoxFit.cover,
    placeholder: "assets/images/loginlogo.png",
    imageErrorBuilder: (
      context,
      error,
      stackTrace,
    ) {
      return const Icon(Icons.downloading,size: 30,);
    },
    image: imageLink,
  );
}

Widget offerCard(){
  return Card(
    elevation: 15,
    shadowColor: Colors.black,
    color: Colors.indigo,
    child: SizedBox(
      width: 300,
      height: 200,
      child: Stack(
        children: [
          Positioned(
            right: -20,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(100),
                topLeft: Radius.circular(100),
              ),
              child: Stack(
                children: [
                  SizedBox(
                      width: 200,
                      child: Image.network(
                          "https://m.media-amazon.com/images/I/71+Zza6xeNL._SY355_.jpg")),
                  Positioned(
                    top: -20,
                    child: SizedBox(
                        child: Image.network(
                          "https://freepngimg.com/thumb/categories/1219.png",
                        )),
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
              top: 10,
              left: 10,
              child: Text(
                "Today's Offer",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              )),
          const Positioned(
            left: 20,
            top: 50,
            child: SizedBox(
              width: 110,
              child: Text(
                "Head and Shoulders Shampoo 400 ml",
                style: TextStyle(
                    color: Colors.orangeAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          const Positioned(
              left: 20,
              bottom: 10,
              child: Text(
                "Add to cart",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              )),
          Positioned(
            right: -12,
            bottom: -12,
            child: Container(
              child: const Center(
                child: Text(
                  "30%",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.w900),
                ),
              ),
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.circular(200),
              ),
            ),
          )
        ],
      ),
    ), //SizedBox
  );
}