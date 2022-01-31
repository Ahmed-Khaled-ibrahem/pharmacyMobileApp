import 'package:flutter/cupertino.dart';

 Widget defaultSpaceW(double w){
   return SizedBox(
     width: w,
   );
 }

 Widget defaultSpaceH(double h){
   return SizedBox(
     height: h,
   );
 }

const ScrollPhysics defaultScrollPhysics = BouncingScrollPhysics();
