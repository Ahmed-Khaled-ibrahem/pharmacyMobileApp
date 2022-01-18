import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
              padding: const EdgeInsets.all(15),
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
                            itemBuilder: (BuildContext _, int index) {
                              return ListTile(
                                onTap: () {
                                  print(snapshot.data![index]['id']);
                                },
                                title: Text(
                                    "Order ${index + 1} at ${snapshot.data![index]['time']}"),
                                subtitle: Text(
                                    "price ${snapshot.data![index]['price'] == 0 ? "-" : snapshot.data![index]['price']}"),
                              );
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
