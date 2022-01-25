import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:pharmacyapp/contsants/const_colors.dart';
import 'package:pharmacyapp/cubit/admin_cubit.dart';
import 'package:pharmacyapp/cubit/states.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliveryTab extends StatefulWidget {
  const DeliveryTab({Key? key}) : super(key: key);

  @override
  _DeliveryTabState createState() => _DeliveryTabState();
}

class _DeliveryTabState extends State<DeliveryTab> {
  int? _activeMeterIndex = 1000;

  //we can use Drug ID inistedof all Drug data
  List<Map<String,String>> itemsList = [
    {'name':'Panadol Extra50 Mg','quantity':'1','price':'20'},
    {'name':'Antinal 50 Mg','quantity':'1','price':'17.5'},
    {'name':'Close up 30 gm','quantity':'2','price':'12'},
    {'name':'Tooth Brush','quantity':'2','price':'8'},
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        // AdminCubit cubit = AdminCubit.get(context);

        return Stack(
          children: [
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (BuildContext context, int i) {
                  return Card(
                    margin: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0.0),
                    child: ExpansionPanelList(
                      animationDuration: const Duration(seconds: 1),
                      expansionCallback: (int index, bool status) {
                        setState(() {
                          _activeMeterIndex = _activeMeterIndex == i ? null : i;
                        });
                      },
                      children: [
                        ExpansionPanel(
                            canTapOnHeader: true,
                            backgroundColor: _activeMeterIndex == i ? Colors.teal.withOpacity(0.5) : null,
                            isExpanded: _activeMeterIndex == i,
                            headerBuilder: (BuildContext context, bool isExpanded) =>
                                 ListTile(
                                  horizontalTitleGap: 20,
                                  style: ListTileStyle.list,
                                  trailing: const Text("10 KM",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold)),
                                  leading:   CircleAvatar(
                                    backgroundColor:
                                    Theme.of(context).primaryColor,
                                    radius: 30,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: CachedNetworkImage(
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) => const Icon(Icons.person, size: 40,),
                                        imageUrl: "https://images.unsplash.com/photo-1547425260-76bcadfb4f2c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxjb2xsZWN0aW9uLXBhZ2V8OXw4NzcyOTI0fHxlbnwwfHx8fA%3D%3D&w=1000&q=80",
                                      ),
                                    ),
                                  ),
                                  subtitle: const Text("01188534457",
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                  title: const Text("Ali 7fnawy"),
                                ),
                            body: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children:  [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Text("Time  ",style: TextStyle(color: Colors.cyan,fontSize: 20,fontWeight: FontWeight.bold),),
                                    Text("3:40 PM"),
                                  ],
                                ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children:   const [
                                      Text("Address  ",style: TextStyle(color: Colors.cyan,fontSize: 20,fontWeight: FontWeight.bold),),
                                      SizedBox(
                                          width: 220,
                                          child: Text(" شارع سعيد الجندي الحضره القبليه الدور السابع عماره 45 شقه13")),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton.icon(
                                          icon: const Icon(Icons.location_on),
                                          label: const Text("Open Location in Map"),
                                          style: ElevatedButton.styleFrom(
                                              primary: themeColor,
                                              //fixedSize: const Size(250, 35.0),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(80))),
                                          onPressed: () {
                                            openMap(31.2062316,29.9111692);
                                          }),
                                      ElevatedButton(
                                          child: const Icon(Icons.chat_rounded),
                                          style: ElevatedButton.styleFrom(
                                              primary: themeColor,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(80))),
                                          onPressed: () {
                                          }),
                                    ],
                                  ),
                                const Text("Items List",style: TextStyle(color: Colors.cyan,fontSize: 20,fontWeight: FontWeight.bold),),
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children:  [
                                     Column(
                                       //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                       crossAxisAlignment: CrossAxisAlignment.stretch,
                                       children: itemsList.map((e) =>
                                           Row(
                                             children: [
                                               Text("${itemsList.indexOf(e)+1}. "
                                                   "${e['name']}   "),
                                               const Spacer(),
                                               Text("${e['quantity']} *"
                                                   " ${e['price']} LE"),
                                             ],
                                           ),)
                                           .toList(),),
                                      Text("+ 10 LE delivery"),
                                        Text("Total = ${calcSum().toString()} LE",style: TextStyle(color: Colors.cyan,fontSize: 20,fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                  Center(
                                    child: ElevatedButton.icon(
                                        label: const Text("Done Delivered"),
                                        icon: const Icon(Icons.done_outline_rounded),
                                        style: ElevatedButton.styleFrom(
                                            primary: themeColor,
                                            fixedSize: const Size(250, 35.0),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(80))),
                                        onPressed: () {
                                        }),
                                  ),
                              ],),
                            ),
                        ),
                      ],
                    ),
                  );
                }),
          ],
        );
      },
    );
  }
  double calcSum(){
    double sum = 0;
    for (var element in itemsList) {sum += double.parse( element['price']!); }
    return sum;
  }
   Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }}
}
