import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pharmacyapp/cubit/operation_cubit.dart';
import 'package:pharmacyapp/cubit/states.dart';
import 'package:pharmacyapp/shared/pref_helper.dart';
import '../contsants/const_colors.dart';
import '../reusable/components.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TextEditingController message = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  int? _activeMeterIndex = 1000;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        AppCubit cubit = AppCubit.get(context);

        late List<Widget> headList = [
          headTitle("Privacy Policies"),
          headTitle("Message Developers"),
        ];
        late List<Widget> contentList = [w1(), messageDevCont()];

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
              appBar: AppBar(
                  centerTitle: true,
                  toolbarHeight: 60,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(30),
                    ),
                  ),
                  backgroundColor: themeColor,
                  elevation: 0,
                  title: const Text(
                    "Settings",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Language",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10,),
                        DecoratedBox(
                            decoration: BoxDecoration(
                              color: themeColor, //background color of dropdown button
                              border: Border.all(color: Colors.black38, width:1), //border of dropdown button
                              borderRadius: BorderRadius.circular(50), //border raiuds of dropdown button

                            ),
                            child:Padding(
                                padding: const EdgeInsets.only(left:30, right:30),
                                child: DropdownButton(
                                  value: cubit.languageState,
                                  items: const [
                                    DropdownMenuItem(
                                      child: Text("English"),
                                      value: "English",
                                    ),
                                    DropdownMenuItem(
                                        child: Text("Arabic"),
                                        value: "Arabic"
                                    ),
                                    DropdownMenuItem(
                                      child: Text("System"),
                                      value: "System",
                                    )
                                  ],
                                  onChanged: (value){
                                    setState(() {
                                      if(cubit.languageState != value.toString()){
                                        cubit.languageState = value.toString();
                                        PreferenceHelper.putDataInSharedPreference(key: 'language',value: value.toString());
                                        EasyLoading.showInfo("Restart the App to make changes");
                                      }
                                    });

                                  },
                                  icon: const Padding(
                                      padding: EdgeInsets.only(left:20),
                                      child:Icon(Icons.language)
                                  ),
                                  iconEnabledColor: Colors.white,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20
                                  ),

                                  dropdownColor: Colors.blueGrey,
                                  underline: Container(),
                                  isExpanded: true,
                                )
                            )
                        ),

                        const Divider(thickness: 2,),
                        const Text(
                          "Theme",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10,),
                        DecoratedBox(
                            decoration: BoxDecoration(
                              color: themeColor, //background color of dropdown button
                              border: Border.all(color: Colors.black38, width:1), //border of dropdown button
                              borderRadius: BorderRadius.circular(50), //border raiuds of dropdown button

                            ),
                            child:Padding(
                                padding: const EdgeInsets.only(left:30, right:30),
                                child: DropdownButton(
                                  value: cubit.themeState,
                                  items: const [ //add items in the dropdown
                                    DropdownMenuItem(
                                      child: Text("Light"),
                                      value: "Light",
                                    ),
                                    DropdownMenuItem(

                                        child: Text("Dark"),
                                        value: "Dark"
                                    ),
                                    DropdownMenuItem(
                                      child: Text("System"),
                                      value: "System",
                                    )
                                  ],
                                  onChanged: (value){
                                    setState(() {
                                      cubit.themeState = value.toString();
                                      PreferenceHelper.putDataInSharedPreference(key: 'ThemeState',value: value.toString());
                                      if( value.toString() == 'Light'){
                                        EasyDynamicTheme.of(context).changeTheme(dark: false);
                                      }
                                      else if(value.toString() == 'Dark'){
                                        EasyDynamicTheme.of(context).changeTheme(dark: true);
                                      }
                                      else{
                                        EasyDynamicTheme.of(context).changeTheme(dynamic: true);
                                      }
                                    });

                                  },
                                  icon: const Padding(
                                      padding: EdgeInsets.only(left:20),
                                      child:Icon(Icons.color_lens_rounded)
                                  ),
                                  iconEnabledColor: Colors.white,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20
                                  ),
                                  dropdownColor: Colors.blueGrey,
                                  underline: Container(),
                                  isExpanded: true,
                                )
                            )
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: 2,
                        itemBuilder: (BuildContext context, int i) {
                          return Card(
                            margin: const EdgeInsets.fromLTRB(
                                10.0, 15.0, 10.0, 0.0),
                            child: ExpansionPanelList(
                              elevation: 0.0,
                              animationDuration: const Duration(seconds: 1),
                              expansionCallback: (int index, bool status) {
                                setState(() {
                                  _activeMeterIndex =
                                      _activeMeterIndex == i ? null : i;
                                });
                              },
                              children: [
                                ExpansionPanel(
                                    canTapOnHeader: true,
                                    backgroundColor: _activeMeterIndex == i
                                        ? Colors.cyan
                                        : null,
                                    isExpanded: _activeMeterIndex == i,
                                    headerBuilder: (BuildContext context,
                                            bool isExpanded) =>
                                        Container(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            alignment: Alignment.centerLeft,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: [
                                                  headList[i],
                                                ],
                                              ),
                                            )),
                                    body: contentList[i]),
                              ],
                            ),
                          );
                        }),
                  ),
                  footer(),
                ],
              )),
        );
      },
    );
  }

  Widget headTitle(String txt) {
    return Text(
      txt,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget w1() {
    return const SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Text("""
      Personal Data
      Demographic and other personally identifiable information (such as your name and email
      address) that you voluntarily give to us when choosing to participate in various activities related
      to the Application, such as chat, posting messages in comment sections or in our forums, liking
      posts, sending feedback, and responding to surveys. If you choose to share data about yourself
      via your profile, online chat, or other interactive areas of the Application, please be advised that
      all data you disclose in these areas is public and your data will be accessible to anyone who
      accesses the Application.
      
      Derivative Data
      Information our servers automatically collect when you access the Application, such as your
      native actions that are integral to the Application, including liking, re-blogging, or replying to a
      post, as well as other interactions with the Application and other users via server log files.
      
      Financial Data : Not applicable for VDLNedcar apps.
      There is no payment necessary for this Application. Financial information, such as data related
      to your payment method is for this application Not Applicable.
      Facebook Permissions : Not applicable for VDLNedcar apps.
      
      Data from Social Networks : Not applicable for VDLNedcar apps.
      User information from social networking sites, such as [Apple’s Game Center, Facebook,
      Google+ Instagram, Pinterest, Twitter], including your name, your social network username,
      location, gender, birth date, email address, profile picture, and public data for contacts, if you
      connect your account to such social networks. This information may also include the contact
      information of anyone you invite to use and/or join the Application.
      
      Geo-Location Information : Not applicable for VDLNedcar apps.
      We may request access or permission to and track location-based information from your mobile
      device, either continuously or while you are using the Application, to provide location-based
      services. If you wish to change our access or permissions, you may do so in your device’s
      settings.
      
      Mobile Device Access
      We may request access or permission to certain features from your mobile device, including
      your mobile device’s storage. If you wish to change our access or permissions, you may do so
      in your device’s settings.
      Mobile Device Data : Not applicable for VDLNedcar apps.
      Device information such as your mobile device ID number, model, and manufacturer, version of
      your operating system, phone number, country, location, and any other data you choose to
      provide.
      
      Push Notifications
      We may request to send you push notifications regarding your account or the Application. If you
      wish to opt-out from receiving these types of communications, you may turn them off in your
      device’s settings.
      Third-Party Data : Not applicable for VDLNedcar apps.
      Information from third parties, such as personal information or network friends, if you connect
      your account to the third party and grant the Application permission to access this information.
      Data From Contests, Giveaways, and Surveys : Not applicable for VDLNedcar
      apps.
      Personal and other information you may provide when entering contests or giveaways and/or
      responding to surveys.
      
      """),
    );
  }

  Widget messageDevCont() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            defaultTextField(
                label: "Message",
                controller: message,
                prefixIcon: Icons.message_outlined,
                validateString: "Message Shouldn't be Empty",
                keyboardType: TextInputType.multiline,
                lineCount: 2),
            ElevatedButton.icon(
                label: const Text("Send"),
                icon: const Icon(Icons.send_rounded),
                style: ElevatedButton.styleFrom(
                    primary: themeColor,
                    fixedSize: const Size(250, 35.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80))),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    sendMessage();
                  }
                }),
          ],
        ),
      ),
    );
  }

  void sendMessage() {
    EasyLoading.show(status: "sending message...");
    String phone;
    String name;

    try {
      phone = AppCubit.userData.phone;
      name = AppCubit.userData.fullName();
    } catch (err) {
      phone = "visitor";
      name = "visitor";
    }

    final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
    _fireStore.collection("dev messages").add({
      "body": message.text,
      "phone": phone,
      "name": name,
      "read": false,
      "time": DateTime.now().toString(),
    }).then((value) {
      EasyLoading.showToast("message sent successfully");
      message.clear();
    }).catchError((err) {
      setState(() {
        EasyLoading.dismiss();
      });
      EasyLoading.showError("Error while sending the message");
    });
  }

  Widget footer() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/HomationLogo.png",
                height: 30,
                color: themeColor,
              ),
              const SizedBox(
                width: 7,
              ),
              Column(
                children: const [
                  Text("By Homation"),
                  Text("Version 1.0"),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }
}
