import 'package:chat_app/theme.dart';
import 'package:flutter/material.dart';

class FieldText extends StatelessWidget {
  FieldText(
      {super.key,
      required this.obscure,
      required this.autofocus,
      required this.controller,
      required this.label,
      required this.focusNode,
      required this.hintText,});

  final bool obscure;
  final bool autofocus;
  final TextEditingController controller;
  final String label;
  final String hintText;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width / 1.15,
      child: TextFormField(
        autocorrect: false,
        focusNode: focusNode,
        obscureText: obscure,
        enableSuggestions: false,
        autofocus: autofocus,
        controller: controller,
        textInputAction: TextInputAction.next,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please fill this field';
          }
          return null;
        },
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
}
