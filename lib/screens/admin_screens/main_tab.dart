import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pharmacyapp/contsants/themes.dart';
import 'package:pharmacyapp/contsants/widgets.dart';
import 'package:pharmacyapp/reusable/funcrions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'drug_edit_page.dart';

class MainTap extends StatefulWidget {
  const MainTap({Key? key}) : super(key: key);

  @override
  _MainTapState createState() => _MainTapState();
}

class _MainTapState extends State<MainTap> {
  bool ordersIsEnabled = true;
  TimeOfDay selectedTimeFrom = TimeOfDay.now();
  TimeOfDay selectedTimeTo = TimeOfDay.now();
  List<String> mostWanted = [
    'panadol 50 taps',
    'panadol Extra taps',
    'Voltaren 100 SR ',
    'Antinal syrup'
  ];


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: ElevatedButton(
                onPressed: () {
                  showSearch(context: context, delegate: CustomSearchDelegate());
                },
                child: SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      const Icon(Icons.search),
                      defaultSpaceW(5),
                      Text(AppLocalizations.of(context)!.search),
                      const Spacer(),
                      const Icon(Icons.local_pharmacy_rounded),
                    ],
                  ),
                ),
              ),
            ),
            /*
            SizedBox(
              width: double.infinity,
              height: 100,
              child: ListWheelScrollViewX(
                scrollDirection: Axis.horizontal,
                itemExtent: 170,
                diameterRatio: 2,
                offAxisFraction: 0.5,
                children: [
                  cardDesign('Followers',200.toString()),
                  cardDesign('Orders',10.toString()),
                  cardDesign('Chat',1.toString()),
                  cardDesign('Offers',6.toString()),
                ],
              ),
            ),
             */
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              children: [
                cardDesign(AppLocalizations.of(context)!.followers, 200.toString()),
                cardDesign(AppLocalizations.of(context)!.orders, 2.toString()),
                cardDesign(AppLocalizations.of(context)!.chat, 1.toString()),
                cardDesign(AppLocalizations.of(context)!.offers, 6.toString()),
                cardDesign(AppLocalizations.of(context)!.all_day_orders, 15.toString()),
              ],
            ),
            defaultSpaceH(10),
            Row(
              children: [
                defaultSpaceW(15),
                 Text(
                  AppLocalizations.of(context)!.the_most_ordered_list, textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.overline,
                ),
              ],
            ),
            SizedBox(
              height: 120,
              child: ListView.separated(
                  padding: const EdgeInsets.all(15),
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      children: [
                        Text('${index + 1} . ${mostWanted[index]}',
                        style: Theme.of(context).textTheme.headline5,),
                      ],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider();
                  },
                  itemCount: mostWanted.length),
            ),
            defaultSpaceH(20),
             Align(
               alignment: Alignment.center,
               child: Text(
                AppLocalizations.of(context)!.timing_of_delivery,
                style: Theme.of(context).textTheme.headline5,
            ),
             ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Text(
                  AppLocalizations.of(context)!.from,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                defaultSpaceW(5),
                InkWell(
                    onTap: () {
                      _selectTime(context, false);
                    },
                    child: Text(
                      selectedTimeFrom.format(context).toString(),
                      style: Theme.of(context).textTheme.button,
                    )),
                defaultSpaceW(5),
                 Text(
                  AppLocalizations.of(context)!.to,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                defaultSpaceW(5),
                InkWell(
                    onTap: () {
                      _selectTime(context, true);
                    },
                    child: Text(
                      selectedTimeTo.format(context).toString(),
                      style: Theme.of(context).textTheme.button,
                    )),
              ],
            ),
            defaultSpaceH(80),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 1000),
            reverseDuration: const Duration(milliseconds: 500),
            switchInCurve: Curves.elasticOut,
            //switchOutCurve: Curves.elasticOut,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return SlideTransition(
                position: Tween(
                  begin: const Offset(2, 0),
                  end: const Offset(0.0, 0.0),
                ).animate(animation),
                child: child,
              );
            },
            child: ordersIsEnabled
                ? ElevatedButton(
              key: const Key('enabledCard'),
              //margin: const EdgeInsets.all(20),
              onPressed: () {   setState(() {
                ordersIsEnabled = false;
              });},
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.delivery_dining_rounded,
                    size: 60,
                  ),
                  Text(
                    AppLocalizations.of(context)!.orders_enabled,
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            )
                : ElevatedButton(
              style: Theme.of(context).elevatedButtonTheme.style,
              key: const Key('disabledCard'),
              //margin: const EdgeInsets.all(20),
              onPressed: () {   setState(() {
                ordersIsEnabled = true;
              });},
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  const Icon(
                    Icons.disabled_by_default_rounded,
                    size: 60,
                    color: Colors.orange,
                  ),
                  Text(
                    AppLocalizations.of(context)!.orders_disabled,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  _selectTime(BuildContext context, bool toOrFrom) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      cancelText: AppLocalizations.of(context)!.cancel,
      confirmText: AppLocalizations.of(context)!.ok,
      context: context,
      initialTime: selectedTimeTo,
      initialEntryMode: TimePickerEntryMode.dial,
    );

    if (timeOfDay != null && timeOfDay != selectedTimeTo && toOrFrom) {
      setState(() {
        selectedTimeTo = timeOfDay;
      });
    }
    if (timeOfDay != null && timeOfDay != selectedTimeFrom && !toOrFrom) {
      setState(() {
        selectedTimeFrom = timeOfDay;
      });
    }
  }

  Widget cardDesign(String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title,),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyText1
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  List<String> items = [
    'one',
    'two',
    'first',
    'second',
    'ahmed',
    'apple',
    'orange'
  ];

  List<Map<String, String>> drugItem = [
    {
      'name': 'Panadol Extra 50mg',
      'price': '20',
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRJohJOH9MzlKeMhnxD4urqQxz5AXb_qgE-Xg&usqp=CAU'
    },
    {
      'name': 'Panadol Extra 50mg',
      'price': '20',
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRJohJOH9MzlKeMhnxD4urqQxz5AXb_qgE-Xg&usqp=CAU'
    },
    {
      'name': 'Panadol Extra 50mg',
      'price': '20',
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRJohJOH9MzlKeMhnxD4urqQxz5AXb_qgE-Xg&usqp=CAU'
    },
    {
      'name': 'Panadol Extra 50mg',
      'price': '20',
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRJohJOH9MzlKeMhnxD4urqQxz5AXb_qgE-Xg&usqp=CAU'
    },
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear_rounded),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    //SQL selection Here
    List matchQuary = items;
    //--------------------

    return ListView.builder(
        itemCount: matchQuary.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(matchQuary[index]),
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //SQL selection Here
    //List matchQuary = items;
    //--------------------
    return GridView.builder(
      scrollDirection: Axis.vertical,
      physics: defaultScrollPhysics,
      shrinkWrap: true,
      padding: const EdgeInsets.all(12.0),
      itemCount: drugItem.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: MediaQuery.of(context).size.width / (520),
          crossAxisCount: 2,
          crossAxisSpacing: 3,
          mainAxisSpacing: 5),
      itemBuilder: (BuildContext context, int index) =>
          searchItem(context, index),
    );
  }

  Widget searchItem(BuildContext context, int index) {
    return Card(
      elevation: 10,
      color: Colors.blue,
      child: Column(
        children: [
          defaultSpaceH(3),
          Stack(
            alignment: Alignment.topLeft,
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width / 2.4,
                  height: 120,
                  child: CachedNetworkImage(
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Center(
                            child: Text(
                              drugItem[index]['name']!.length < 2
                                  ? " "
                                  : drugItem[index]['name']!
                                      .trim()
                                      .substring(0, 2),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                      imageUrl: drugItem[index]['image']!)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SingleChildScrollView(
                  child: Tooltip(
                    message: drugItem[index]['name']!,
                    child: Text(
                      drugItem[index]['name']!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                  scrollDirection: Axis.vertical,
                ),
                const SizedBox(
                  height: 3,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 90,
                      child: SingleChildScrollView(
                        child: Text(
                          "${drugItem[index]['price']!} "+ AppLocalizations.of(context)!.le,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.white),
                        ),
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                          color: themeColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: IconButton(
                          color: Colors.white,
                          onPressed: () {
                            navigateTo(
                                context, DrugsInfoEditScreen(index), true);
                          },
                          icon: const Icon(Icons.edit)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
