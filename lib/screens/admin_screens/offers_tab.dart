import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:pharmacyapp/contsants/themes.dart';
import 'package:pharmacyapp/cubit/admin_cubit.dart';
import 'package:pharmacyapp/cubit/states.dart';
import 'package:pharmacyapp/models/drug_model.dart';
import 'package:pharmacyapp/reusable/components.dart';

class OffersTab extends StatefulWidget {
  const OffersTab({Key? key}) : super(key: key);

  @override
  _OffersTabState createState() => _OffersTabState();
}

class _OffersTabState extends State<OffersTab> {
  final _searchController = TextEditingController();
  bool switcher = false;
  TextEditingController percValue = TextEditingController(text: '30');
 int radioValue = 1;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        AdminCubit cubit = AdminCubit.get(context);

        return GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(FocusNode());
            },
          child: AnimatedSwitcher(
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
            child: switcher? Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                TypeAheadField<Drug>(
                  suggestionsCallback: (text) => cubit.findInDataBase(subName: text),
                  onSuggestionSelected: (suggestion) {
                    _searchController.clear();
                    cubit.addToCart(suggestion);
                  },
                  itemBuilder: (context, drug) {
                    return ListTile(
                      minLeadingWidth: 25,
                      title: Text(drug.name),
                      subtitle: Text("price : ${drug.price}"),
                      leading: SizedBox(
                        width: 25,
                        child: drug.picture
                            .toString()
                            .contains("dalilaldwaa")
                            ? Image.network(
                          drug.picture!,
                          errorBuilder: (_, __, ___) {
                            return CircleAvatar(
                              backgroundColor: themeColor,
                              child: Text(
                                drug.name.toString().length < 2
                                    ? " "
                                    : drug.name
                                    .toString()
                                    .substring(0, 2),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 8),
                              ),
                            );
                          },
                        )
                            : CircleAvatar(
                          backgroundColor: themeColor,
                          child: Text(
                            drug.name.toString().length < 2
                                ? " "
                                : drug.name
                                .toString()
                                .substring(0, 2),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8),
                          ),
                        ),
                      ),
                    );
                  },
                  textFieldConfiguration: TextFieldConfiguration(
                    decoration: InputDecoration(
                        labelText: 'Search',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.cancel_outlined),
                          onPressed: () =>
                          _searchController.text = "",
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.blueGrey, width: 1),
                          borderRadius: BorderRadius.circular(40),
                        )),
                    controller: _searchController,
                  ),
                  //hasOverlay: true,
                  //marginColor: Colors.deepOrange,
                ),
                  const SizedBox(height: 60,),
                  //const Text("Item Selected",style: TextStyle(fontSize: 25),),
                  const Text("Panadol 50 mg 30Taps",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                  Row(
                    children: [
                      Radio(
                        groupValue: radioValue,
                        value: 1,
                        onChanged: (value) {
                          setState(() {
                            radioValue = value as int;
                        }); },),
                      const Text("Percentage"),
                      Radio(
                          groupValue:radioValue,
                          value: 2,
                          onChanged: (value) {
                            setState(() {
                              radioValue = value as int;
                            });}),
                      const Text("Real value")
                    ],
                  ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 170,
                        child: defaultTextField(
                            prefixIcon: Icons.monetization_on_rounded,
                            validateString: '', label: 'Value',
                            controller: percValue),
                      ),
                      const SizedBox(width: 10,),
                      AnimatedSwitcher(
                          duration: const Duration(seconds: 2),
                          reverseDuration: const Duration(milliseconds: 500),
                          switchInCurve: Curves.elasticOut,
                          switchOutCurve: Curves.easeIn,
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            return ScaleTransition(
                              scale: animation,
                              child: child,
                            );
                          },
                          child: radioValue==2? const Text("LE",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),key: Key('20'),):
                           const Text("%",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),key: Key('10'),)
                      )
                    ],
                  ),
                  Center(
                    child: ElevatedButton.icon(
                      label: const Text("Confirm"),
                      icon: const Icon(Icons.done),
                      style: ElevatedButton.styleFrom(
                        primary: themeColor,
                      ),
                      onPressed: () {
                        setState(() {
                          switcher = false;
                        });
                      },
                    ),
                  ),
              ],),
            )
                :Column(
              children: [

                Expanded(
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: 3,//cubit.offersList.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int i) {
                        return Slidable(

                          useTextDirection: true,
                          startActionPane: ActionPane(
                            extentRatio: 0.4,
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                flex: 3,
                                onPressed: (BuildContext context) {},
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child: Card(
                            margin: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0.0),
                            child: SizedBox(
                              height: 80,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      children:  const [
                                        Text("Panadol Extra 50Mg",
                                          //item.drug.name,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 18,),
                                        ),
                                        Text("30%",
                                          //item.drug.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w900),
                                        ),

                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: themeColor, width: 5),
                                    ),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                      const Icon(
                                        Icons.report_gmailerrorred_outlined,
                                        size: 25,),
                                      imageUrl: "http://tal-shop.com/216-home_default/serum-eclaircissante-bb-clear-30ml.jpg",
                                    ),
                                  ),
                                ],),
                            ),
                          ),
                        );
                      }),
                ),
                ElevatedButton.icon(
                  label: const Text("Add new offer"),
                  icon: const Icon(Icons.add_circle_sharp),
                  style: ElevatedButton.styleFrom(
                    primary: themeColor,
                    //  fixedSize: const Size(250, 35.0),
                    // shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(80))
                  ),
                  onPressed: () {
                    setState(() {
                      switcher = true;
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
