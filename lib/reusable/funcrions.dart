import 'package:flutter/material.dart';

void navigateTo(BuildContext context, Widget screen, bool push) {
  if (push) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  } else {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}
