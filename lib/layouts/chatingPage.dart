import 'package:dash_chat/dash_chat.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacyapp/cubit/signing_cubit.dart';
import 'package:pharmacyapp/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacyapp/reusable/funcrions.dart';
import '../../contsants/const_colors.dart';
import '../../reusable/components.dart';
import 'make_order_page.dart';


class ChatingScreen extends StatefulWidget {
  const ChatingScreen({Key? key}) : super(key: key);

  @override
  _ChatingScreenState createState() => _ChatingScreenState();
}

class _ChatingScreenState extends State<ChatingScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SigningCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        SigningCubit cubit = SigningCubit.get(context);

        final ChatUser user = ChatUser(
          name: "Fayeed",
          uid: "123456789",
          avatar: "https://www.wrappixel.com/ampleadmin/assets/images/users/4.jpg",
        );

        List<ChatMessage> messages = <ChatMessage>[];
        var m = <ChatMessage>[];

        var i = 0;

        
        return Scaffold(
            appBar: myAppBar("Direct Chatting", themeColor),
            body: InkWell(
              onTap: (){ FocusScope.of(context).requestFocus(FocusNode());},
              child: DashChat(
                onSend: (v){},
                  parsePatterns: <MatchText>[
                    MatchText(
                      //type: "email",
                        onTap: (String value) {}
                    ),
                    MatchText(
                        pattern: r"\B#+([\w]+)\b",
                        style: TextStyle(
                          color: Colors.pink,
                          fontSize: 24,
                        ),
                        onTap: (String value) {}
                    ),
                  ], messages: [],
                user: user,
              ),
            ));
      },
    );
  }
}














