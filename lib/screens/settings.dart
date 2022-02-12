import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pharmacyapp/contsants/widgets.dart';
import 'package:pharmacyapp/cubit/operation_cubit.dart';
import 'package:pharmacyapp/cubit/states.dart';
import 'package:pharmacyapp/reusable/funcrions.dart';
import 'package:pharmacyapp/screens/show_screens/profile_page.dart';
import 'package:pharmacyapp/shared/pref_helper.dart';
import 'package:pharmacyapp/contsants/themes.dart';
import '../main.dart';
import '../reusable/components.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class SettingsScreen extends StatelessWidget {
  SettingsScreen(this.fromSign, {Key? key}) : super(key: key) {
    try {
      AppCubit.userData.phone;
    } catch (err) {
      fromSign = true;
    }
  }

  TextEditingController message = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool fromSign;
  int? _activeMeterIndex = 1000;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        AppCubit cubit = AppCubit.get(context);

        late List<Widget> headList = [
          headTitle(AppLocalizations.of(context)!.privacy_policies),
          headTitle(AppLocalizations.of(context)!.message_developers),
        ];
        late List<Widget> contentList = [w1(), messageDevCont(context)];

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
                title: Text(
                  AppLocalizations.of(context)!.settings,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                )),
            body: SingleChildScrollView(
              physics: defaultScrollPhysics,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: !fromSign,
                          child: fromSign
                              ? Container()
                              : ListTile(
                                  onTap: () {
                                    navigateTo(context, ProfileScreen(), true);
                                  },
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 32,
                                    child: ClipOval(
                                      child: Image.network(
                                        AppCubit.userData.photo,
                                        width: 50,
                                        errorBuilder: (_, __, ___) {
                                          return const Icon(Icons.person);
                                        },
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    AppCubit.userData.fullName(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: SizedBox(
                                      height: 40,
                                      width: 30,
                                      child: Icon(
                                        Icons.edit,
                                        color: Theme.of(context).indicatorColor,
                                      )),
                                  subtitle: Text(AppCubit.userData.phone),
                                  horizontalTitleGap: 20,
                                ),
                        ),
                        Visibility(
                          visible: fromSign,
                          child: const Divider(
                            thickness: 2,
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)!.language,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        defaultSpaceH(10),
                        DecoratedBox(
                            decoration: BoxDecoration(
                              color:
                                  themeColor, //background color of dropdown button
                              border: Border.all(
                                  color: Colors.black38,
                                  width: 1), //border of dropdown button
                              borderRadius: BorderRadius.circular(
                                  50), //border raiuds of dropdown button
                            ),
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 30, right: 30),
                                child: DropdownButton(
                                  value: cubit.languageState,
                                  items: const [
                                    DropdownMenuItem(
                                      child: Text("English"),
                                      value: "English",
                                    ),
                                    DropdownMenuItem(
                                        child: Text("العربية"),
                                        value: "Arabic"),
                                    DropdownMenuItem(
                                      child: Text("System"),
                                      value: "System",
                                    )
                                  ],
                                  onChanged: (value) {
                                    if (cubit.languageState !=
                                        value.toString()) {
                                      cubit.languageState = value.toString();
                                      PreferenceHelper
                                          .putDataInSharedPreference(
                                              key: 'language',
                                              value: value.toString());
                                      cubit.emitGeneralState();
                                      RestartWidget.restartApp(context);
                                    }
                                  },
                                  icon: const Padding(
                                      padding: EdgeInsets.only(left: 20),
                                      child: Icon(Icons.language)),
                                  iconEnabledColor: Colors.white,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20),
                                  dropdownColor: Colors.blueGrey,
                                  underline: Container(),
                                  isExpanded: true,
                                ))),
                        const Divider(
                          thickness: 2,
                        ),
                        Text(
                          AppLocalizations.of(context)!.theme,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        defaultSpaceH(10),
                        DecoratedBox(
                            decoration: BoxDecoration(
                              color:
                                  themeColor, //background color of dropdown button
                              border: Border.all(
                                  color: Colors.black38,
                                  width: 1), //border of dropdown button
                              borderRadius: BorderRadius.circular(
                                  50), //border raiuds of dropdown button
                            ),
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 30, right: 30),
                                child: DropdownButton(
                                  value: cubit.themeState,
                                  items: const [
                                    //add items in the dropdown
                                    DropdownMenuItem(
                                      child: Text("Light"),
                                      value: "Light",
                                    ),
                                    DropdownMenuItem(
                                        child: Text("Dark"), value: "Dark"),
                                    DropdownMenuItem(
                                      child: Text("System"),
                                      value: "System",
                                    )
                                  ],
                                  onChanged: (value) {
                                    cubit.themeState = value.toString();
                                    PreferenceHelper.putDataInSharedPreference(
                                        key: 'ThemeState',
                                        value: value.toString());
                                    if (value.toString() == 'Light') {
                                      EasyDynamicTheme.of(context)
                                          .changeTheme(dark: false);
                                    } else if (value.toString() == 'Dark') {
                                      EasyDynamicTheme.of(context)
                                          .changeTheme(dark: true);
                                    } else {
                                      EasyDynamicTheme.of(context)
                                          .changeTheme(dynamic: true);
                                    }
                                    cubit.emitGeneralState();
                                  },
                                  icon: const Padding(
                                      padding: EdgeInsets.only(left: 20),
                                      child: Icon(Icons.color_lens_rounded)),
                                  iconEnabledColor: Colors.white,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20),
                                  dropdownColor: Colors.blueGrey,
                                  underline: Container(),
                                  isExpanded: true,
                                ))),
                        const Divider(
                          thickness: 2,
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 2,
                      itemBuilder: (BuildContext context, int i) {
                        return Card(
                          margin:
                              const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0.0),
                          child: ExpansionPanelList(
                            elevation: 0.0,
                            animationDuration: const Duration(seconds: 1),
                            expansionCallback: (int index, bool status) {
                              _activeMeterIndex =
                                  _activeMeterIndex == i ? null : i;
                              cubit.emitGeneralState();
                            },
                            children: [
                              ExpansionPanel(
                                  canTapOnHeader: true,
                                  backgroundColor: _activeMeterIndex == i
                                      ? themeColorBlue
                                      : themeColorGray,
                                  isExpanded: _activeMeterIndex == i,
                                  headerBuilder: (BuildContext context,
                                          bool isExpanded) =>
                                      Container(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          alignment: Alignment.centerLeft,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
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
                ],
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              child: footer(context),
            ),
          ),
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
    return const SizedBox(
      height: 200,
      child: SingleChildScrollView(
        physics: defaultScrollPhysics,
        scrollDirection: Axis.vertical,
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
      ),
    );
  }

  Widget messageDevCont(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            defaultTextField(
                label: AppLocalizations.of(context)!.message,
                controller: message,
                prefixIcon: Icons.message_outlined,
                validateString: AppLocalizations.of(context)!.error_message,
                keyboardType: TextInputType.multiline,
                lineCount: 2),
            ElevatedButton.icon(
                label: Text(AppLocalizations.of(context)!.send),
                icon: const Icon(Icons.send_rounded),
                style: ElevatedButton.styleFrom(
                    primary: themeColor,
                    fixedSize: const Size(250, 35.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80))),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    sendMessage(context);
                  }
                }),
          ],
        ),
      ),
    );
  }

  void sendMessage(BuildContext context) {
    EasyLoading.show(status: AppLocalizations.of(context)!.sending_message);
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
      EasyLoading.showToast(
          AppLocalizations.of(context)!.message_sent_successfully);
      message.clear();
    }).catchError((err) {
      EasyLoading.dismiss();
      EasyLoading.showError(
          AppLocalizations.of(context)!.error_sending_message);
    });
  }

  Widget footer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/HomationLogo.png",
            height: 25,
            color: themeColorBlue,
          ),
          defaultSpaceW(10),
          SizedBox(
            height: 35,
            child: Column(
              children: [
                Text(AppLocalizations.of(context)!.powered_by_homation,style: Theme.of(context).textTheme.headline5,),
                Text(
                  AppLocalizations.of(context)!.version + " 1.0.0",
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
