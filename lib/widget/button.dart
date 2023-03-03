import 'package:chat_app/theme.dart';
import 'package:flutter/material.dart';

Widget customButton(Size size, String text, Function method) {
  return Container(
    alignment: Alignment.center,
    width: size.width,
    height: size.height / 14,
    decoration: BoxDecoration(
      color: green2,
      borderRadius: BorderRadius.circular(15),
    ),
    child: TextButton(
      style: TextButton.styleFrom(
          fixedSize: Size.fromWidth(size.width),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
      onPressed: method(),
      child: Text(
        text,
        style: semibold14.copyWith(fontSize: 20, color: Colors.white),
      ),
    ),
  );
}

