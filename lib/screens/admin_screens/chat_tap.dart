import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pharmacyapp/contsants/themes.dart';
import 'package:pharmacyapp/contsants/widgets.dart';
import 'package:pharmacyapp/cubit/admin_cubit.dart';
import 'package:pharmacyapp/cubit/states.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'chat_body_page.dart';

class ChatTap extends StatefulWidget {
  const ChatTap({Key? key}) : super(key: key);

  @override
  _ChatTapState createState() => _ChatTapState();
}

class _ChatTapState extends State<ChatTap> {
  Map currentChatData = {
    "name": "Salma Raafat",
    "number": "01055994809",
    "time": "12:01 AM",
    "seen": true,
    "online": true,
    "image":
        "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cmFuZG9tJTIwcGVyc29ufGVufDB8fDB8fA%3D%3D&w=1000&q=80",
    "new": true
  };

  List<Map<String, dynamic>> chatList = [
    {
      "name": "Salma Raafat",
      "number": "01055994809",
      "time": "12:01 AM",
      "seen": true,
      "online": true,
      "image":
          "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cmFuZG9tJTIwcGVyc29ufGVufDB8fDB8fA%3D%3D&w=1000&q=80",
      "new": true
    },
    {
      "name": "Mona Zaki",
      "number": "01150394809",
      "time": "12:01 AM",
      "seen": false,
      "online": false,
      "image": "https://see.news/wp-content/uploads/2019/10/Mona-Zaki.jpg",
      "new": false
    },
    {
      "name": "Reem Mohammed ",
      "number": "01200599808",
      "time": "3:50 PM",
      "seen": true,
      "online": false,
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQYfdG-K_WIyFF8RQsr3xA5w0CyZhEYVXwyVg&usqp=CAU",
      "new": true
    },
    {
      "name": "Tarek Mohammed",
      "number": "01055994810",
      "time": "3:50 AM",
      "seen": false,
      "online": true,
      "image":
          "https://4bgowik9viu406fbr2hsu10z-wpengine.netdna-ssl.com/wp-content/uploads/2020/03/Portrait_5-1.jpg",
      "new": false
    },
    {
      "name": "Ali Ashraf",
      "number": "01066994809",
      "time": "6:22 PM",
      "seen": true,
      "online": false,
      "image":
          "https://4bgowik9viu406fbr2hsu10z-wpengine.netdna-ssl.com/wp-content/uploads/2020/03/Portrait_3.jpg",
      "new": false
    },
  ];

  bool chatScreen = false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {},
        builder: (BuildContext context, AppStates state) {
          // AdminCubit cubit = AdminCubit.get(context);

          return AnimatedSwitcher(
            duration: const Duration(seconds: 1),
            reverseDuration: const Duration(milliseconds: 500),
            switchInCurve: Curves.elasticOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return SlideTransition(
                position: Tween(
                  begin: const Offset(1, 1),
                  end: const Offset(0.0, 0.0),
                ).animate(animation),
                child: child,
              );
            },
            child: chatScreen
                ? Stack(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: ChatBodyScreen(),
                      ),
                      SizedBox(
                        height: 60,
                        child: Card(
                          margin: const EdgeInsets.all(10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      chatScreen = false;
                                    });
                                  },
                                  icon: const Icon(Icons.arrow_back)),
                              Stack(
                                children: [
                                  CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    radius: 25,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: CachedNetworkImage(
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                          Icons.person,
                                          size: 25,
                                        ),
                                        imageUrl: currentChatData['image'],
                                      ),
                                    ),
                                  ),
                                  currentChatData['online']
                                      ? const Positioned(
                                          right: 0,
                                          child: Icon(
                                            Icons.circle,
                                            size: 20,
                                            color: Colors.green,
                                          ))
                                      : Container(),
                                ],
                              ),
                              defaultSpaceW(20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 150,
                                    child: Text(
                                      currentChatData['name'],
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(currentChatData['number']),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      setState(() {});
                    },
                    child: Scrollbar(
                      // isAlwaysShown: true,
                      child: ListView.separated(
                        itemCount: chatList.length,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return Slidable(
                            useTextDirection: true,
                            startActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              //dismissible: DismissiblePane(onDismissed: () {}),
                              children: [
                                SlidableAction(
                                  flex: 2,
                                  onPressed: (BuildContext context) {},
                                  icon: Icons.block,
                                  label: AppLocalizations.of(context)!.block,
                                ),
                                SlidableAction(
                                  flex: 2,
                                  onPressed: (BuildContext context) {},
                                  icon: Icons.archive,
                                  label: AppLocalizations.of(context)!.archive,
                                ),
                              ],
                            ),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  chatScreen = true;
                                  currentChatData = chatList[index];
                                });
                              },
                              child: Card(
                                color: chatList[index]['new']
                                    ? themeColor.withOpacity(0.5)
                                    : null,
                                elevation: 2,
                                margin: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Stack(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          radius: 40,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: CachedNetworkImage(
                                              width: 150,
                                              height: 150,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  const CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(
                                                Icons.person,
                                                size: 30,
                                              ),
                                              imageUrl: chatList[index]
                                                  ['image'],
                                            ),
                                          ),
                                        ),
                                        chatList[index]['online']
                                            ? const Positioned(
                                                right: 0,
                                                child: Icon(
                                                  Icons.circle,
                                                  size: 20,
                                                  color: Colors.green,
                                                ))
                                            : Container(),
                                      ],
                                    ),
                                    defaultSpaceW(20),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 150,
                                          child: Text(
                                            chatList[index]['name'],
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Text(chatList[index]['number']),
                                      ],
                                    ),
                                    const Spacer(),
                                    Column(
                                      children: [
                                        chatList[index]['seen']
                                            ? const Icon(
                                                Icons.done_all_rounded,
                                                size: 20,
                                                color: Colors.green,
                                              )
                                            : const Icon(
                                                Icons.done_sharp,
                                                size: 20,
                                                color: Colors.blue,
                                              ),
                                        Text(
                                          chatList[index]['time'],
                                          style: const TextStyle(
                                              color: Colors.blue,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    defaultSpaceW(10),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return defaultSpaceH(10);
                        },
                      ),
                    ),
                  ),
          );
        });
  }
}
