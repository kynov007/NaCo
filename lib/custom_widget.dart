import 'package:flutter/material.dart';

import 'app_color.dart';

class CustomWidget {
  static Text customText({
    required String teks,
    double? fontSize,
    required Color color,
  }) {
    return Text(
      teks,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: fontSize ?? 34,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }

  static Container buildCircleContainer(
      {required String text, double? height, double? width, Color? warna}) {
    return Container(
      height: height ?? 22,
      // height: double.maxFinite,
      width: width ?? 22,
      decoration:
          BoxDecoration(shape: BoxShape.circle, color: warna ?? Colors.red),
      child: Center(
          child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      )),
    );
  }

  static Container customContainer({required String teks}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black,
      ),
      padding: const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
      child: customText(teks: teks, color: whiteColor),
    );
  }

  static Widget buildCurveTitle(
      {required String title,
      double? leftPadding,
      double? rightPadding,
      double? topPadding,
      double? bottomPadding}) {
    return Row(
      children: [
        Container(
            // width: 140,
            padding: EdgeInsets.only(
                left: leftPadding ?? 10,
                right: rightPadding ?? 30,
                bottom: bottomPadding ?? 6,
                top: topPadding ?? 0),
            decoration: BoxDecoration(
              color: ButtonColor,
              borderRadius:
                  const BorderRadius.only(bottomRight: Radius.circular(40)),
            ),
            child: CustomWidget.customText(teks: title, color: blackColor)),
      ],
    );
  }
}
