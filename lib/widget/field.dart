import 'package:chat_app/theme.dart';
import 'package:flutter/material.dart';

Widget field(
    Size size, String label, String hintText, bool autofocus, bool obscure) {
  return SizedBox(
    width: size.width / 1.15,
    child: TextField(
      autocorrect: false,
      obscureText: obscure,
      enableSuggestions: false,
      autofocus: autofocus,
      decoration: InputDecoration(
        labelText: label,

        labelStyle: regular14.copyWith(
          color: green1,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: green1,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.0,
            color: green2,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: dark3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    ),
  );
}
