import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:pharmacyapp/contsants/themes.dart';
import 'package:pharmacyapp/contsants/widgets.dart';
import 'package:pharmacyapp/cubit/admin_cubit.dart';
import 'package:pharmacyapp/cubit/states.dart';
import 'package:pharmacyapp/models/drug_model.dart';
import 'package:pharmacyapp/models/offer_model.dart';
import 'package:pharmacyapp/reusable/components.dart';

class OffersTab extends StatefulWidget {
  const OffersTab({Key? key}) : super(key: key);

  @override
  _OffersTabState createState() => _OffersTabState();
}

class _OffersTabState extends State<OffersTab> {
  final _searchController = TextEditingController();
  bool switcher = false;
  TextEditingController offerValue = TextEditingController(text: '30');
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Drug? newDrug;
  bool radioValue = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        AdminCubit cubit = AdminCubit.get(context);

        return GestureDetector(
          onTap: () {
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
            child: switcher
                ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TypeAheadField<Drug>(
                          suggestionsCallback: (text) =>
                              cubit.findInDataBase(subName: text),
                          onSuggestionSelected: (suggestion) {
                            newDrug = suggestion;
                            setState(() {});
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
                                              color: Colors.white, fontSize: 8),
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
                                  onPressed: () => _searchController.clear(),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.blueGrey, width: 1),
                                  borderRadius: BorderRadius.circular(40),
                                )),
                            controller: _searchController,
                          ),
                        ),
                        defaultSpaceH(40),
                        Text(
                          newDrug != null ? newDrug!.name : "Choose drug first",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: newDrug == null ? Colors.blue : null,
                          ),
                        ),
                        Row(
                          children: [
                            Radio<bool>(
                              groupValue: radioValue,
                              value: true,
                              onChanged: (value) {
                                setState(() {
                                  radioValue = value ?? true;
                                });
                              },
                            ),
                            const Text("Percentage"),
                            Radio<bool>(
                                groupValue: radioValue,
                                value: false,
                                onChanged: (value) {
                                  setState(() {
                                    radioValue = value ?? false;
                                  });
                                }),
                            const Text("Real value")
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 170,
                              child: Form(
                                key: formKey,
                                child: defaultTextField(
                                    prefixIcon: Icons.monetization_on_rounded,
                                    validateString: '',
                                    label: 'Value',
                                    controller: offerValue),
                              ),
                            ),
                            defaultSpaceW(10),
                            AnimatedSwitcher(
                                duration: const Duration(seconds: 2),
                                reverseDuration:
                                    const Duration(milliseconds: 500),
                                switchInCurve: Curves.elasticOut,
                                switchOutCurve: Curves.easeIn,
                                transitionBuilder: (Widget child,
                                    Animation<double> animation) {
                                  return ScaleTransition(
                                    scale: animation,
                                    child: child,
                                  );
                                },
                                child: !radioValue
                                    ? const Text(
                                        "LE",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                        key: Key('20'),
                                      )
                                    : const Text(
                                        "%",
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                        key: Key('10'),
                                      ))
                          ],
                        ),
                        defaultSpaceH(20),
                        Center(
                          child: SizedBox(
                            width: 170,
                            height: 50,
                            child: ElevatedButton.icon(
                              label: const Text("Confirm"),
                              icon: const Icon(Icons.done),
                              style: ElevatedButton.styleFrom(
                                primary: themeColor,
                              ),
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  if (newDrug != null) {
                                    cubit.offersList.add(OfferItem(
                                        newDrug!, double.parse(offerValue.text),
                                        isPercentage: radioValue));
                                    cubit.writeOffers();
                                  } else {
                                    EasyLoading.showToast("No drug selected");
                                  }
                                  setState(() {
                                    switcher = false;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: cubit
                                .offersList.length, //cubit.offersList.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              OfferItem item = cubit.offersList[index];
                              return Slidable(
                                useTextDirection: true,
                                startActionPane: ActionPane(
                                  extentRatio: 0.4,
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      flex: 3,
                                      onPressed: (BuildContext context) {
                                        cubit.offersList.removeAt(index);
                                        cubit.writeOffers();
                                      },
                                      icon: Icons.delete,
                                      label: 'Delete',
                                    ),
                                  ],
                                ),
                                child: Card(
                                  margin: const EdgeInsets.fromLTRB(
                                      10.0, 15.0, 10.0, 0.0),
                                  child: SizedBox(
                                    height: 80,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    150,
                                                child: Text(
                                                  item.drug.name,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                item.percentage
                                                    ? "${item.offer}%"
                                                    : "${item.offer} LE",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w900),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: themeColor, width: 5),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: photoWithError(
                                                imageLink:
                                                    item.drug.picture ?? '',
                                                width: 80,
                                                height: 70)),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton.icon(
                            label: const Text("Add new offer"),
                            icon: const Icon(Icons.add_circle_sharp),
                            style: ElevatedButton.styleFrom(
                              primary: themeColor,
                            ),
                            onPressed: () {
                              setState(() {
                                switcher = true;
                              });
                            },
                          ),
                          ElevatedButton.icon(
                            label: const Text("Clear offers"),
                            icon: const Icon(Icons.clear),
                            style: ElevatedButton.styleFrom(
                              primary: themeColor,
                            ),
                            onPressed: () {
                              setState(() {
                                cubit.offersList = [];
                                cubit.writeOffers();
                              });
                            },
                          ),
                        ],
                      )
                    ],
                  ),
          ),
        );
      },
    );
  }
}
