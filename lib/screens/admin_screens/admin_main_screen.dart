import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacyapp/cubit/operation_cubit.dart';
import 'package:pharmacyapp/cubit/states.dart';
import '../../reusable/components.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'Chat_tap.dart';
import 'Main_tab.dart';
import 'delivery_tab.dart';
import 'offers_tab.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({Key? key}) : super(key: key);

  @override
  _AdminMainScreenState createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        AppCubit cubit = AppCubit.get(context);

        return DefaultTabController(
          length: 4,
          child: WillPopScope(
            onWillPop: () => onWillPop(context),
            child: Scaffold(
              appBar: myAppBar(
                actionIcon: IconButton(
                    onPressed: (){},
                    icon: const Icon(Icons.notifications)),
                  text: AppLocalizations.of(context)!.tamerdewwek,
                  context: context,
                  bottomBar: const TabBar(
                      tabs: [
                  Tab(icon: Icon(Icons.home_rounded)),
                  Tab(icon: Icon(Icons.chat_rounded)),
                  Tab(icon: Icon(Icons.local_offer)),
                  Tab(icon: Icon(Icons.delivery_dining_rounded)),
              ]),),
              body:const TabBarView(
                children: [
                  MainTap(),
                  ChatTap(),
                  OffersTab(),
                  DeliveryTab(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  Future<bool> onWillPop(BuildContext context) async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.are_you_sure),
        content: Text(AppLocalizations.of(context)!.do_you_want_to_exit),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context)!.no),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(AppLocalizations.of(context)!.yes),
          ),
        ],
      ),
    )) ?? false;
  }
}



