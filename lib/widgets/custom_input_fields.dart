import 'dart:ui';

import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final Function(String) onSaved;
  final String regEx;
  final String hintText;
  final bool obscureText;
  final EdgeInsetsGeometry? contentPadding;
  final int? maxLines;
  final TextInputAction textInputAction;
  const CustomTextFormField(
      {Key? key,
      required this.onSaved,
      required this.regEx,
      required this.hintText,
      required this.obscureText,
      required this.textInputAction,
      this.contentPadding,
      this.maxLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: false,
      textInputAction: textInputAction,
      onSaved: (_value) => onSaved(_value!),
      cursorColor: Colors.white,
      style: TextStyle(
        color: Colors.white,
      ),
      obscureText: obscureText,
      validator: (_value) {
        return RegExp(regEx).hasMatch(_value!) ? null : 'Enter valid value';
      },
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: contentPadding,
        isDense: true,
        hintStyle: TextStyle(
          color: Colors.white,
        ),
        fillColor: Color.fromRGBO(30, 29, 37, 1.0),
        filled: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final Function(String) onEditingComplete;
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  IconData? icon;
  CustomTextField(
      {Key? key,
      required this.onEditingComplete,
      required this.hintText,
      required this.obscureText,
      required this.controller,
      this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onEditingComplete: () => onEditingComplete(controller.value.text),
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white),
      textInputAction: TextInputAction.search,
      obscureText: obscureText,
      decoration: InputDecoration(
        fillColor: Color.fromRGBO(30, 29, 37, 1.0),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.white,
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.white54,
        ),
      ),
    );
  }
}
