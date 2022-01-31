import 'package:flutter/material.dart';
import 'package:pharmacyapp/contsants/const_colors.dart';
import 'package:pharmacyapp/contsants/widgets.dart';
import 'package:pharmacyapp/reusable/components.dart';
import 'package:pharmacyapp/reusable/funcrions.dart';
import 'package:pharmacyapp/screens/show_screens/search_reasults.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(themeColor),
              ),
              onPressed: () {
                navigateTo(context, SearchResultsScreen(), true);
              },
              child: SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    const Icon(Icons.search),
                    const SizedBox(
                      width: 5,
                    ),
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
              cardDesign('Followers', 200.toString()),
              cardDesign('Orders', 2.toString()),
              cardDesign('Chat', 1.toString()),
              cardDesign('Offers', 6.toString()),
              cardDesign('all day Orders', 15.toString()),
            ],
          ),
          defaultSpaceH(10),
          Row(
            children: [
              defaultSpaceW(15),
              const Text('The Most Ordered List',textAlign: TextAlign.start,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
            ],
          ),
          SizedBox(
            height: 190,
            child: ListView.separated(
              padding: const EdgeInsets.all(15),
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    children: [
                      Text('${index+1} . ${mostWanted[index]}'),
                    ],
                  );
                },
                separatorBuilder: (BuildContext context, int index) {return const Divider();},
                itemCount: mostWanted.length),
          ),
          //const Spacer(),
          const Text('Timing of Delivery',style: TextStyle(fontSize: 20),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            const Text('From',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              defaultSpaceW(5),
            InkWell(
                onTap: (){_selectTime(context, false);},
                child: Text(selectedTimeFrom.format(context).toString(),
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange),)),
              defaultSpaceW(5),
            const Text('To',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            defaultSpaceW(5),
            InkWell(
                onTap: (){_selectTime(context, true);},
                child: Text(selectedTimeTo.format(context).toString(),
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange),)),
          ],),
          AnimatedSwitcher(
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
                ? Card(
              color: themeColor,
              key: const Key('enabledCard'),
              margin: const EdgeInsets.all(20),
              child: InkWell(
                onTap: () {
                  setState(() {
                    ordersIsEnabled = false;
                  });
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.delivery_dining_rounded,
                      size: 60,
                    ),
                    Text(
                      'Orders Enabled',
                      style: TextStyle(
                          fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            )
                : Card(
              color: Colors.red,
              key: const Key('disabledCard'),
              margin: const EdgeInsets.all(20),
              child: InkWell(
                onTap: () {
                  setState(() {
                    ordersIsEnabled = true;
                  });
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.disabled_by_default_rounded,
                      size: 60,
                    ),
                    Text(
                      'Orders Disabled',
                      style: TextStyle(
                          fontSize: 30, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _selectTime(BuildContext context,bool toOrFrom) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      cancelText: 'Cancel',
      confirmText: 'OK',
      context: context,
      initialTime: selectedTimeTo,
      initialEntryMode: TimePickerEntryMode.dial,
    );

    if(timeOfDay != null && timeOfDay != selectedTimeTo && toOrFrom)
    {
      setState(() {
        selectedTimeTo = timeOfDay;
      });
    }
    if(timeOfDay != null && timeOfDay != selectedTimeFrom && !toOrFrom)
    {
      setState(() {
        selectedTimeFrom = timeOfDay;
      });
    }
  }

  Widget cardDesign(String title, String value) {
    return Card(
      elevation: 3,
      shadowColor: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 25),
            ),
            Text(
              value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                  color: Colors.orangeAccent),
            ),
          ],
        ),
      ),
    );
  }
}
