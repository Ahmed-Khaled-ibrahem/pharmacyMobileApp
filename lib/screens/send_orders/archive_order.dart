import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacyapp/contsants/const_colors.dart';
import 'package:pharmacyapp/contsants/widgets.dart';
import 'package:pharmacyapp/cubit/operation_cubit.dart';
import 'package:pharmacyapp/cubit/states.dart';
import '../../reusable/components.dart';

// ignore: must_be_immutable
class ArchiveOrders extends StatelessWidget {
  const ArchiveOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        AppCubit cubit = AppCubit.get(context);

        return Scaffold(
            appBar: myAppBar(
              text: "Orders archive",
              context: context,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: cubit.getAllArchiveData(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    default:
                      if (snapshot.hasError) {
                        print(snapshot.error);
                        return const Center(child: Text('Error'));
                      } else if (snapshot.data != null &&
                          snapshot.data!.isNotEmpty) {
                        return ListView.separated(
                            physics: defaultScrollPhysics,
                            itemBuilder: (BuildContext _, int index) {
                              index = snapshot.data!.length - index - 1;
                              DateTime dateTime =
                                  DateTime.parse(snapshot.data![index]['time']);
                              String date = DateFormat("yyyy-MM-dd hh:mm:ss")
                                  .format(dateTime);
                              return ListTile(
                                  isThreeLine: true,
                                  onTap: () {
                                    print(snapshot.data![index]['id']);
                                    print(snapshot.data![index]['details']);
                                  },
                                  leading: CircleAvatar(
                                      foregroundColor: Colors.white,
                                      backgroundColor: themeColor,
                                      child: Text(
                                        "${index + 1}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                  title: Text(
                                    "Date  $date",
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "price :  ${snapshot.data![index]['price'] == 0 ? "not yet" : snapshot.data![index]['price']}",
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 15,
                                          )),
                                      Row(
                                        children: [
                                          Text(
                                              "Items count ${snapshot.data![index]['itemsCount']}",
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              )),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                              "Images count ${snapshot.data![index]['imageCount']}",
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ))
                                        ],
                                      ),
                                    ],
                                  ));
                            },
                            separatorBuilder: (_, __) {
                              return const Divider();
                            },
                            itemCount: snapshot.data!.length);
                      } else {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.archive,
                                color: Colors.grey,
                                size: 100,
                              ),
                              Text(
                                'No old orders',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              )
                            ],
                          ),
                        );
                      }
                  }
                },
              ),
            ));
      },
    );
  }
}
