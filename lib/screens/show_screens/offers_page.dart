import 'package:pharmacyapp/cubit/operation_cubit.dart';
import 'package:pharmacyapp/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacyapp/models/offer_model.dart';
import 'package:pharmacyapp/contsants/themes.dart';
import '../../../reusable/components.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({Key? key}) : super(key: key);

  @override
  _OffersScreenState createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        AppCubit cubit = AppCubit.get(context);

        return Scaffold(
            appBar: myAppBar(text: AppLocalizations.of(context)!.current_offers, context: context),
            body: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: cubit.offersList.length,
                      separatorBuilder: (_, index) => const Divider(),
                      itemBuilder: (_, index) {
                        OfferItem item = cubit.offersList[index];
                        return Card(
                          color: Colors.green,
                          child: SizedBox(
                            height: 80,
                            child: Stack(
                              children: [
                                Positioned(
                                    bottom: 0,
                                    left: 5,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                themeColor),
                                      ),
                                      onPressed: () =>
                                          cubit.addToCart(item.drug),
                                      child: Row(
                                        children:  [
                                          const Icon(Icons.shopping_cart),
                                          Text(AppLocalizations.of(context)!.addtocart),
                                        ],
                                      ),
                                    )),
                                Positioned(
                                  top: 10,
                                  left: 10,
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 150,
                                    child: Text(
                                      item.drug.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: themeColor, width: 5),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: photoWithError(
                                        imageLink: item.drug.picture ?? '',
                                        width: 80,
                                        height: 70),
                                  ),
                                ),
                                Positioned(
                                  right: 70,
                                  bottom: -10,
                                  child: Container(
                                    child: Center(
                                      child: Text(
                                        item.percentage
                                            ? "${item.offer}%"
                                            : "${item.offer}"+ AppLocalizations.of(context)!.le,
                                        style: TextStyle(
                                            fontSize: item.percentage ? 20 : 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900),
                                      ),
                                    ),
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: Colors.orangeAccent,
                                      borderRadius: BorderRadius.circular(200),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ));
      },
    );
  }
}
