import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacyapp/cubit/cubit.dart';
import 'package:pharmacyapp/cubit/states.dart';

import '../contsants/const_colors.dart';
import '../reusable/components.dart';

class ForgetPassPage extends StatelessWidget {
  const ForgetPassPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {},
        builder: (BuildContext context, AppStates state) {
          // AppCubit cubit = AppCubit.get(context);

          return Scaffold(
            appBar: myAppBar("Forget Password", themeColor),
          );
        });
  }
}
