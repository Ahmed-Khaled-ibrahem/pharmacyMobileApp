import 'package:page_transition/page_transition.dart';
import 'package:pharmacyapp/cubit/signing_cubit.dart';
import 'package:pharmacyapp/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../contsants/const_colors.dart';
import '../../reusable/components.dart';




class SendPrescriptionScreen extends StatefulWidget {
  const SendPrescriptionScreen({Key? key}) : super(key: key);

  @override
  _SendPrescriptionScreenState createState() => _SendPrescriptionScreenState();
}

class _SendPrescriptionScreenState extends State<SendPrescriptionScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SigningCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        SigningCubit cubit = SigningCubit.get(context);

        return Scaffold(
            appBar: myAppBar("Send Prescription", themeColor),
            body: Column(
              children: [
              ],
            ));
      },
    );
  }
}












