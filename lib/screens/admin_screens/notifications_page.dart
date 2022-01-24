import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacyapp/contsants/widgets.dart';
import 'package:pharmacyapp/cubit/operation_cubit.dart';
import 'package:pharmacyapp/cubit/states.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, String>> notifications = [
    {"category": "App", "text": "you should login again", "time": "3:50 AM"},
    {"category": "Chat", "text": "new offers in the market check this out", "time": "6:22 BM"},
    {"category": "Today Advice", "text": "today advice : لا تؤجل عمل اليوم الي الغد", "time": "12:01 AM"},
    {"category": "Delivery", "text": "order number 3 is delivered", "time": "12:01 AM"},
    {"category": "General", "text": "نصائح طبيه يوميه", "time": "3:50 BM"},
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {},
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);

          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: const Text("Notifications"),
              backgroundColor: Theme.of(context).canvasColor,
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: notifications.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.notifications_off_outlined,
                            size: 40,
                          ),
                          Text("There is no notifications to show"),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text("Swipe to remove  "),
                            Icon(Icons.swipe),
                          ],
                        ),
                        Expanded(
                          child: ListView.builder(
                              itemCount: notifications.length,
                              physics: defaultScrollPhysics,
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  children: [
                                    Dismissible(
                                      background: Container(
                                        color: Colors.red,
                                        child: const Icon(
                                          Icons.restore_from_trash_rounded,
                                          size: 40,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 10, top: 10),
                                        child: ListTile(
                                          leading: const Icon(
                                              Icons.notifications_none),
                                          trailing:  Text(
                                            notifications[index]['time']!,
                                            style: const TextStyle(
                                                color: Colors.green,
                                                fontSize: 15),
                                          ),
                                          title: Text(notifications[index]['text']!),
                                          subtitle: Text(notifications[index]['category']!),
                                        ),
                                      ),
                                      onDismissed: (direction) {
                                        setState(() {
                                          notifications.removeAt(index);
                                        });
                                      },
                                      key: UniqueKey(),
                                    ),
                                  ],
                                );
                              }),
                        ),
                        TextButton(
                            style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all(
                                    Colors.redAccent)),
                            onPressed: () {
                              for (int i = notifications.length; i > 0; i--) {
                                setState(() {
                                  notifications.removeAt(i - 1);
                                });
                              }
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("all notifications are deleted")));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.close),
                                Text("  Remove all"),
                              ],
                            ))
                      ],
                    ),
            ),
          );
        });
  }
}
