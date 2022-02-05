import 'package:pharmacyapp/cubit/operation_cubit.dart';
import 'package:pharmacyapp/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacyapp/screens/admin_screens/chat_body_page.dart';
import '../../../reusable/components.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChattingScreen extends StatefulWidget {
  const ChattingScreen({Key? key}) : super(key: key);

  @override
  _ChattingScreenState createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          backgroundColor:
              cubit.themeState == "Light" ? null : ThemeData.dark().canvasColor,
          appBar: myAppBar(text: AppLocalizations.of(context)!.direct_chatting, context: context),
          body: const ChatBodyScreen(),
        );
      },
    );
  }
}
