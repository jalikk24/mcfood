import 'package:flutter/material.dart';
import 'package:mcfood/util/CustomColor.dart';

class CustomDecoration {

  InputDecoration getFormBorder(String hint, double radius) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(
          horizontal: 25, vertical: 15),
      hintText: hint,
      hintStyle: TextStyle(
          fontFamily: "inter600",
          fontSize: 15,
          color: CustomColor.greyBd),
      fillColor: CustomColor.greyFb,
      filled: true,
      isDense: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide:
        BorderSide(width: 2, color: CustomColor.greyE8),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide:
        BorderSide(width: 2, color: CustomColor.greyE8),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide:
        BorderSide(width: 2, color: CustomColor.greyE8),
      ),
    );
  }

  InputDecoration getFormBorderWithIcon(IconData iconData, String hint, double circular, Color color) {
    return InputDecoration(
      prefixIcon: Icon(iconData, size: 25, color: color),
      contentPadding: const EdgeInsets.symmetric(
          horizontal: 25, vertical: 10),
      hintText: hint,
      hintStyle: TextStyle(
          fontFamily: "inter600",
          fontSize: 15,
          color: CustomColor.greyBd),
      fillColor: CustomColor.greyFb,
      filled: true,
      isDense: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(circular),
        borderSide:
        BorderSide(width: 2, color: CustomColor.greyE8),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(circular),
        borderSide:
        BorderSide(width: 2, color: CustomColor.greyE8),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(circular),
        borderSide:
        BorderSide(width: 2, color: CustomColor.greyE8),
      ),
    );
  }

}