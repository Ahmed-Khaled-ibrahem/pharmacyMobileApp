import 'package:flutter/material.dart';
import 'package:pharmacyapp/contsants/const_colors.dart';
import 'package:pharmacyapp/contsants/widgets.dart';
import 'package:pharmacyapp/reusable/funcrions.dart';
import 'package:pharmacyapp/screens/show_screens/search_reasults.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainTap extends StatefulWidget {
  const MainTap({Key? key}) : super(key: key);

  @override
  _MainTapState createState() => _MainTapState();
}

class _MainTapState extends State<MainTap> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: defaultScrollPhysics,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 15.0),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all(themeColor),
              ),
              onPressed: () {
                navigateTo(
                    context, SearchResultsScreen(), true);
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

        ],
      ),
    );
  }
}

