import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacyapp/contsants/themes.dart';
import 'package:pharmacyapp/cubit/admin_cubit.dart';
import 'package:pharmacyapp/cubit/states.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeliveryTab extends StatefulWidget {
  const DeliveryTab({Key? key}) : super(key: key);

  @override
  _DeliveryTabState createState() => _DeliveryTabState();
}

class _DeliveryTabState extends State<DeliveryTab> {
  int? _activeMeterIndex = 1000;

  List<Map<String, dynamic>> allOrdersData = [
    {
      'number': '01188534457',
      'name': 'Ali 7fnawy',
      'image':
          'https://images.unsplash.com/photo-1547425260-76bcadfb4f2c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxjb2xsZWN0aW9uLXBhZ2V8OXw4NzcyOTI0fHxlbnwwfHx8fA%3D%3D&w=1000&q=80',
      'time': '3:25 AM',
      'distance': '10',
      'address': ' شارع سعيد الجندي الحضره القبليه الدور السابع عماره 45 شقه13',
      'location': '31.2062316,29.9111692',
      'itemsList': [
        {'name': 'Panadol Extra50 Mg', 'quantity': '1', 'price': '20'},
        {'name': 'Antinal 50 Mg', 'quantity': '1', 'price': '17.5'},
        {'name': 'Close up 30 gm', 'quantity': '2', 'price': '12'},
        {'name': 'Tooth Brush', 'quantity': '2', 'price': '8'},
      ],
    },
    {
      'number': '01288663015',
      'name': 'Hanin Ahmed',
      'image':
          'https://cdn.al-ain.com/images/2021/1/13/133-195934-hanin-hossam-cairo-university-spreading-immorality_700x400.jpg',
      'time': '5:25 PM',
      'distance': '3',
      'address':
          '64 شارع نصر الدين امام سوبرماركت الهدايا الدور الاول علوي شقه 8',
      'location': '31.2062316,29.9111692',
      'itemsList': [
        {'name': 'Congestal SR', 'quantity': '1', 'price': '15.5'},
        {'name': 'Comtrex SR 50 Mg', 'quantity': '1', 'price': '20'},
        {'name': 'Signal 8 Whitning 15 gm', 'quantity': '2', 'price': '30'},
        {'name': 'Tooth Brushs', 'quantity': '2', 'price': '13'},
        {'name': 'SunLight soap ', 'quantity': '1', 'price': '13'},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        AdminCubit cubit = AdminCubit.get(context);

        return AnimatedSwitcher(
          duration: const Duration(seconds: 2),
          reverseDuration: const Duration(milliseconds: 500),
          switchInCurve: Curves.elasticOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(
              filterQuality: FilterQuality.high,
              scale: animation,
              child: child,
            );
          },
          child: allOrdersData.isEmpty
              ? Column(
                  key: const Key("column2"),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    const Icon(
                      Icons.done_outline_rounded,
                      size: 60,
                    ),
                    Text(AppLocalizations.of(context)!.there_is_no_orders_now),
                  ],
                )
              : AnimatedSwitcher(
                  duration: const Duration(seconds: 1),
                  reverseDuration: const Duration(seconds: 1),
                  switchInCurve: Curves.elasticOut,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        key: Key("${allOrdersData.length}"),
                        //physics: const NeverScrollableScrollPhysics(),
                        //shrinkWrap: true,
                        itemCount: allOrdersData.length,
                        itemBuilder: (BuildContext context, int i) {
                          return Card(
                            margin: const EdgeInsets.fromLTRB(
                                10.0, 15.0, 10.0, 0.0),
                            child: ExpansionPanelList(
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
                                      ? Colors.teal.withOpacity(0.5)
                                      : null,
                                  isExpanded: _activeMeterIndex == i,
                                  headerBuilder:
                                      (BuildContext context, bool isExpanded) =>
                                          ListTile(
                                    horizontalTitleGap: 20,
                                    style: ListTileStyle.list,
                                    trailing: Text(allOrdersData[i]['distance']+' '+AppLocalizations.of(context)!.km,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold)),
                                    leading: CircleAvatar(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      radius: 30,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: CachedNetworkImage(
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(
                                            Icons.person,
                                            size: 40,
                                          ),
                                          imageUrl: allOrdersData[i]['image'],
                                        ),
                                      ),
                                    ),
                                    subtitle: Text(allOrdersData[i]['number'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    title: Text(allOrdersData[i]['name']),
                                  ),
                                  body: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                             Text(
                                              AppLocalizations.of(context)!.time+'  ',
                                              style: const TextStyle(
                                                  color: Colors.cyan,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(allOrdersData[i]['time']),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                             Text(
                                              AppLocalizations.of(context)!.address+'  ',
                                              style: const TextStyle(
                                                  color: Colors.cyan,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                                width: 220,
                                                child: Text(allOrdersData[i]
                                                    ['address'])),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton.icon(
                                                icon: const Icon(
                                                    Icons.location_on),
                                                label:  Text(AppLocalizations.of(context)!.open_location_in_map),
                                                style: ElevatedButton.styleFrom(
                                                    primary: themeColor,
                                                    //fixedSize: const Size(250, 35.0),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        80))),
                                                onPressed: () {
                                                  openMap(allOrdersData[i]
                                                      ['location']);
                                                }),
                                            ElevatedButton(
                                                child: const Icon(
                                                    Icons.chat_rounded),
                                                style: ElevatedButton.styleFrom(
                                                    primary: themeColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        80))),
                                                onPressed: () {
                                                  cubit.controller.animateTo(
                                                    0,
                                                    duration: const Duration(
                                                        milliseconds: 1500),
                                                  );
                                                  //cubit.controller.index = 0;
                                                }),
                                          ],
                                        ),
                                         Text(
                                          AppLocalizations.of(context)!.items_list,
                                          style: const TextStyle(
                                              color: Colors.cyan,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: (allOrdersData[i]
                                                        ['itemsList'] as List)
                                                    .map(
                                                      (e) => Row(
                                                        children: [
                                                          Text(
                                                              "${(allOrdersData[i]['itemsList'] as List).indexOf(e) + 1}. "
                                                              "${e['name']}   "),
                                                          const Spacer(),
                                                          Text(
                                                              "${e['quantity']} *"
                                                              " ${e['price']} "+AppLocalizations.of(context)!.le),
                                                        ],
                                                      ),
                                                    )
                                                    .toList(),
                                              ),
                                              Text("+ 10 "+
                                                  AppLocalizations.of(context)!.le+
                                                  " "+
                                                  AppLocalizations.of(context)!.delivery_taxes),
                                              Text(
                                                  AppLocalizations.of(context)!.total_price+" = ${calcSum(i).toString()} "+AppLocalizations.of(context)!.le,
                                                  style: const TextStyle(
                                                      color: Colors.cyan,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                        Center(
                                          child: ElevatedButton.icon(
                                              label: Text(AppLocalizations.of(context)!.done_delivered),
                                              icon: const Icon(
                                                  Icons.done_outline_rounded),
                                              style: ElevatedButton.styleFrom(
                                                  primary: themeColor,
                                                  fixedSize:
                                                      const Size(250, 35.0),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              80))),
                                              onPressed: () {
                                                setState(() {
                                                  _activeMeterIndex = 1000;
                                                  allOrdersData.removeAt(i);
                                                });
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                ),
        );
      },
    );
  }

  double calcSum(int i) {
    double sum = 0;
    for (var element in allOrdersData[i]['itemsList']) {
      sum += double.parse(element['price']!);
    }
    return sum;
  }

  Future<void> openMap(String location) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$location';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}
