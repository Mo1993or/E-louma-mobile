import 'package:E_louma/Utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

showAlertDialog(BuildContext context) {
  print("access load");
  AlertDialog alert = AlertDialog(
      content: Center(
          child: LoadingAnimationWidget.twistingDots(
    leftDotColor: primaryColor,
    rightDotColor: Colors.black,
    size: 200,
  )));
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return Center(
          child: LoadingAnimationWidget.twistingDots(
        leftDotColor: primaryColor,
        rightDotColor: Colors.black,
        size: 80,
      ));
    },
  );
}
