import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacyapp/contsants/widgets.dart';
import 'package:pharmacyapp/cubit/admin_cubit.dart';
import 'package:pharmacyapp/cubit/states.dart';
import 'package:pharmacyapp/reusable/funcrions.dart';
import '../../reusable/components.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'chat_tap.dart';
import 'main_tab.dart';
import 'delivery_tab.dart';
import 'notifications_page.dart';
import 'offers_tab.dart';

class AdminMainScreen extends StatelessWidget {
  const AdminMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AdminCubit()..startAdminProcess(),
      child: BlocConsumer<AdminCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {},
        builder: (BuildContext context, AppStates state) {
          // AdminCubit cubit = AdminCubit.get(context);

          return DefaultTabController(
            length: 4,
            child: WillPopScope(
              onWillPop: () => onWillPop(context),
              child: Scaffold(
                appBar: myAppBar(
                  actionIcon: IconButton(
                      onPressed: () {
                        navigateTo(context, const NotificationsScreen(), true);
                      },
                      icon: const Icon(Icons.notifications)),
                  text: AppLocalizations.of(context)!.tamerdewwek,
                  context: context,
                  bottomBar: const TabBar(
                      //padding: EdgeInsets.all(20),
                      //overlayColor: MaterialStateProperty.all(themeColor.withOpacity(0.5)),
                      //automaticIndicatorColorAdjustment: true,
                      //labelStyle: TextStyle(color: Colors.blue),
                      indicatorColor: Colors.redAccent,
                      //indicatorSize: TabBarIndicatorSize.label,
                      isScrollable: true,
                      indicatorWeight: 3,
                      physics: defaultScrollPhysics,
                      tabs: [
                        Tab(icon: Icon(Icons.chat_rounded)),
                        Tab(icon: Icon(Icons.home_rounded)),
                        Tab(icon: Icon(Icons.local_offer)),
                        Tab(icon: Icon(Icons.delivery_dining_rounded)),
                      ]),
                ),
                body: const TabBarView(
                  children: [
                    ChatTap(),
                    MainTap(),
                    OffersTab(),
                    DeliveryTab(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
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
        )) ??
        false;
  }
}
