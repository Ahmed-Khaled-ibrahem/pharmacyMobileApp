import 'package:dash_chat/dash_chat.dart';
import 'package:pharmacyapp/cubit/operation_cubit.dart';
import 'package:pharmacyapp/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../contsants/const_colors.dart';
import '../../reusable/components.dart';

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
        // AppCubit cubit = AppCubit.get(context);

        final ChatUser user = ChatUser(
          name: "Fayeed",
          uid: "123456789",
          avatar:
              "https://www.wrappixel.com/ampleadmin/assets/images/users/4.jpg",
        );

        // List<ChatMessage> messages = [];
        // List<ChatMessage> m = [];
        // int i = 0;

        return Scaffold(
            appBar: myAppBar("Direct Chatting", themeColor),
            body: InkWell(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: DashChat(
                onSend: (v) {},
                parsePatterns: <MatchText>[
                  MatchText(
                      //type: "email",
                      onTap: (String value) {}),
                  MatchText(
                      pattern: r"\B#+([\w]+)\b",
                      style: const TextStyle(
                        color: Colors.pink,
                        fontSize: 24,
                      ),
                      onTap: (String value) {}),
                ],
                messages: const [],
                user: user,
              ),
            ));
      },
    );
  }
}
